class SearchController < ApplicationController
	def search
	  if params[:q].nil?
	    @users = []
	  else
	    @users = Elasticsearch::Model.search(params[:q], [Snapuser]).records.to_a
	  end
	end
end
