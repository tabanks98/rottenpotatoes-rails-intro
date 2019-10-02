class MoviesController < ApplicationController
  helper_method :hilight
  helper_method :chosen_rating?

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
      @all_ratings = ['G','PG','PG-13','R']
      session[:ratings] = params[:ratings] unless params[:ratings] == nil
      session[:order] = params[:order] unless params[:order] == nil
      if ((params[:order] == nil) && !(session[:order] == nil)) || ((params[:ratings] == nil) && !(session[:ratings] == nil))
        redirect_to movies_path("ratings" => session[:ratings], "order" => session[:order])
      elsif !(params[:ratings] == nil) || !(params[:order] == nil)
        if !(params[:order] == nil)
          return @movies = Movie.all.order(session[:order])
        else
          array_ratings = params[:ratings].keys
          return @movies = Movie.where(rating: array_ratings).order(session[:order])
        end
      elsif !(session[:ratings] == nil) || !(session[:order] == nil)
        redirect_to movies_path("ratings" => session[:ratings], "order" => session[:order])
      else
        return @movies = Movie.all
      end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def hilightColumn(column)
      if(session[:order].to_s == column)
        return 'hilite'
      else
        return nil
      end
    end

  def chosen_rating?(rating)
      chosen_ratings = session[:ratings]
      return true if chosen_ratings.nil?
      chosen_ratings.include? rating
  end
    
end
