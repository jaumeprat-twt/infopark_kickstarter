require 'spec_helper'

require 'generator_spec/test_case'
require 'rails/generators/test_case'
require 'generators/cms/widget/slider/example/example_generator.rb'

describe Cms::Generators::Widget::Slider::ExampleGenerator do
  include GeneratorSpec::TestCase

  destination File.expand_path('../../../../tmp/generators', __FILE__)

  before do
    prepare_destination
    prepare_environments
    run_generator
  end

  def prepare_environments
  end

  it 'creates files' do
    destination_root.should have_structure {
      directory 'app' do
        directory 'widgets' do
          directory 'slider_widget' do
            directory 'migrate' do
              migration 'create_slider_widget_example'
            end
          end
        end
      end
    }
  end
end
