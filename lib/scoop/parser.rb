module Scoop
  class Parser

    class << self

      def parse(response)
        doc = Nokogiri.XML(response)
        doc.remove_namespaces!
        dispatch(doc.root.name, doc)
      end

      private

      def dispatch(result_name, doc)
        method = underscore(result_name).gsub(/_result$/, '')
        Parser.send(method, doc)
      end

      def underscore(camel_cased_word)
        camel_cased_word.to_s.gsub(/::/, '/').
          gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          tr('-', '_').
          downcase
      end

      def list_all_my_buckets(doc)
        buckets = []

        doc.xpath('//Bucket').each do |e|
          name = e.xpath('Name').text
          attributes = {
            :created_at => e.xpath('CreationDate').text
          }

          buckets << Scoop::Resource::Bucket.new(name, attributes)
        end

        buckets
      end

      def list_bucket(doc)
        bucket_name = doc.xpath('//Name').text
        objects = []

        doc.xpath('//Contents').each do |obj|
          attributes = {
            :key        => obj.xpath('Key').text,
            :updated_at => obj.xpath('LastModified').text,
            :etag       => obj.xpath('ETag').text,
            :size       => obj.xpath('Size').text
          }

          objects << Scoop::Resource::S3Object.new(bucket_name, attributes)
        end

        objects
      end

      def website_configuration(doc)
        index_document = doc.xpath('//IndexDocument/Suffix').text
        error_document = doc.xpath('//ErrorDocument/Key').text

        { :index_document => index_document, :error_document => error_document }
      end

      def versioning_configuration(doc)
        status = doc.xpath('//VersioningConfiguration/Status').text
        status.empty? ? 'disabled' : text
      end

    end

  end
end
