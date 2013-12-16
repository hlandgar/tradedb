class CatagoriesController < ApplicationController
  def new
  	@category = current_user.categories.build
  end

  def create
  	@category = current_user.categories.build(category_params)
  	if @category.save
  		flash[:success] = "Category Created"
  		redirect_to user_categories_path(current_user)
  	else
  		render 'new'
  	end
  end

  def destroy
  end
end


private
	
	def category_params
		params.require(:category).permit(:name)
	end