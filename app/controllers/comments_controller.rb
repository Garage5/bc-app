class CommentsController < ApplicationController
  before_filter :find_tournament, :only => :create
  
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
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
