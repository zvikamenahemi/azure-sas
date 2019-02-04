require 'addressable/uri'
require 'uri'

module Azure
  class SAS
    class CanonicalizedResource
      def initialize(storage_account, uri, blob: true)
        @storage_account = storage_account
        @uri = Addressable::URI.parse(uri)
        @blob = blob
      end

      def generate
        path = URI.unescape(@uri.path.to_s)

        resource =
          if @blob
            [@storage_account, *path.split('/')]
          else
            [@storage_account, path.split('/')[0]]
          end

        File.join('/', *resource)
      end
    end
  end
end
