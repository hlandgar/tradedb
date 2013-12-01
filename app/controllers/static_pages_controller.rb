class StaticPagesController < ApplicationController
  def home
  	if signed_in?
      @trade = current_user.trades.build
      @entry = @trade.entries.build
  
    end
    
  	@edge ||= 0.0
  	@kelly ||= 0.0
  	@house ||= 0.0    
  end

  def help
  end

  def about
  end

  def contact
  end
end
