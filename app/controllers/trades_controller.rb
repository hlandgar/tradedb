class TradesController < ApplicationController
	include ApplicationHelper
	include UsersHelper
	before_action :signed_in_user

	def create
		@trade = current_user.trades.build(trade_params)
		@trade.pass = false


			if params[:commit] == 'Calculate' and params[:get_spread] != "get_spread"
				@trade.pass = true

				

				if @trade.valid?
					

					security_symbol = @trade.symbol
					fill = @trade.fill
					stop = @trade.stop 
					targ1 = @trade.targ1 
					prob1 = @trade.prob1 
					prob2 = @trade.prob2 ||= 0.0
					targ2 = @trade.targ2 ||= 0.0
					stop2 = @trade.stop2 ||= fill
					spread = @trade.spread.to_i

					stop2 = fill if stop2 == 0.0
					second_target = @trade.second_target || false
					sellpct = @trade.sellpct || 0.5



					prob1 /= 100.0 if prob1 > 1
					prob2 /= 100.0 if prob2 > 1
					sellpct /=100.0 if sellpct > 1

					risk = (fill - stop).abs
					reward = (targ1 - fill).abs
					prob2 = 0.0 if !second_target?
					
					@house = house(risk, security_symbol, spread)

				
					fraction = current_user.kelly_fraction
					account_size = current_user.account_size


					(@kelly, @edge) = kelly(security_symbol, stop, fill, targ1, targ2, prob1, prob2, stop2: stop2, sellpct: sellpct, spread: spread )

					@best_sellpct = getbestkelly(security_symbol,stop,fill,targ1,targ2,prob1,prob2,stop2: stop2, spread: spread).round(3) * 100 if prob2 > 0.0

					@alloc = get_alloc(@kelly, account_size, security_symbol, risk, fraction).round(2)

					@alloc = "no trade" if @alloc < 1.0

					@price = fill

					@spread = spread
					@sellpct = sellpct * 100
					

					@quantity = @alloc.round(0) unless @alloc == "no trade"
					@desc = make_desc(fill,stop,security_symbol,@quantity)


					@kelly *= 100
					@edge *= 100
					@house *=100

					@rr = (reward/risk).round(1)
				end

				render 'static_pages/home'
				
			else

				
				if params[:commit]== "Post" and @trade.save
					flash[:success] = "Trade created"
					redirect_to root_url
				else
					
					@spread = get_spread(@trade.symbol) if params[:get_spread] == 'get_spread'
					@get_spread = ""					
					render 'static_pages/home'
				end	
			end				
		end


	def destroy		
	end

	private

		def trade_params
			params.require(:trade).permit(:fill, :stop, :targ1, :targ2, :prob1, :prob2, :desc, :comments, :symbol, :edge,
												:security_id, :stop2, :commit, :second_target, :sellpct, :pass, :kelly, :get_spread, :spread,
												 :market_condition => [],
												entries_attributes: [:id, :price, :quantity, :entrytime, :trade_id] )
		end

		def calculate_params
			params.require(:trade).permit(:fill, :stop, :targ1, :targ2, :prob1, :prob2, :security_id, :commit,
																				 :second_target, :sellpct, :spread)
		end

		def second_target?
			@trade.second_target == true
		end

end

		