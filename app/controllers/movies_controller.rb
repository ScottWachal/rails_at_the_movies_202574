class MoviesController < ApplicationController
  def index
    @movies = Movie.all
    # @movies is passed to the view for Movies#index
  end

  def show
    # params[:id] is the value after the forward slash in the url:
    # example: http://localhost:3000/movies/1   <== the 1 is the :id value
    @movie = Movie.find(params[:id])
    # @movie is passed to the view for Movies#show
  end
end
