class StaticPagesController < ApplicationController
  def home
  	@trade = current_user.trades.build if signed_in?
  	@edge =|| 0.0
  	@kelly =|| 0.0
  	@house =|| 0.0
  end

  def help
  end

  def about
  end

  def contact
  end
end
