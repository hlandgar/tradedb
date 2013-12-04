class TradesController < ApplicationController
	include ApplicationHelper
	include UsersHelper
	before_action :signed_in_user

	def create
		@trade = current_user.trades.build(trade_params)
		@trade.pass = false


		

		if params[:commit] == 'Calculate' 
			@trade.pass = true

			

			if @trade.valid?
				

				security_id = @trade.security_id
				fill = @trade.fill 
				stop = @trade.stop 
				targ1 = @trade.targ1 
				prob1 = @trade.prob1 
				prob2 = @trade.prob2 ||= 0.0
				targ2 = @trade.targ2 ||= 0.0
				stop2 = @trade.stop2 ||= fill

				stop2 = fill if stop2 == 0.0
				second_target = @trade.second_target || false
				sellpct = @trade.sellpct || 0.5



				prob1 /= 100.0 if prob1 > 1
				prob2 /= 100.0 if prob2 > 1
				sellpct /=100.0 if sellpct > 1

				risk = (fill - stop).abs
				reward = (targ1 - fill).abs
				prob2 = 0.0 if !second_target?
				@spread = get_spread(current_user.securities.find(security_id).symbol)
				@house = house(risk, security_id)
			
				fraction = current_user.kelly_fraction
				account_size = current_user.account_size


				(@kelly, @edge) = kelly(security_id, stop, fill, targ1, targ2, prob1, prob2, stop2: stop2, sellpct: sellpct )

				@best_sellpct = getbestkelly(security_id,stop,fill,targ1,targ2,prob1,prob2,stop2: stop2).round(3) * 100 if prob2 > 0.0

				@alloc = get_alloc(@kelly, account_size, security_id, risk, fraction).round(2)

				@alloc = "no trade" if @alloc < 1.0

				@price = fill
				
				

				@quantity = @alloc.round(0) unless @alloc == "no trade"
				@desc = make_desc(fill,stop,security_id,@quantity)


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
												:security_id, :stop2, :commit, :second_target, :sellpct, :pass, :kelly,
												entries_attributes: [:id, :price, :quantity, :entrytime, :trade_id] )
		end

		def calculate_params
			params.require(:trade).permit(:fill, :stop, :targ1, :targ2, :prob1, :prob2, :security_id, :commit,
																				 :second_target, :sellpct )
		end

		def second_target?
			@trade.second_target == true
		end

end

		