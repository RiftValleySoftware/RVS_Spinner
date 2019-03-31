Pod::Spec.new do |spec|
    spec.name                       = 'RVS_Spinner'
    spec.summary                    = 'An iOS Swift Framework that provides a powerful and usable "prize wheel" spinner control.'
    spec.description                = 'The RVS_Spinner is a Swift shared framework designed to allow easy implementation of a powerful, high-usability multi-value selector.'
    spec.module_name                = 'RVS_Spinner'
    spec.version                    = '1.0.6'
    spec.platform                   = :ios, '11.0'
    spec.homepage                   = 'https://riftvalleysoftware.com/work/open-source-projects/#RVS_Spinner'
    spec.author                     = { 'The Great Rift Valley Software Company' => 'chris@riftvalleysoftware.com' }
    spec.documentation_url          = 'https://riftvalleysoftware.com/RVS_Spinner'
    spec.license                    = { :type => 'MIT', :file => 'LICENSE' }
    spec.source                     = { :git => 'https://github.com/RiftValleySoftware/RVS_Spinner.git', :tag => spec.version.to_s }
    spec.ios.framework              = 'UIKit'
    spec.source_files               = 'RVS_Spinner/RVS_Spinner.swift'
    spec.swift_version              = '5.0'
end
