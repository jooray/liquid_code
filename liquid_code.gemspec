Gem::Specification.new do |s|
  s.name        = 'liquid_code'
  s.version     = '0.1.0'
  s.date        = '2016-06-18'
  s.summary     = "Generate QR codes with rounded corners"
  s.description = "This library uses ImageMagick and RQRCode to create QR codes with rounded corners"
  s.authors     = ["Juraj Bednar"]
  s.email       = 'juraj@bednar.sk'
  s.files       = ["lib/liquid_code.rb"]
  s.homepage    =
      'https://github.com/jooray/liquid-code'
  s.license       = 'MIT'
  s.add_runtime_dependency 'rmagick', '~> 2.15'
  s.add_runtime_dependency 'rqrcode', '~> 0.10'
  s.add_runtime_dependency 'activesupport', '~> 4.2'
end
