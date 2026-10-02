#!/bin/bash
# Build library documentation, or a local archive that also contains the harness apps.
set -euo pipefail

include_harnesses=false
case "${1:-}" in
    "") ;;
    --include-harnesses) include_harnesses=true ;;
    -h|--help)
        printf 'Usage: %s [--include-harnesses]\n' "$0"
        exit 0
        ;;
    *) printf 'Unknown argument: %s\n' "$1" >&2; exit 2 ;;
esac
if (( $# > 1 )); then
    printf 'Expected at most one argument.\n' >&2
    exit 2
fi

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
documentation_root="$repository_root/.build/documentation"
scheme='RVS_Spinner Framework'
build_mode=library
if "$include_harnesses"; then
    scheme='RVS_Spinner Local Documentation'
    build_mode=local
    if ! xcrun docc merge --help >/dev/null 2>&1; then
        printf 'The selected Xcode toolchain must support docc merge for a combined archive.\n' >&2
        exit 1
    fi
fi
derived_data="$documentation_root/$build_mode"
archive_directory="$derived_data/Build/Products/Debug-iphonesimulator"

xcodebuild docbuild \
    -project "$repository_root/RVS_Spinner.xcodeproj" \
    -scheme "$scheme" \
    -configuration Debug \
    -destination 'generic/platform=iOS Simulator' \
    -derivedDataPath "$derived_data" \
    SYMROOT="$derived_data/Build/Products" \
    OBJROOT="$derived_data/Build/Intermediates.noindex" \
    DOCC_OUTPUT_DIR="$archive_directory" \
    CODE_SIGNING_ALLOWED=NO \
    'OTHER_DOCC_FLAGS=$(inherited) --warnings-as-errors'

if "$include_harnesses"; then
    combined_archive="$documentation_root/RVS_Spinner-Local.doccarchive"
    # DocC requires an empty output location. Merge before replacing the previous result.
    merge_directory="$(mktemp -d "$documentation_root/merge.XXXXXX")"
    trap 'rm -rf "$merge_directory"' EXIT
    xcrun docc merge \
        "$archive_directory/RVS_Spinner.doccarchive" \
        "$archive_directory/RVS_Spinner_Basic_Test_Harness.doccarchive" \
        "$archive_directory/RVS_SPinner_HUD_Test_Harness.doccarchive" \
        "$archive_directory/RVS_Spinner_Tabbed_Test_Harness.doccarchive" \
        "$archive_directory/RVS_Spinner_Leak_Test.doccarchive" \
        --synthesized-landing-page-name 'RVS_Spinner and Test Harnesses' \
        --synthesized-landing-page-kind 'Local Documentation' \
        --output-path "$merge_directory/RVS_Spinner-Local.doccarchive"
    rm -rf "$combined_archive"
    mv "$merge_directory/RVS_Spinner-Local.doccarchive" "$combined_archive"
    printf '\nDocumentation archive: %s\n' "$combined_archive"
else
    printf '\nDocumentation archive: %s\n' "$archive_directory/RVS_Spinner.doccarchive"
fi
