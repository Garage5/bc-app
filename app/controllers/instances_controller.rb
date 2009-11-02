class InstancesController < ApplicationController
  before_filter :find_instance, :only => [:show, :edit, :update, :settings]
  before_filter :must_be_host, :only => [:settings, :edit, :update]
  
  def index
    @instances = Instance.all
  end
  
  def show
  end
  
  def settings
    if request.put?
      @instance.attributes = params[:instance]
      @success = @instance.save
      if params[:instance][:subdomain] && @success
        sd = request.host.split('.')
        sd[0] = @instance.subdomain
        render :text => "location.href = '#{url_for(:host => sd.join('.'))}';"
        return
      end
    end
  end
  
  def new
    @instance = Instance.new
  end
  
  def create
    @instance = Instance.new(params[:instance])
    if @instance.save
      flash[:notice] = "Successfully created instance."
      redirect_to instances_url
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @instance.update_attributes(params[:instance])
      flash[:notice] = "Successfully updated instance."
      redirect_to instances_url
    else
      render :action => 'edit'
    end
  end
end
