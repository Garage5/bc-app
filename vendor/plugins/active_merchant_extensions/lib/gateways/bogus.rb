module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    # Bogus Gateway
    class BogusGateway < Gateway
      # Fake an update by calling store
      def update(identification, creditcard, options = {})
        store(creditcard, options)
      end
      
      # Allow for rebilling based on a token
      def purchase_with_token(money, card_or_token, options = {})
        if card_or_token.respond_to?(:number)
          purchase_without_token(money, card_or_token, options)
        else
          Response.new(true, SUCCESS_MESSAGE, {:paid_amount => money.to_s}, :test => true)
        end
      end
      alias_method_chain :purchase, :token
    end
  end
end