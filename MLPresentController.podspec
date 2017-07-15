Pod::Spec.new do |s|
s.name         = "MLPresentController"
s.version      = "1.2.0"
s.summary      = "Present ViewController with custom animator and support interactiving with UIPanGestureRecognizer. (iOS 7+)"

s.homepage     = 'https://github.com/molon/MLPresentController'
s.license      = { :type => 'MIT'}
s.author       = { "molon" => "dudl@qq.com" }

s.source       = {
:git => "https://github.com/molon/MLPresentController.git",
:tag => "#{s.version}"
}

s.platform     = :ios, '7.0'
s.source_files  = 'Classes/**/*.{h,m}'
s.requires_arc  = true
end