require_relative './deploy'

module Jacks
  module Tasks
    class DeployTasks < Rake::TaskLib
      def self.generate_all
        new.generate_all
      end

      def generate_all
        deploy_task
      end

      def deploy_task
        desc "Deploy: code to heroku, assets to aws!"
        task :deploy do
          puts "compiling and uploading assets"
          Rake::Task["rake assets:upload"].invoke
          
          task = Jacks::Tasks::Deploy.new(Dir.pwd)
          task.commit_manifest
          task.push_to_heroku
        end
      end
    end
  end
end