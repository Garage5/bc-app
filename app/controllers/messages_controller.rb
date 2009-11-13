class MessagesController < ApplicationController
  before_filter :store_location
  before_filter :find_tournament
  before_filter :login_required, :except => [:index, :show]
  
  def index
    @messages = @tournament.messages
  end
  
  def show
    @message = Message.find(params[:id], :include => {:comments => [:attachments, :author]})
    if @message.hosts_only? && (!current_user || !current_user.is_hosting?(current_account))
      flash[:error] = 'You are not authorized to view this message.'
      redirect_to tournament_messages_path(@tournament)
    end
  end
  
  def new
    @message = Message.new
  end
  
  def create
    if current_user.is_hosting?(current_account) || current_user.is_participant_of?(@tournament)
      unless current_user.is_hosting?(current_account)
        params[:message].delete(:is_announcement)
        params[:message].delete(:hosts_only)
      end
      @message = @tournament.messages.build(params[:message])
      @message.attachments.each do |a| 
        a.tournament_id = @tournament.id
        a.uploader = current_user
      end
      @message.author = current_user
      if @message.save
        @message.subscribers.each do |subscriber|
          Mailer.deliver_message_subscription(@message, subscriber)
        end
        flash[:notice] = "Successfully created message."
        redirect_to [@tournament, @message]
      else
        render :action => 'new'
      end
    else
      flash[:error] = "You can't post a message to this tournament."
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
