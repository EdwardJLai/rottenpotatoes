module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  def sort
    @movies = Movie.find(:all, :order => 'title')
    redirect_to movies_path
  end
end
