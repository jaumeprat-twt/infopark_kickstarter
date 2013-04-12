require 'spec_helper'

require 'generator_spec/test_case'
require 'rails/generators/test_case'
require 'generators/cms/widget/slider/slider_generator.rb'
require 'generators/cms/attribute/api/api_generator'
require 'generators/cms/model/api/api_generator'

describe Cms::Generators::Widget::SliderGenerator do
  include GeneratorSpec::TestCase

  destination File.expand_path('../../../../tmp', __FILE__)

  arguments ['--example']

  before(:all) do
    Cms::Generators::Attribute::ApiGenerator.send(:include, TestDestinationRoot)
    Cms::Generators::Model::ApiGenerator.send(:include, TestDestinationRoot)
  end

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
        directory 'cells' do
          directory 'widget' do
            file 'slider_widget_cell.rb'

            directory 'slider_widget' do
              file 'show.html.haml'
              file 'image.html.haml'
              file 'images.html.haml'
              file 'indicators.html.haml'
              file 'left_control.html.haml'
              file 'right_control.html.haml'
              file 'title.html.haml'
            end
          end
        end

        directory 'models' do
          file 'slider_widget.rb' do
            contains 'include Cms::Attributes::SortKey'
            contains 'include Cms::Attributes::SliderImages'
            contains 'include Widget'
          end
        end

        directory 'concerns' do
          directory 'cms' do
            directory 'attributes' do
              file 'sort_key.rb'
              file 'slider_images.rb'
            end
          end
        end

        directory 'widgets' do
          directory 'slider_widget' do
            file 'show.html.haml'
            file 'thumbnail.html.haml'

            directory 'locales' do
              file 'de.slider_widget.yml'
              file 'en.slider_widget.yml'
            end
          end
        end
      end

      directory 'cms' do
        directory 'migrate' do
          migration 'create_slider_widget'
          migration 'create_slider_widget_example'
        end
      end

      directory 'spec' do
        directory 'models' do
          file 'slider_widget_spec.rb'
        end
      end
    }
  end
end