class StaticPagesController < ApplicationController
  include ApplicationHelper
  def home
  	if signed_in?
      @trade = current_user.trades.build
      @entry = @trade.entries.build
      @spread = get_spread("ES")
      @sellpct = 50
      @step = 0.25
 
  
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
