class PreviewController < ApplicationController
  
  def index
    render params[:view].join('/')
  end
  
end
