module Scoop
  module Resource

    class Bucket

      attr_reader :name, :attributes

      @@buckets = nil

      def initialize(name, attributes={})
        @host = "#{name}.#{Scoop::Request::HOST}"
        @name = name
        @attributes = attributes
      end

      def objects(params={})
        response = Scoop.request(:get, '/', :host => @host)
        Parser.parse(response.body)
      end

      def add_object(key, value)
        response = Scoop.request(:put, "/#{key}", :host => @host, :body => value)
      end


      def website
        if @website.nil?
          response = get('/?website')
          @website = response.code.to_i == 200 ? Parser.parse(response.body) : nil
        end

        @website
      end

      def enable_website(opts)
        xml = Scoop::Builder.website_configuration(opts)
        response = Scoop.request(:put, '/?website', :host => @host, :body => xml)
        @website = response.code.to_i == 200 ? 'enabled' : nil
      end

      private

      [:get, :post, :put, :delete].each do |verb|
        class_eval(<<-EVAL, __FILE__, __LINE__)
          def #{verb}(path, opts={})
            opts[:host] = @host if opts[:host].nil?
            Scoop.request(:#{verb}, path, opts)
          end
        EVAL
      end


      class << self

        def all
          if @@buckets.nil?
            response = Scoop.request(:get, '/')
            @@buckets = Parser.parse(response.body)
          end
        end

        def [](name)
          Bucket.new(name)
        end

        def create(name)
          response = Scoop.request(:put, '/', :host => "#{name}.#{Scoop::Request::HOST}")
          Scoop::Bucket.new(name)
        end

      end

    end

  end
end