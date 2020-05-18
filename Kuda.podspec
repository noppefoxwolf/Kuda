Pod::Spec.new do |s|
  s.name             = 'Kuda'
  s.version          = '0.1.0'
  s.summary          = 'A short description of Kuda.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/noppefoxwolf/Kuda'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'noppe' => 'noppelabs@gmail.com' }
  s.source           = { :git => 'git@github.com:noppefoxwolf/Kuda.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/noppefoxwolf'
  s.ios.deployment_target = '13.0'
  s.source_files = 'Kuda/Classes/**/*'
  s.swift_version = '5.0'
end
