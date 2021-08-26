# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController

  def all_ratings
    ['G','PG','PG-13','R','NC-17']
  end

  def index
    @all_ratings = all_ratings
    @selected_ratings = @all_ratings

    if(session.has_key?(:sort_by) and !params.has_key?(:sort_by))
      params[:sort_by] = session[:sort_by]
    end
    if(session.has_key?(:ratings) and !params.has_key?(:ratings))
      params[:ratings] = session[:ratings]
    end

    #faz o select de todos que precisa
    if params.has_key?(:ratings) and !params[:ratings].empty?
      @selected_ratings = params[:ratings].keys
      @movies = Movie.where(rating: @selected_ratings)
      session[:ratings] = Hash[@selected_ratings.map {|x| [x, 1]}]
    else
      @movies = Movie.all
    end

    if params[:sort_by] == "title"
      @movies = @movies.order(:title)
      session[:sort_by] = "title"
    elsif params[:sort_by] == "release_date"
      @movies = @movies.order(:release_date)
      session[:sort_by] = "release_date"
    end
  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
  end

  def new
    @movie = Movie.new
  end

  def create
    #@movie = Movie.create!(params[:movie]) #did not work on rails 5.
    @movie = Movie.create(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created!"
    redirect_to movies_path
  end

  def movie_params
    params.require(:movie).permit(:title,:rating,:description,:release_date)
  end

  def edit
    id = params[:id]
    @movie = Movie.find(id)
    #@movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    #@movie.update_attributes!(params[:movie])#did not work on rails 5.
    @movie.update(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated!"
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy
    flash[:notice] = "#{@movie.title} was deleted!"
    redirect_to movies_path
  end
end

