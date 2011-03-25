module Scoop
  module Resource

    class S3Object

      attr_reader :attributes

      def initialize(bucket, attributes = {})
        @bucket = bucket
        @attributes = attributes
      end

    end

  end
end