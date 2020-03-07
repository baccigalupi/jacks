require_relative './assets'

module JacksTasks
  class Assets < Rake::TaskLib
    def self.generate_all
      new.generate_all
    end

    def generate_all
      dotenv_environment_task
      compile_task
      upload_task
    end

    def dotenv_environment_task
      task :dotenv_production do
        Dotenv.load(".env.production", ".env")
      end
    end
    
    def upload_task
      namespace :assets do
        desc "Upload all the assets to s3"
        task upload: :dotenv_production do
          Jacks::Tasks::Assets.new(Dir.pwd).upload_assets
        end
      end
    end

    def compile_task
      namespace :assets do 
        desc "Compile production assets"
        task compile: :dotenv_production do
          Jacks::Tasks::Assets.new(Dir.pwd).compile_production_assets
        end
      end
    end
  end
end