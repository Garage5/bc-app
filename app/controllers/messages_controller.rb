class MessagesController < ApplicationController
  before_filter :store_location
  before_filter :find_tournament
  before_filter :login_required, :except => [:index, :show]
  
  def index
    @messages = @tournament.messages
  end
  
  def show
    @message = @tournament.messages.find(params[:id], :include => {:comments => [:attachments, :author]})
    unauthorized! if cannot? :view, @message
  end
  
  def new
    @message = @tournament.messages.new
    unauthorized! if cannot? :create, @message
  end
  
  def create
    @message = @tournament.messages.build(params[:message])
    unauthorized! if cannot? :create, @message

    @message.author = current_user
    @message.attachments.each do |a| 
      a.tournament_id = @tournament.id
      a.uploader = current_user
    end
    
    if @message.save
      # @message.subscribers.each do |subscriber|
      #   Mailer.deliver_message_subscription(@message, subscriber)
      # end
      flash[:notice] = "Successfully created message."
      redirect_to [@tournament, @message]
    else
      render :action => 'new'
    end
  end
  
  def edit
    @message = @tournament.messages.find(params[:id])
    unauthorized! if cannot? :edit, @message
  end
  
  def update
    @message = @tournament.messages.find(params[:id])
    unauthorized! if cannot? :edit, @message
    if @message.update_attributes(params[:message])
      flash[:notice] = "Successfully updated message."
      redirect_to [@tournament, @message]
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @message = @tournament.messages.find(params[:id])
    unauthorized! if cannot? :destroy, @message
    @message.destroy
    flash[:notice] = "Successfully destroyed message."
    redirect_to tournament_messages_url(@tournament)
  end
  
  protected
  def find_tournament
    @tournament = current_account.tournaments.find(params[:tournament_id])
  end
end
