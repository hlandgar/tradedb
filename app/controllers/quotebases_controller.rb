class QuotebasesController < ApplicationController

	def new
		@quote = Quotebase.new
	end

	def create
		@quote = Quotebase.new(quote_params)
		if @quote.save
			flash[:success] = "quote saved"
			render "index"
		else
			render "new"
		end

	end

	def index
		@quotes = Quotebase.all
	end

	def edit
		@quote = params[quote_params]
	end

	def destroy
		
	end

	def update
		
	end

	private

	def quote_params
		params.require(:quotebase).permit(:symbol, :yahoo_symbol)
	end
end
