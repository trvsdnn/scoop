module Scoop
  class Builder

    class << self

      def website_configuration(tags)
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.WebsiteConfiguration(:xmlns => 'http://s3.amazonaws.com/doc/2006-03-01/') {
            xml.IndexDocument {
              xml.Suffix tags[:index_document]
            }
            xml.ErrorDocument {
              xml.Key tags[:error_document]
            }
          }
        end

        builder.to_xml
      end

    end

  end
end