require 'addressable/uri'
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

      def signature
        canonicalized_resource = CanonicalizedResource.new(@storage_account, @uri, blob: true).generate
        body = StringToSign::V20120212::Blob.new(canonicalized_resource, @options).generate
        Sign.new(@storage_access_key, body).perform
      end
    end

    WrongOptionsError = Class.new(StandardError)

    BLOB_RESOURCE = 'b'.freeze
    CONTAINER_RESOURCE = 'c'.freeze

    SIGNATURE = 'sig'.freeze

    def initialize(storage_access_key, storage_account, uri, options = {})
      @uri = Addressable::URI.parse(uri)
      @options = Options.new
      @storage_access_key = storage_access_key
      @storage_account = storage_account

      options.each do |key, value|
        @options.public_send("#{key}=", value)
      end
    end

    def generate
      uri = @uri.dup
      uri.query_values = (uri.query_values || {}).merge(query_values)
      uri.to_s
    end

    private

    def query_values
      @options
        .to_query_values
        .merge(SIGNATURE => signature)
    end

    def signature
      raise 'Not implemented'
    end
  end
end
