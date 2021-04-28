Pod::Spec.new do |spec|
    spec.name               = 'RVS_Spinner'
    spec.summary            = 'An iOS Swift Framework that provides a powerful and usable "prize wheel" spinner control.'
    spec.description        = 'The RVS_Spinner is a Swift shared framework designed to allow easy implementation of a powerful, high-usability multi-value selector.'
    spec.version            = '2.5.1'
    spec.platform           = :ios, '13.0'
    spec.homepage           = 'https://riftvalleysoftware.com/work/open-source-projects/'
    spec.social_media_url   = 'https://twitter.com/GrtRiftValley'
    spec.author             = { 'The Great Rift Valley Software Company' => 'chris@riftvalleysoftware.com' }
    spec.documentation_url  = 'https://riftvalleysoftware.github.io/RVS_Spinner/'
    spec.license            = { :type => 'MIT', :file => 'LICENSE' }
    spec.source             = { :git => 'https://github.com/RiftValleySoftware/RVS_Spinner.git', :tag => spec.version.to_s }
    spec.source_files       = 'Sources/RVS_Spinner/RVS_Spinner.swift'
    spec.swift_version      = '5.0'
    spec.ios.framework      = 'UIKit'
end
