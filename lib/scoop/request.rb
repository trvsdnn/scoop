module Scoop
  class Request
    HOST = 's3.amazonaws.com'

    attr_reader :path, :request

    def initialize(type, path, options = {})
      host    = options.fetch(:host, HOST)
      path    = URI.escape(path)
      headers = options.fetch(:headers, {})
      body    = options[:body]

      case type
      when :get
        @request = Net::HTTP::Get.new(path)
      when :post
        @request = Net::HTTP::Post.new(path)
      when :put
        @request = Net::HTTP::Put.new(path)
      when :delete
        @request = Net::HTTP::Delete.new(path)
      end

      add_headers_to_request(headers)
      add_body_to_request(body) unless body.nil?
      add_auth_signature(host)
    end

    private

    def add_headers_to_request(headers)
      headers.each { |header, value| @request[header] = value } unless headers.empty?
      @request['date'] ||= Time.now.httpdate
    end

    def add_body_to_request(body)
      if body.respond_to?(:read)
        @request.body_stream = body
      else
        @request.body = body
      end

      @request['content-type'] ||= 'application/octet-stream'
      @request['content-md5'] = Base64.encode64(Digest::MD5.digest(@request.body)).chomp

      @request.content_length = body.respond_to?(:lstat) ? body.stat.size : body.size

    end

    def add_auth_signature(host)
      @request['authorization'] = Authentication.generate(host, @request)
    end

  end
end