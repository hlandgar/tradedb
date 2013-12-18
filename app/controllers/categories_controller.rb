class CategoriesController < ApplicationController
	before_action :signed_in_user
	before_action :correct_user

	def index
		@categories = current_user.categories
	end

	def edit
		@category = current_user.categories.find(params[:id])
  	@category.tags.build
		
	end

  def new
  	@category = current_user.categories.build
  	if @category.tags.empty?
			@category.tags.build			
		end
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

  def update
  	@category = current_user.categories.find(params[:id])
  	if @category.update(category_params)
  		flash[:success] = "Category updated"
  		redirect_to user_categories_path(current_user)
  	else
  		render 'edit'
  	end
  end

  def destroy
  	Category.find(params[:id]).destroy
  	flash[:success] = "Category deleted"
  	redirect_to 
  end
end


private
	
	def category_params
		params.require(:category).permit(:id, :name, :user_id, tags_attributes: [:id, :category_id, :name, :_destroy] )
	end