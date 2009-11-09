# Pull in gateway overrides
Dir[File.dirname(__FILE__) + '/gateways/*.rb'].each {|g| require g}

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
  
    class Response
      
      # Used for a billing id for re-billing
      def token
        @authorization
      end
      
    end
  end
end
