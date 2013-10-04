class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.possible_ratings()
    @title = nil
    @date = nil
    @checked = @all_ratings
    if params[:sorted] != nil
      session[:sorted] = params[:sorted]
    end
    if params[:ratings] != nil
      @movies = Movie.find(:all, :conditions => {:rating => params[:ratings].keys}, :order => session[:sorted])
      session[:ratings] = params[:ratings]
      @checked = params[:ratings].keys
    elsif session[:ratings] != nil
      @movies = Movie.find(:all, :conditions => {:rating => session[:ratings].keys}, :order => session[:sorted])
      @checked = session[:ratings].keys
    else
      @movies = Movie.find(:all, :order => session[:sorted])
    end
    if session[:sorted] == 'title'
      @title = 'hilite'
    elsif session[:sorted] == 'release_date'
      @date = 'hilite'
    end
    if (params[:sorted] == nil or params[:ratings] == nil) and session[:sorted] and session[:ratings]
      flash.keep
      redirect_to movies_path(:sorted => session[:sorted], :ratings => session[:ratings])
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
