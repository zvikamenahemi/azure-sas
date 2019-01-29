require 'bundler/setup'
require 'minitest/autorun'
require 'azure/sas'

class TestSignBackend
  def initialize(key)
    @key = key
  end

  def sign(body)
    @key.to_s + body.to_s.tr("\n \t", '')
  end
end

Azure::SAS::Sign.backend = TestSignBackend
