class PreviewController < ApplicationController
  
  def index
    render params[:view].join('/')
  end
  
  def lite
    render params[:view].join('/'), :layout => 'lite'
  end
  
  def email
    render params[:view].join('/'), :layout => 'email'
  end
  
end