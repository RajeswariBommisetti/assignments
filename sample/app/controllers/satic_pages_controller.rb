class SaticPagesController < ApplicationController

  require 'actionpack/page_caching'
  caches_page :home, :help , :about , :contact
  def home
  	if logged_in?
  	 @micropost = current_user.microposts.build if logged_in?
     @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end
  
  def help
  end
  
  def about
  end

  def contact
  end
end
