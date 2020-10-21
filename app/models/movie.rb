class Movie < ActiveRecord::Base
  @@all_ratings = ['G', 'PG', 'PG-13', 'R']
  
  def self.with_ratings(ratings_list) do
    Movie.where(rating: ratings_list)
  end 
end
