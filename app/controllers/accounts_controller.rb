class AccountsController < ApplicationController
  include ModelControllerMethods
  
  layout 'accounts'

  before_filter :store_location, :only => :show
  before_filter :authenticate_user!, :except => [:new, :create, :show]
  before_filter :build_user, :only => [:new, :create]
  before_filter :load_billing, :only => [ :new, :create, :billing, :paypal ]
  before_filter :load_subscription, :only => [ :billing, :plan, :paypal, :plan_paypal ]
  before_filter :load_discount, :only => [ :plans, :plan, :new, :create ]
  before_filter :build_plan, :only => [:new, :create]
  
  before_filter :must_be_admin, :except => [:show, :new, :create, :thanks]
  
  ssl_required :billing, :cancel, :new, :create
  ssl_allowed :plans, :thanks, :canceled, :paypal
  
  def index
    redirect_to 'http://thebattlcenter.com'
  end
  
  def show
    @tournaments_alpha = current_account.tournaments.all(:include => :public_events)
    @tournaments = @tournaments_alpha.reject {|t| t.public_events.size == 0 }
    render :layout => 'application'
  end
  
  def edit
    render :layout => 'application'
  end
  
  def update
    if @account.update_attributes(params[:account])
      flash[:notice] = "The #{cname.humanize.downcase} has been updated."
      redirect_to settings_url(:subdomain => @account.subdomain)
    else
      render :action => 'edit'
    end
  end
  
  def new
    # if account = Account.first(:conditions => {:admin_id => current_user.id})
    #   redirect_to root_url(:subdomain => account.subdomain)
    # end
    # render :layout => 'public' # Uncomment if your "public" site has a different layout than the one used for logged-in users
    render :layout => 'accounts'
  end
  
  def create
    if params[:signup]
      @account.user = User.new(params[:signup])
    elsif params[:login]
      @account.user = User.authenticate(params[:login])
      @account.errors.add_to_base('Invalid username or password') unless @account.user
    end
    
    @account.affiliate = SubscriptionAffiliate.find_by_token(cookies[:affiliate]) unless cookies[:affiliate].blank?

    if @account.needs_payment_info?
      @address.first_name = @creditcard.first_name
      @address.last_name = @creditcard.last_name
      @account.address = @address
      @account.creditcard = @creditcard
    end
    
    if @account.save
      sign_in @account.user
      flash[:domain] = @account.subdomain
      redirect_to :action => 'thanks'
    else
      render :action => 'new', :layout => 'accounts' #, :layout => 'public' # Uncomment if your "public" site has a different layout than the one used for logged-in users
    end
  end
  
  def plans
    @plans = SubscriptionPlan.find(:all, :order => 'amount desc').collect {|p| p.discount = @discount; p }
    # render :layout => 'public' # Uncomment if your "public" site has a different layout than the one used for logged-in users
  end
  
  def billing
    if request.post?
      if params[:paypal].blank?
        @address.first_name = @creditcard.first_name
        @address.last_name = @creditcard.last_name
        if @creditcard.valid? & @address.valid?
          if @subscription.store_card(@creditcard, :billing_address => @address.to_activemerchant, :ip => request.remote_ip)
            flash[:notice] = "Your billing information has been updated."
            redirect_to :action => "billing"
          end
        end
      else
        if redirect_url = @subscription.start_paypal(paypal_account_url, billing_account_url)
          redirect_to redirect_url
        end
      end
    end
    render :layout => 'application'
  end
  
  # Handle the redirect return from PayPal
  def paypal
    if params[:token]
      if @subscription.complete_paypal(params[:token])
        flash[:notice] = 'Your billing information has been updated'
        redirect_to :action => "billing"
      else
        render :action => 'billing'
      end
    else
      redirect_to :action => "billing"
    end
  end

  def plan
    if request.post?
      @subscription.plan = SubscriptionPlan.find(params[:plan_id])

      # PayPal subscriptions must get redirected to PayPal when
      # changing the plan because a new recurring profile needs
      # to be set up with the new charge amount.
      if @subscription.paypal?
        # Purge the existing payment profile if the selected plan is free
        if @subscription.amount == 0
          logger.info "FREE"
          if @subscription.purge_paypal
            logger.info "PAYPAL"
            flash[:notice] = "Your subscription has been changed."
            SubscriptionNotifier.deliver_plan_changed(@subscription)
          else
            flash[:error] = "Error deleting PayPal profile: #{@subscription.errors.full_messages.to_sentence}"
          end
          redirect_to :action => "plan", :layout => 'application' and return
        else
          if redirect_url = @subscription.start_paypal(plan_paypal_account_url(:plan_id => params[:plan_id]), plan_account_url)
            redirect_to redirect_url and return
          else
            flash[:error] = @subscription.errors.full_messages.to_sentence
            redirect_to :action => "plan" and return
          end
        end
      end
      
      if @subscription.save
        flash[:notice] = "Your subscription has been changed."
        SubscriptionNotifier.deliver_plan_changed(@subscription)
      else
        flash[:error] = "Error updating your plan: #{@subscription.errors.full_messages.to_sentence}"
      end
      redirect_to :action => "plan", :layout => 'application'
    else
      @plans = SubscriptionPlan.find(:all, :conditions => ['id <> ?', @subscription.subscription_plan_id], :order => 'amount desc').collect {|p| p.discount = @subscription.discount; p }
      render :layout => 'application'
    end
  end
  
  # Handle the redirect return from PayPal when changing plans
  def plan_paypal
    if params[:token]
      @subscription.plan = SubscriptionPlan.find(params[:plan_id])
      if @subscription.complete_paypal(params[:token])
        flash[:notice] = "Your subscription has been changed."
        SubscriptionNotifier.deliver_plan_changed(@subscription)
        redirect_to :action => "plan"
      else
        flash[:error] = "Error completing PayPal profile: #{@subscription.errors.full_messages.to_sentence}"
        redirect_to :action => "plan"
      end
    else
      redirect_to :action => "plan"
    end
  end

  def cancel
    if request.post? and !params[:confirm].blank?
      current_account.destroy
      self.current_user = nil
      reset_session
      redirect_to :action => "canceled"
    end
  end
  
  def thanks
    redirect_to :action => "plans" and return unless flash[:domain]
    # render :layout => 'public' # Uncomment if your "public" site has a different layout than the one used for logged-in users
  end
  
  def dashboard
    render :text => 'Dashboard action, engage!', :layout => true
  end

  protected
  
    def load_object
      @obj = @account = current_account
    end
    
    def build_user
      unless params[:login]
        @account.user = @user = User.new(params[:user])
      else
        @account.user = @user = User.new(params[:user])      
      end
    end
    
    def build_plan
      unless @plan = SubscriptionPlan.find_by_name(params[:plan])
        redirect_to('http://thebattlecenter.com/plans') 
      else
        @plan.discount = @discount
        @account.plan = @plan
      end
    end
    
    def redirect_url
      { :action => 'show' }
    end
    
    def load_billing
      @creditcard = ActiveMerchant::Billing::CreditCard.new(params[:creditcard])
      @address = SubscriptionAddress.new(params[:address])
    end

    def load_subscription
      @subscription = current_account.subscription
    end
    
    # Load the discount by code, but not if it's not available
    def load_discount
      if params[:discount].blank? || !(@discount = SubscriptionDiscount.find_by_code(params[:discount])) || !@discount.available?
        @discount = nil
      end
    end
    
    def authorized?
      %w(new create plans canceled thanks).include?(self.action_name) || 
      (self.action_name == 'dashboard' && logged_in?) ||
      admin?
    end 
    
end
