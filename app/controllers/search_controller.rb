class SearchController < ApplicationController
	def index
    # options = {
    #   category:       params[:c],
    #   author:         params[:a],
    #   published_week: params[:w],
    #   published_day:  params[:d],
    #   sort:           params[:s],
    #  }
	  if params[:q].nil?
	    @users = []
	    # @classes = []
	    @projects = []
	  else
	    @users = Snapuser.search(params[:q])
	    # @classes = Snapclass.search(params[:q])
	    @projects = Snapproject.search(params[:q])
	  end
	end
end
