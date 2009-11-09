module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class TrustCommerceGateway < Gateway
      
      # To update a card you just store with the existing billingid
      def update(identification, creditcard, options = {})
        store(creditcard, options.merge(:billingid => identification))
      end  
          
      def commit(action, parameters)
        parameters[:custid]      = @options[:login]
        parameters[:password]    = @options[:password]
        parameters[:demo]        = test? ? 'y' : 'n'
        parameters[:action]      = action
                
        clean_and_stringify_params(parameters)
        
        data = if tclink?
          TCLink.send(parameters)
        else
          parse( ssl_post(URL, post_data(parameters)) )
        end
        
        # to be considered successful, transaction status must be either "approved" or "accepted"
        success = SUCCESS_TYPES.include?(data["status"])
        message = message_from(data)
        TrustCommerceResponse.new(success, message, data, 
          :test => test?, 
          :authorization => data["transid"],
          :cvv_result => data["cvv"],
          :avs_result => { :code => data["avs"] }
        )
      end
    end

    class TrustCommerceResponse < Response
      # add a method to response so we can easily get the token
      # for Citadel transactions
      def token
        @params["billingid"]
      end
    end

  end
end