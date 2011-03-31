require 'yaml'
require 'time'
require 'base64'
require 'digest/md5'
require 'openssl'
require 'net/http'
require 'net/https'

require 'nokogiri'

require 'scoop/bucket'
require 'scoop/object'
require 'scoop/builder'
require 'scoop/parser'
require 'scoop/extension'
require 'scoop/authentication'
require 'scoop/request'
require 'scoop/exceptions'

module Scoop
  include Scoop::Resource
  include Scoop::Extension

  class << self

    def access_key_id=(key)
      @@access_key_id = key
    end

    def access_key_id
      @@access_key_id
    end

    def secret_access_key=(key)
      @@secret_access_key = key
    end

    def secret_access_key
      @@secret_access_key
    end

    def load_keys_config
      keys_file = File.join(ENV['HOME'], '.scoop')

      if File.exist? keys_file
        config = YAML.load_file(keys_file)
        @@access_key_id = config['access_key_id']
        @@secret_access_key = config['secret_access_key']
      end
    end

    def request(type, path, options={})
      host     = options.fetch(:host, Scoop::Request::HOST)
      request  = Scoop::Request.new(type, path, options)
      response = Net::HTTP.new(host).start { |http| http.request(request.request) }
    end

  end

end