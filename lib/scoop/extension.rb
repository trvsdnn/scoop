module Scoop
  module Extension

    def self.included(receiver)
      receiver.extend ClassMethods
    end


    module ClassMethods

      def up(file, bucket_name)
        result = nil

        if Scoop::Bucket.exist? bucket_name
          if File.directory? file
            result = add_folder(file, bucket_name)
          else
            result = add_file(file, bucket_name)
          end

          result
        else
          raise Scoop::BucketNotFound
        end
      end

      private

      def add_folder(path, bucket_name)
        objects = []

        Dir[File.join(path, '/**/*')].each do |file|
          if File.directory? file
            objects << Scoop::Bucket[bucket_name].add_object(file, '')
          else
            objects << Scoop::Bucket[bucket_name].add_object(file, IO.read(file))
          end
        end

        objects
      end

      def add_file(file, bucket_name)
        Scoop::Bucket[bucket_name].add_object(File.basename(file), IO.read(file))
      end

    end

  end
end