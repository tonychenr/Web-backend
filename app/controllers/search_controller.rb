class SearchController < ApplicationController
	def search
	  if params[:q].nil?
	    @users = []
	  else
	    @users = Elasticsearch::Model.search(
	    					query: { match: { param[:q] } }, 
	    					[Snapuser]).records.to_a
	  end
	end
end
