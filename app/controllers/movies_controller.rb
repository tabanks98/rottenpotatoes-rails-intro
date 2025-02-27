class MoviesController < ApplicationController

  def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end


  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @all_ratings = Movie.all_ratings 
      
    
    
    if params[:ratings] != nil
      @checked_ratings = params[:ratings].keys
      session[:ratings] = params[:ratings]
    elsif session[:ratings] != nil
      @checked_ratings = session[:ratings].keys
    else
      @checked_ratings = @all_ratings
    end
    
    if params[:sort_val] == nil && session[:sort_val] != nil
      @sort_val = session[:sort_val]
    else
      @sort_val = params[:sort_val]
      session[:sort_val] = params[:sort_val]
    end
    
    if @sort_val == 'title'
      @title_header = 'hilite'
      @movies = Movie.order(:title).where(rating: @checked_ratings)
    elsif @sort_val == 'release_date'
      @release_date_header = 'hilite'
      @movies = Movie.order(:release_date).where(rating: @checked_ratings)
    else
      @movies = Movie.where(rating: @checked_ratings)
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
    
end
