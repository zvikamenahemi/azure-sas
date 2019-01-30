module Azure
  class SAS
    module StringToSign
      module V20120212
        # @see https://docs.microsoft.com/en-us/rest/api/storageservices/fileservices/constructing-a-service-sas
        class Blob
          def initialize(canonicalized_resource, options)
            @canonicalized_resource = canonicalized_resource
            @options = options
          end

          def generate_get
            (
              generate_base +
              [
                @options.signedversion.to_s,
                "",
                @options.contentdisposition.to_s,
                "",
                "",
                @options.contenttype.to_s
              ]
            ).compact.join("\n").force_encoding('UTF-8')
          end

          def generate_put
            generate_base.compact.join("\n").force_encoding('UTF-8')
          end

          private
            def generate_base
              [
                @options.signedpermissions.to_s,
                (@options.signedstart && @options.signedstart.utc.iso8601).to_s,
                (@options.signedexpiry && @options.signedexpiry.utc.iso8601).to_s,
                @canonicalized_resource.to_s,
                @options.identifier.to_s
              ]
            end
        end
      end
    end
  end
end