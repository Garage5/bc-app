class AttachmentsController < ApplicationController
  def create
    @attachment = Attachment.new(params[:attachment])
    if @attachment.save
      flash[:notice] = "Successfully created attachment."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
    flash[:notice] = "Successfully destroyed attachment."
    redirect_to root_url
  end
end
