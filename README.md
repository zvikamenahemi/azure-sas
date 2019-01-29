# azure-sas
Shared Access Signature generation for Azure

I've implemented this for generating SAS for blobs on azure storage.
https://github.com/giantmachines/azure-contrib was not suitable, because it
depends on the deprecated version of `celluloid` and is not actively mainained.

# Example

```ruby
url = 'https://myaccount.blob.core.windows.net/music '
Azure::SAS::BLOB.new(
  ENV['AZURE_STORAGE_ACCESS_KEY'],  # Here should be your azure access key
  ENV['AZURE_STORAGE_ACCOUNT'],     # Here should be your storage account name
  url,                              # URL to sign
  signedpermissions: 'r'            # Read-only
  signedexpiry: Time.now + (60 * 5) # 5 minutes after now the link will be expired
).generate
```

# Links
 * https://docs.microsoft.com/en-us/rest/api/storageservices/fileservices/constructing-a-service-sas
 * https://docs.microsoft.com/en-us/rest/api/storageservices/fileservices/constructing-a-service-sas
