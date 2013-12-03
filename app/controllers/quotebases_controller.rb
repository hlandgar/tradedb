class QuotebasesController < ApplicationController

	before_action :admin_user

	def new
		@quote = Quotebase.new
	end

	def create
		@quote = Quotebase.new(quote_params)
		if @quote.save
			flash[:success] = "quote saved"
			redirect_to quotebases_path
		else
			render "new"
		end

	end

	def index
		@quotes = Quotebase.all
	end

	def edit
		@quote = Quotebase.find(params[:id])
	end

	def destroy
		
	end

	def update
		@quote = Quotebase.find(params[:id])
		if @quote.update_attributes(quote_params)
			flash[:success] = "Quote updated"
			redirect_to quotebases_path
		else
			render 'edit'
		end
		
	end

	private

	def quote_params
		params.require(:quotebase).permit(:symbol, :yahoo_symbol)
	end

	private

	   def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
