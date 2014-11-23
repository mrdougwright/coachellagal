source 'http://rubygems.org'
# ruby '2.0.0'

## Bundle rails:
gem 'rails', '4.0.4'
#gem 'heroku-api'
#gem 'heroku'
#gem 'taps'

gem 'uglifier'
gem 'sass-rails'

gem "american_date"
gem 'authlogic' #, github: 'binarylogic/authlogic', ref: 'e4b2990d6282f3f7b50249b4f639631aef68b939'
gem 'aws-sdk'
gem 'bluecloth'
gem 'cancan'
gem 'compass'
gem 'compass-rails'
gem 'compass-blueprint'
gem 'chronic'
gem 'dalli'

gem 'dynamic_form'#, '~> 1.1.4'
gem "friendly_id"
#gem 'haml',  ">= 3.0.13"#, ">= 3.0.4"#, "2.2.21"#,
gem "gibbon"
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'json'

gem 'mandrill-api'#, :git => 'git@github.com:drhenner/mandrill-api-ruby.git'
# gem 'nested_set', '~> 1.7.0'
gem 'awesome_nested_set'

gem "nifty-generators", :git => 'git://github.com/drhenner/nifty-generators.git'
gem 'nokogiri'
gem 'paperclip'
gem 'prawn'

gem "rails3-generators"
#gem "rails3-generators", :git => "https://github.com/neocoin/rails3-generators.git"
gem "rails_config"
gem 'rmagick',    :require => 'RMagick'

gem 'rake'
gem 'rubyzip'
gem 'simple_xlsx_writer'#, '~> 0.5.3'
gem 'state_machine'
gem 'stripe'
#gem 'sunspot_solr'
#gem 'sunspot_rails', '~> 1.3.0rc'
gem 'will_paginate'
gem 'resque', require: 'resque/server'
gem 'unicorn'
gem 'zurb-foundation'
gem "sprockets", "2.11.0" # added by me

group :production, :staging do
  gem 'pg'
  gem "airbrake"
  gem 'newrelic_rpm'
  gem 'rails_12factor'
end

group :development do
  #gem 'awesome_print'
  #gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
  gem "autotest-rails-pure"
  gem "better_errors"
  gem "foreman"
  gem "letter_opener"
  gem "rails-erd"
  # gem 'mysql2' ...I use PG on dev...

  # YARD AND REDCLOTH are for generating yardocs
  #gem 'yard'
  #gem 'RedCloth'
end
group :test, :development do
  gem 'capybara'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'dotenv-rails'
  gem 'pry'
end

group :test do
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'mocha', :require => false
  gem 'rspec-rails-mocha'
  gem 'rspec-rails'

  gem 'email_spec'
  gem 'resque_spec'
  gem "faker"
  gem "autotest"
  gem "autotest-rails-pure"

  gem "autotest-growl"
  gem "ZenTest"

end
