module Config
  module AppData
    class Sequel < Jacks::Config::AppData::Sequel
      def database_prefix
        "jacks_app"
      end

      # Uncomment this and modify if your username is not your system username
      #
      # def username
      #   env.fetch("DATABASE_USER", `whoami`.strip)
      # end

      # Uncomment this and modify if you set a local database password
      #
      # def password
      #   env.fetch("DATABASE_PASSWORD", "")
      # end
    end
  end
end
