ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb', __FILE__)
require 'rspec/rails'

require 'support/test_destination_root'
require 'generators/cms/model/api/api_generator'
require 'generators/cms/widget/api/api_generator'
require 'generators/cms/controller/controller_generator'

Rails.backtrace_cleaner.remove_silencers!

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.infer_base_class_for_anonymous_controllers = false
  config.filter_run :focus
  config.mock_with :rspec
  config.order = 'random'

  config.before do
    Cms::Generators::Model::ApiGenerator.send(:include, TestDestinationRoot)
    Cms::Generators::ControllerGenerator.send(:include, TestDestinationRoot)
    Cms::Generators::Widget::ApiGenerator.send(:include, TestDestinationRoot)
  end
end