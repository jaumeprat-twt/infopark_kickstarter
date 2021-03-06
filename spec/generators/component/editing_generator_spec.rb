require 'spec_helper'

require 'generator_spec/test_case'
require 'generators/cms/component/editing/editing_generator'

describe Cms::Generators::Component::EditingGenerator do
  include GeneratorSpec::TestCase

  destination File.expand_path('../../../../tmp/generators', __FILE__)
  arguments ['--editor=redactor']

  before do
    # We are calling a sub generator, so we need to make sure to set the correct destination root for
    # the test. This is not done globally, as this is the only test, were the sub generator is called.
    require 'generators/cms/component/editing/redactor/redactor_generator'
    Cms::Generators::Component::Editing::RedactorGenerator.send(:include, TestDestinationRoot)

    prepare_destination
    prepare_environments
    run_generator
  end

  def prepare_environments
    javascripts_path = "#{destination_root}/app/assets/javascripts"
    stylesheets_path = "#{destination_root}/app/assets/stylesheets"

    mkdir_p(javascripts_path)
    mkdir_p(stylesheets_path)

    File.open("#{destination_root}/Gemfile", 'w')
    File.open("#{javascripts_path}/application.js", 'w') { |file| file.write("//= require infopark_rails_connector\n") }
    File.open("#{stylesheets_path}/application.css", 'w') { |file| file.write("*= require infopark_rails_connector\n") }
  end

  it 'creates files' do
    destination_root.should have_structure {
      directory 'app' do
        directory 'assets' do
          directory 'fonts' do
            file 'editing_icons-webfont.eot'
            file 'editing_icons-webfont.ttf'
            file 'editing_icons-webfont.woff'
          end

          directory 'stylesheets' do
            file 'editing.css.less'
            file 'editing_icons.css.less'
            file 'application.css' do
              contains '*= require editing'
              contains '*= require bootstrap-datepicker'
            end
          end

          directory 'javascripts' do
            file 'editing.js.coffee'
            file 'application.js' do
              contains '//= require editing'
            end
          end
        end

        directory 'helpers' do
          file 'editing_helper.rb'
        end
      end

      file 'Gemfile' do
        contains 'gem "bootstrap-datepicker-rails"'
      end
    }
  end
end
