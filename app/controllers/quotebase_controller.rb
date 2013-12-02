class QuotebasesController < ApplicationController

	def new
		@quote = Quotebase.new
	end

	def create
		@quote = params[:quote_params]

	end

	def index
		@quotes = quotebases.find(:all)
	end

	def edit
		@quote = params[:quote_params]
	end

	def destroy
		
	end

	def update
		
	end

	private

	def quote_params
		params.require(:quote).permit(:symbol, :yahoo_symbol)
	end
end
