require 'vendor/bundle/ruby/2.3.0/gems/addressable/uri'
require 'azure'
require 'uri'
require 'time'

require 'azure/sas/version'
require 'azure/sas/canonicalized_resource'
require 'azure/sas/options'
require 'azure/sas/string_to_sign'
require 'azure/sas/sign'

module Azure
  # Generates an Azure Shared Access Signature
  # @see https://docs.microsoft.com/en-us/rest/api/storageservices/fileservices/delegating-access-with-a-shared-access-signature
  class SAS
    class BLOB < SAS
      def initialize(*)
        super
        @options.signedresource = BLOB_RESOURCE
      end

      def signature(generate_method)
        canonicalized_resource = CanonicalizedResource.new(@storage_account, @uri, blob: true).generate
        body = StringToSign::V20120212::Blob.new(canonicalized_resource, @options).public_send(generate_method)
        Sign.new(@storage_access_key, body).perform
      end
    end

    WrongOptionsError = Class.new(StandardError)

    BLOB_RESOURCE = 'b'.freeze
    CONTAINER_RESOURCE = 'c'.freeze

    SIGNATURE = 'sig'.freeze

    SIGNATURE_TYPE = {
      get: 'generate_get',
      put: 'generate_put'
    }

    def initialize(storage_access_key, storage_account, uri, options = {})
      @uri = Addressable::URI.parse(uri)
      @options = Options.new
      @storage_access_key = storage_access_key
      @storage_account = storage_account

      options.each do |key, value|
        @options.public_send("#{key}=", value)
      end
    end

    def generate_get
      generate(SIGNATURE_TYPE[:get])
    end

    def generate_put
      generate(SIGNATURE_TYPE[:put])
    end

    private

    def generate(generate_method)
      uri = @uri.dup
      uri.query_values = (uri.query_values || {})
        .merge(query_values())
        .merge(SIGNATURE => signature(generate_method))
      uri.to_s
    end

    def query_values
      @options
        .to_query_values
    end

    def signature
      raise 'Not implemented'
    end
  end
end
