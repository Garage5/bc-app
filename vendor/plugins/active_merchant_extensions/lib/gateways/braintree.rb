module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class BraintreeGateway < SmartPs
      def commit(action, money, parameters)
        parameters[:amount]  = amount(money) if money
        response = parse( ssl_post(api_url, post_data(action,parameters)) )
        BraintreeResponse.new(response["response"] == "1", message_from(response), response, 
          :authorization => response["transactionid"],
          :test => test?,
          :cvv_result => response["cvvresponse"],
          :avs_result => { :code => response["avsresponse"] }
        )
        
      end
    end
    
    class BraintreeResponse < Response
      # add a method to response so we can easily get the token
      # for vault transactions
      def token
        @params["customer_vault_id"]
      end
    end
  end
end

