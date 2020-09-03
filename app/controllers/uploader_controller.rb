class UploaderController < ApplicationController
  before_filter :authenticate_broker!
  skip_before_action :verify_authenticity_token
  def image
    editor_file = EditorFile.new
    editor_file.file = params[:file]
    editor_file.save
    render json: {location: editor_file.file.url}, content_type:  "text / html"
  end
end
