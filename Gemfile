source "https://rubygems.org"

# Declare your gem's dependencies in metasploit-credential.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# This isn't in gemspec because metasploit-framework has its own patched version of 'net/ssh' that it needs to use
# instead of this gem.
# Metasploit::Credential::SSHKey validation and helper methods
gem 'net-ssh'

# Patching inverse association in Mdm models.
gem 'metasploit-concern', github: 'crmaxx/metasploit-concern', branch: 'staging/rails-4.2'

# Metasploit::Model::Search
gem 'metasploit-model', github: 'crmaxx/metasploit-model', branch: 'staging/rails-4.2'

# Various Metasploit::Credential records have associations to Mdm records
gem 'metasploit_data_models', github: 'crmaxx/metasploit_data_models', branch: 'staging/rails-4.2'

group :development do
  # markdown formatting for yard
  gem 'kramdown', platforms: :jruby
  # Entity-Relationship diagrams for developers that need to access database using SQL directly.
  gem 'rails-erd'
  # markdown formatting for yard
  gem 'redcarpet', platforms: :ruby
  # documentation
  # 0.8.7.4 has a bug where setters are not documented when @!attribute is used
  gem 'yard', '< 0.8.7.4'
end

group :development, :test do
  # Hash password for Metasploit::Credential::PasswordHash factories
  gem 'bcrypt'
  # Uploads simplecov reports to coveralls.io
  gem 'coveralls', require: false
  # supplies factories for producing model instance for specs
  # Version 4.1.0 or newer is needed to support generate calls without the 'FactoryGirl.' in factory definitions syntax.
  gem 'factory_girl', '>= 4.1.0'
  # auto-load factories from spec/factories
  gem 'factory_girl_rails'
  # jquery-rails is used by the dummy application
  gem 'jquery-rails'
  # add matchers from shoulda, such as validates_presence_of, which are useful for testing validations, and have_db_*
  # for testing database columns and indicies.
  gem 'shoulda-matchers'
  # code coverage of tests
  gem 'simplecov', require: false
  # dummy app
  gem 'rails', '>= 4.2.1'
  # unit testing framework with rails integration
  gem 'rspec-rails', '~> 3.1'
end
