Pod::Spec.new do |spec|
  spec.name             = 'Rubick'
  spec.version          = '0.1.0'
  spec.summary          = 'iOS component collection.'
  
  spec.description      = <<-DESC
    # Rubick
    iOS component collection.
    ## Why use this?
    balabala...
    ## Usage
                       DESC

  spec.homepage         = 'https://github.com/langyanduan/Rubick'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { 'langyanduan' => 'langyanduan@qq.com' }
  spec.source           = { :git => 'https://github.com/langylanduan/Rubick.git', :tag => spec.version.to_s }
  spec.social_media_url = 'https://twitter.com/langyanduan'

  spec.ios.deployment_target = '8.0'
  spec.default_subspec = ['Core', 'Extension']

  # Subspecs
  spec.subspec 'Core' do |core|
    core.source_files = [
    ]
  end
  
  spec.subspec 'Extension' do |extension|
    extension.source_files = [
      'Sources/Extension/*.swift'
    ]
    extension.dependency 'Rubick/Core'
  end
  
end