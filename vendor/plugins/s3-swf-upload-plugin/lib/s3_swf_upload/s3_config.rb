module S3SwfUpload
  class S3Config
    require 'yaml'

    cattr_reader :access_key_id, :secret_access_key
    cattr_accessor :bucket, :max_file_size, :acl

    def self.load_config
      filename = "#{RAILS_ROOT}/config/amazon_s3.yml"
      file = File.open(filename)
      config = YAML.load(file)

      @@access_key_id     = ENV['AMAZON_ACCESS_KEY_ID'] || config[RAILS_ENV]['access_key_id']
      @@secret_access_key = ENV['AMAZON_SECRET_ACCESS_KEY'] || config[RAILS_ENV]['secret_access_key']
      @@bucket            = ENV['AMAZON_S3_SWF_UPLOAD_BUCKET'] || config[RAILS_ENV]['bucket_name']
      @@max_file_size     = ENV['AMAZON_S3_SWF_MAX_FILE_SIZE'] || config[RAILS_ENV]['max_file_size']
      @@acl               = ENV['AMAZON_S3_SWF_UPLOAD_ACL'] || config[RAILS_ENV]['acl'] || 'private'
      
      unless @@access_key_id && @@secret_access_key
        raise "Please configure your S3 settings in #{filename}."
      end
    end
  end
end
