# frozen_string_literal: true

module Jacks
  class JsonResponse
    attr_reader :code, :payload, :token

    def initialize(code, payload = {}, token = nil)
      @code = code
      @payload = payload
      @token = token
    end

    def to_rack
      [
        code,
        {"Content-Type" => "application/json"},
        [
          {
            status: code,
            payload: payload || {},
            token: token,
          }.to_json,
        ],
      ]
    end

    alias call to_rack

    def new(*_args)
      self
    end
  end
end
