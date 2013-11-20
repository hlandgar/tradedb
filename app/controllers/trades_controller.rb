class TradesController < ApplicationController
	include ApplicationHelper
	before_action :signed_in_user

	def create
		@trade = current_user.trades.build(trade_params)

		if params[:commit] == 'Calculate' 
			if @trade.valid?

				security_id = @trade.security_id
				fill = @trade.fill 
				stop = @trade.stop 
				targ1 = @trade.targ1 
				prob1 = @trade.prob1 
				prob2 = @trade.prob2 ||= 0.0
				targ2 = @trade.targ2 ||= 0.0
				stop2 = @trade.stop2 ||= 0.0


				risk = (fill - stop).abs
				reward = (targ1 - fill).abs
				@house = house(risk, security_id)


				(@kelly, @edge) = kelly(security_id, stop, fill, targ1, targ2, prob1, prob2, stop2: stop2)
				@alloc = get_alloc(@kelly, 5000, security_id, risk).round(2)

				@alloc = "no trade" if @alloc < 1.0


				@kelly *= 100
				@edge *= 100
				@house *=100
				@rr = (reward/risk).round(1)
			end

			render 'static_pages/home'

		else

			
			if @trade.save
				flash[:success] = "Trade created"
				redirect_to root_url
			else
				render 'static_pages/home'
			end	
		end	
	end

	def destroy		
	end

	private

		def trade_params
			params.require(:trade).permit(:fill, :stop, :targ1, :targ2, :prob1, :prob2, :desc, :comments,
																	:security_id, :stop2, :commit )
		end
end

		