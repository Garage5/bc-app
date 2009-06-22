class InstancesController < ApplicationController
  def index
    @instances = Instance.all
  end
  
  def show
    @instance = Instance.first
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
    @instance = Instance.find(params[:id])
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
