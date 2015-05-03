class SearchController < ApplicationController
	def index
	  if params[:q].nil?
	    @users = []
	    # @classes = []
	    @projects = []
	  else
	    @users = User.search(params[:q])
	    # @classes = Snapclass.search(params[:q])
	    @projects = Project.search(params[:q])
	  end
	end
end
