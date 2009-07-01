class MessagesController < ApplicationController
  before_filter :find_tournament
  before_filter :login_required, :except => [:index, :show]
  
  def index
    @messages = @tournament.messages
  end
  
  def show
    @message = Message.find(params[:id], :include => {:comments => [:attachments, :author]})
  end
  
  def new
    @message = Message.new
  end
  
  def create
    @message = @tournament.messages.build(params[:message])
    @message.author = current_user
    if @message.save
      flash[:notice] = "Successfully created message."
      redirect_to [@tournament, @message]
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
