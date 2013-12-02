class SecuritiesController < ApplicationController
	include ApplicationHelper
	before_action :signed_in_user
	before_action :correct_user

	def index
		@securities = current_user.securities.paginate(page: params[:page])
	end

	def new
		@security = current_user.securities.build
	end

	def create
		@security = current_user.securities.build(security_params)
		if @security.save
			flash[:success] = "Security Created"
			redirect_to user_securities_path(current_user)
		else			
			render 'new'
		end		
	end

	def edit
		@security = current_user.securities.find(params[:id])
  end

  def update
  	@security = current_user.securities.find(params[:id])
    if @security.update_attributes(security_params)
      flash[:success] = "Security updated"
      redirect_to user_securities_path(current_user)
    else
      render 'edit'
    end
  end

	private

		def security_params
			params.require(:security).permit(:create, :symbol, :description, :security_type,
																				:currency, :tick_size, :tickval, :default_spread,
																				:decimal_places, :sort_order)
		end
end