# frozen_string_literal: true

require "json"
require "aws-sdk-s3"
require "mime-types"

module Jacks
  module CDN
    class S3
      def self.client
        @client ||= Aws::S3::Client.new(
          access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
          secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY"),
          region: ENV.fetch("AWS_REGION")
        )
      end

      attr_reader :dir, :manifest

      def initialize(dir, manifest)
        @dir = File.expand_path(dir)
        @manifest = manifest
      end

      def upload_assets!
        manifest.assets.values.map do |filename|
          path = File.join(dir, filename)
          upload_file(filename, path)
        end
      end

      def upload_file(filename, path)
        client.put_object(
          acl: "public-read",
          key: filename,
          bucket: bucket,
          body: File.read(path),
          content_type: content_type(filename)
        )
      end

      def content_type(filename)
        (MIME::Types.type_for(File.extname(filename)).first ||
          MIME::Types.type_for("html").first
        ).to_s
      end

      def client
        self.class.client
      end

      def bucket
        @bucket ||= ENV.fetch("S3_BUCKET_NAME")
      end
    end
  end
end
