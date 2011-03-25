module Scoop

  class Authentication

    def self.generate(host, request)
      signature = canonicalized_signature(host, request)

      "AWS #{Scoop.access_key_id}:#{signature}"
    end
    private

    def self.canonicalized_signature(host, request)
      http_verb = request.method.to_s.upcase
      headers   = {}

      request.each_header { |k, v| headers[k] = v }

      canonicalized_resource    = canonicalized_resource(host, request.path)
      canonicalized_amz_headers = canonicalized_amz_headers(headers)

      string_to_sign = "#{http_verb}\n#{headers['content-md5']}\n#{headers['content-type']}\n#{headers['date']}\n#{canonicalized_amz_headers}#{canonicalized_resource}"

      digest = OpenSSL::Digest::Digest.new('sha1')
      hmac   = OpenSSL::HMAC.digest(digest, Scoop.secret_access_key, string_to_sign)

      Base64.encode64(hmac).chomp
    end

    def self.canonicalized_amz_headers(headers)
      canonical_headers = []

      # selected the amazon headers
      headers.each { |k, v| canonical_headers << [ k.downcase, v ] if k =~ /^x-amz-/ }

      # sort them lexicographically
      canonical_headers.sort!

      # unfold long headers and trim whitespace
      canonical_headers.map! { |header| "#{header[0].strip}:#{header[1].gsub(/\s+/, ' ').strip}" }

      # append a newline to each header
      canonical_headers.join("\n")
    end

    def self.canonicalized_resource(host, resource)
      canonical_resource = ''

      # add bucket name
      bucket_name = host.sub(/\.?s3\.amazonaws\.com$/, '')
      canonical_resource << "/#{bucket_name}" unless bucket_name.empty?

      # add path
      uri = URI.parse(resource)
      canonical_resource << uri.path

      # add sub-resources
      sub_resources = %w[acl location logging notification partNumber policy requestPayment torrent uploadId uploads versionId versioning versions website]
      canonical_resource << "?#{$1}" if uri.query =~ /&?(#{sub_resources.join('|')})(?:&|=|\Z)/

      canonical_resource
    end
  end
end
