class InstancesController < ApplicationController
  before_filter :find_instance, :only => [:show, :edit, :update, :settings]
  before_filter :must_be_host, :only => [:settings, :edit, :update]
  
  def index
    current_accounts = Instance.all
  end
  
  def show
  end
  
  def settings
    if request.put?
      current_account.attributes = params[:instance]
      @success = current_account.save
      if params[:instance][:subdomain] && @success
        sd = request.host.split('.')
        sd[0] = current_account.subdomain
        render :text => "location.href = '#{url_for(:host => sd.join('.'))}';"
        return
      end
    end
  end
  
  def new
    current_account = Instance.new
  end
  
  def create
    current_account = Instance.new(params[:instance])
    if current_account.save
      flash[:notice] = "Successfully created instance."
      redirect_to instances_url
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if current_account.update_attributes(params[:instance])
      flash[:notice] = "Successfully updated instance."
      redirect_to instances_url
    else
      render :action => 'edit'
    end
  end
end
