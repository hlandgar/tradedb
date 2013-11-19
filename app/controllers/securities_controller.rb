class SecuritiesController < ApplicationController
	before_action :signed_in_user
	before_action :correct_user

	def index
			@securities = current_user.securities.paginate(page: params[:page])
	end

	def new
		@security = current_user.securities.build
	end

	def create
		@user = User.find(params[:user_id])
		@security = @user.securities.build(security_params)
		if @security.save
			flash[:success] = "Security Created"
			redirect_to user_securities_path(@user)
		else			
			render 'new'
		end		
	end

	private

		def security_params
			params.require(:security).permit(:create, :symbol, :description, :security_type,
																				:currency, :tick_size, :tickval, :default_spread,
																				:decimal_places, :sort_order)
		end
end