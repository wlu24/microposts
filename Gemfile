source 'https://rubygems.org'

gem 'rails',        '5.1.4'
gem 'bootstrap-sass', '3.3.7'
gem 'puma',         '3.9.1'
gem 'sass-rails',   '5.0.6'
gem 'uglifier',     '3.2.0'
gem 'coffee-rails', '4.2.2'
gem 'jquery-rails', '4.3.1'
gem 'turbolinks',   '5.0.1'
gem 'jbuilder',     '2.7.0'


# Ch6, needed for has_secure_password
# provides 'has_secure_password', currently used in user.rb
gem 'bcrypt',         '3.1.11'

# Ch 10.3.2 Sample users
#
# Ordinarily, you’d probably want to restrict the faker gem to a development
# environment, but in the case of the sample app we’ll be using it on our
# production site as well
gem 'faker',          '1.7.3'


gem 'will_paginate',           '3.1.6'
gem 'bootstrap-will_paginate', '1.0.0'


# CH 13.4 Micropost images
gem 'carrierwave',             '1.1.0'
gem 'mini_magick',             '4.7.0'
gem 'fog-aws',                 '2.0.0'
# We wouldn’t ordinarily need to specify a dependency like nokogiri explicitly, 
# but it turns out the dependency specification in fog-aws allows for an earlier,
# insecure version of nokogiri, so we need to take the care to update the version
# number by hand
gem 'nokogiri',                '1.8.1'  # fog-aws dependency gem

group :development, :test do
  gem 'sqlite3', '1.3.13'
  gem 'byebug',  '9.0.6', platform: :mri
end

group :development do
  gem 'web-console',           '3.5.1'
  gem 'listen',                '3.0.8'
  gem 'spring',                '2.0.2'
  gem 'spring-watcher-listen', '2.0.1'
end

group :test do
  gem 'rails-controller-testing', '1.0.2'
  gem 'minitest-reporters',       '1.1.14'
  gem 'guard',                    '2.13.0'
  gem 'guard-minitest',           '2.4.4'
end

group :production do
  gem 'pg', '0.18.4'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
