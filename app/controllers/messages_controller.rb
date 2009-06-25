class MessagesController < ApplicationController
  before_filter :find_tournament
  
  def index
    @messages = Message.all
  end
  
  def show
    @message = Message.find(params[:id])
  end
  
  def new
    @message = Message.new
  end
  
  def create
    @message = Message.new(params[:message])
    if @message.save
      flash[:notice] = "Successfully created message."
      redirect_to @message
    else
      render :action => 'new'
    end
  end
  
  def edit
    @message = Message.find(params[:id])
  end
  
  def update
    @message = Message.find(params[:id])
    if @message.update_attributes(params[:message])
      flash[:notice] = "Successfully updated message."
      redirect_to @message
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    flash[:notice] = "Successfully destroyed message."
    redirect_to messages_url
  end
  
  protected
  def find_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end
end
