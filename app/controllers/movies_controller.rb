class MoviesController < ApplicationController
  
  def set_order(order_val)
     if order_val == "movie_title" 
        @title_class = "bg-warning hilite"
        @release_class = ""
        @movies.order!(:title)
    elsif order_val == "release_date"
        @release_class = "bg-warning hilite"
        @title_class = ""
        @movies.order!(:release_date)
    end
  end
    
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #byebug
    @all_ratings = Movie.all_ratings
    @ratings_to_show = []
   
    if params[:commit] == "Refresh"
      session.delete(:ratings)
    end
    
    if params[:ratings] != nil 
      @ratings_to_show =  params[:ratings].keys
      @movies = Movie.with_ratings(@ratings_to_show)
      session[:ratings] = params[:ratings]
    elsif session.key?(:ratings)
      @ratings_to_show =  session[:ratings].keys
      @movies = Movie.with_ratings(@ratings_to_show)
    else
      @movies = Movie.all
    end
 
    
    if params.key?(:order_val)
      set_order(params[:order_val])
      session[:order_val] = params[:order_val]
    elsif session.key?(:order_val)
        set_order(session[:order_val])
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
