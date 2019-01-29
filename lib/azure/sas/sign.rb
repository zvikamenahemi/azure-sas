require 'azure'

module Azure
  class SAS
    class Sign
      class << self
        attr_accessor :backend
      end

      self.backend = Azure::Core::Auth::Signer

      def initialize(key, body)
        @key = key
        @body = body
      end

      def perform
        self.class.backend.new(@key).sign(@body)
      end
    end
  end
end
