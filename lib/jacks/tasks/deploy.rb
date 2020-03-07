module Jacks
  module Tasks
    class Deploy
      attr_reader :root

      def initialize(root)
        @root = root
      end

      def commit_manifest
        puts "committing manifest.json"
        `git add app/client/manifest.json; git commit -m "deploy release"`
      end

      def push_to_heroku
        puts "pushing to heroku"
        `git push heroku master`
      end
    end
  end
end