module Scoop
  module Resource

    class S3Object

      attr_reader :name

      def initialize(bucket, attributes = {})
        @bucket = bucket
        @name = attributes[:name]
      end

    end

  end
end