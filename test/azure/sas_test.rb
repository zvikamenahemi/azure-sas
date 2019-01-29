require 'test_helper'
require 'securerandom'

class Azure::SasTest < Minitest::Test
  def self.key
    @key ||= SecureRandom.hex(10)
  end

  def self.storage
    @storage ||= SecureRandom.hex(10)
  end

  def self.canonicalize(uri, blob: true)
    ::Azure::SAS::CanonicalizedResource.new(storage, uri, blob: blob).generate
  end

  def self.signedstart
    @signedstart ||= Time.now
  end

  def self.signedexpiry
    @signedexpiry ||= Time.now
  end

  BLOB_EXAMPLES = {
    [
      'https://example.com/a',
      {
        signedresource: 'b',
        signedpermissions: 'r',
        signedstart: signedstart,
        signedexpiry: signedexpiry
      }
    ] => [
      'https://example.com/a?',
      [
        'se=',
        signedexpiry.utc.iso8601
      ].join,

      [
        '&sig=',
        key,
        'r',
        signedstart.utc.iso8601,
        signedexpiry.utc.iso8601,
        canonicalize('https://example.com/a'),
        ''
      ].join,

      '&sp=r&sr=b',
      [
        '&st=',
        signedstart.utc.iso8601
      ].join
    ].join
  }.freeze

  def test_blob
    BLOB_EXAMPLES.each do |args, expected|
      actual = Azure::SAS::BLOB.new(
        self.class.key,
        self.class.storage,
        *args
      ).generate

      assert_equal URI.escape(expected).to_s, URI.unescape(actual)
    end
  end
end
