class CommentsController < ApplicationController
  before_filter :find_tournament, :only => :create
  before_filter :login_required
  
  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment].merge(:author => current_user))
    if @comment.save
      flash[:notice] = "Successfully created comment."
      redirect_to [@tournament, @commentable]
    else
      render :action => 'new'
    end
  end
  
  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Successfully updated comment."
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = "Successfully destroyed comment."
    redirect_to root_url
  end
  
  private
  def find_commentable
    return Message.find(params[:message_id]) if params[:message_id]
    return Match.find(params[:match_id]) if params[:match_id]
    nil
  end
end
