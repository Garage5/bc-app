class UsersController < ApplicationController
  def new
    @user = User.new
    render :layout => 'lite'
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Successfully created user."
      redirect_to '/preview/accounts/dashboard'
    else
      render :action => 'new', :layout => 'lite'
    end
  end
end
