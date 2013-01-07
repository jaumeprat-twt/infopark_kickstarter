require 'rake'
require 'rake/tasklib'

module IceKickstarter
  module Rake
    class DeploymentTask < ::Rake::TaskLib
      def initialize
        namespace :cms do
          namespace :deploy do
            desc 'Deploys to live cloud: staging -> deploy'
            task :live do
              live
            end

            desc 'Deploys to staging cloud: master -> staging'
            task :staging do
              staging
            end

            desc 'Gets status information of the last deployment'
            task :status do
              status
            end
          end
        end
      end

      private

      def status
        sh "curl -X GET #{url}/deployments/current?token=#{api_key}", :verbose => true

        puts
      end

      def live
        sh "git fetch", :verbose => true

        if %x(git rev-parse origin/staging).strip == %x(git rev-parse origin/deploy).strip
          sh "curl -X POST #{url}/deployments?token=#{api_key}", :verbose => true

          puts
        else
          sh 'rake assets:precompile && rake assets:clean'
          sh 'git push origin origin/staging:deploy', :verbose => true
        end
      end

      def staging
        sh 'rake assets:precompile && rake assets:clean'
        sh 'git push origin master:staging', :verbose => true

        puts 'Now tell Anne to click "deploy"'
      end

      def url
        config['url']
      end

      def api_key
        config['api_key']
      end

      def config
        YAML.load_file(File.join(Rails.root, 'config/deploy.yml'))
      end
    end
  end
end