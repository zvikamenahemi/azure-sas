module Azure
  class SAS
    # Holds all possible options for a SAS generation
    class Options
      FIELDS = {
        signedresource: :sr,
        signedstart: :st,
        signedexpiry: :se,
        signedpermissions: :sp,
        identifier: :si,
        signedversion: :sv,
        contentdisposition: :rscd,
        contenttype: :rsct
      }.freeze

      attr_accessor(*FIELDS.keys)

      def validate!
        validate_option_value(
          :signedresource,
          signedresource,
          BLOB_RESOURCE, CONTAINER_RESOURCE, nil
        )

        validate_option_type(:signedstart, signedstart, Time)
        validate_option_type(:signedexpiry, signedstart, Time)
      end

      def to_query_values
        {
          signedresource: signedresource,
          signedstart: signedstart && signedstart.utc.iso8601,
          signedexpiry: signedexpiry && signedexpiry.utc.iso8601,
          signedpermissions: signedpermissions,
          identifier: identifier,
          signedversion: signedversion,
          contentdisposition: contentdisposition,
          contenttype: contenttype
        }.map do |key, value|
          [FIELDS.fetch(key), value] if value
        end.compact.to_h
      end

      private

      def validate_option_type(name, val, type)
        unless val.is_a?(type)
          raise WrongOptionsError,
            "#{name.inspect} should be of type #{type}"
        end
      end

      def validate_option_value(name, val, *allowed)
        raise WrongOptionsError,
          "#{val.inspect} is not allowed value for #{name.inspect}"\
          " (Allowed: #{allowed.map(&:inspect).join(', ')}"
      end
    end
  end
end
