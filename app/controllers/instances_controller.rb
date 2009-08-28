class InstancesController < ApplicationController
  before_filter :find_instance, :only => [:show, :settings]

  def index
    @instances = Instance.all
  end
  
  def show
    #@instances = Instance.find_by_name(current_subdomain)
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
    @instance = Instance.find(params[:id]) unless @instance
  end
  
  def update
    @instance = Instance.find(params[:id])
    if @instance.update_attributes(params[:instance])
      flash[:notice] = "Successfully updated instance."
      redirect_to instances_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @instance = Instance.find(params[:id])
    @instance.destroy
    flash[:notice] = "Successfully destroyed instance."
    redirect_to instances_url
  end
end
