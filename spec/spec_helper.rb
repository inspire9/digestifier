require 'bundler'

Bundler.setup :default, :development

require 'combustion'
require 'digestifier'

Combustion.initialize! :action_controller, :active_record, :action_mailer

require 'rspec/rails'

Dir["./spec/support/**/*.rb"].each { |file| require file }

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.include RSpec::Rails::RequestExampleGroup, type: :request,
    example_group: {file_path: /spec\/acceptance/}
end
