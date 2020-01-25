# frozen_string_literal: true

module Jacks
  module Jwt
    class Token
      def self.encode(data = {})
        Encode.new(data).call
      end

      def self.decode(token)
        Decode.new(token).call
      end

      class Encode
        attr_reader :data

        def initialize(data)
          @data = data
        end

        def call
          JWT.encode(payload, Token.secret)
        end

        def payload
          {exp: expiration_time}.merge(data)
        end

        def expiration_time
          Time.now.to_i + 60 * 15
        end
      end

      class Decode
        attr_reader :token

        def initialize(token)
          @token = token
        end

        def call
          JWT.decode(token, Token.secret).first
        end
      end

      def self.secret
        @secret ||= ENV.fetch("SECRET_KEY_BASE")
      end
    end
  end
end
