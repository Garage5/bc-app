require 'base64'

class S3UploadsController < ApplicationController

  # The plugin flash script has to be able to access this controller, so don't block it with authentication!
  # You can delete the following line if you have no authentication in your app.

  skip_before_filter  :<*** your authentication filter, if any, goes here!>, [:only => "index"]

  # --- no code for modification below here ---

  # Sigh.  OK that's not completely true - you might want to look at https and expiration_date below.
  #        Possibly these should also be configurable from S3Config...

  skip_before_filter :verify_authenticity_token
  include S3SwfUpload::Signature
  
  def index
    bucket          = S3SwfUpload::S3Config.bucket
    access_key_id   = S3SwfUpload::S3Config.access_key_id
    key             = params[:key]
    content_type    = params[:content_type]
    file_size       = params[:file_size]
    acl             = S3SwfUpload::S3Config.acl
    https           = 'false'

    max_file_size = S3SwfUpload::S3Config.max_file_size
    max_file_MB   = (max_file_size/1024/1024).to_i

    error_message   = "Selected file is too large (max is #{max_file_size}MB)" if file_size.to_i >  S3SwfUpload::S3Config.max_file_size

    expiration_date = 1.hours.from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z')

    if params[:do_checks] == "1"
      error_message = self.s3_swf_upload_file_error?(key) 
    end

    policy = Base64.encode64(
"{
    'expiration': '#{expiration_date}',
    'conditions': [
        {'bucket': '#{bucket}'},
        {'key': '#{key}'},
        {'acl': '#{acl}'},
        {'Content-Type': '#{content_type}'},
        ['starts-with', '$Filename', ''],
        ['eq', '$success_action_status', '201']
    ]
}").gsub(/\n|\r/, '')

    signature = b64_hmac_sha1(S3SwfUpload::S3Config.secret_access_key, policy)

    respond_to do |format|
      format.xml {
        render :xml => {
          :policy          => policy,
          :signature       => signature,
          :bucket          => bucket,
          :accesskeyid     => access_key_id,
          :acl             => acl,
          :expirationdate  => expiration_date,
          :https           => https,
          :errorMessage   => error_message.to_s
        }.to_xml
      }
    end
  end
end
