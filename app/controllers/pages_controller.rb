class PagesController < ApplicationController


  def join_us
  end

  def sign_in
  end

  def sign_up
  end

  def about_us
  end

  def privacy_policy
    render(layout: !request.xhr?)
  end

  def terms_of_service
    render(layout: !request.xhr?)
  end

  def rules_of_action
    render(layout: !request.xhr?)
  end

  def app_links
  end

  def context_help
    help_found = false
    Help.all.find_each do |help|
      url = help.url
      url.gsub!('/id', '/[[:digit:]]*')
      if /#{url}/ =~ params[:current_url]
        render json: help
        help_found = true
        break
      end
    end

    render json: {} unless help_found
  end
end
