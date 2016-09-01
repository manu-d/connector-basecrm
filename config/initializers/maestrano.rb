puts "ENV: #{ENV}"
Maestrano.auto_configure(File.expand_path('config/dev_platform.yml')) unless Rails.env.test?
