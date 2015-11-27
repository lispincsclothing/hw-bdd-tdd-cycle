class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  def movies_with_same_director
    # List of all movies with same director, except current movie
    movies_without_original_movie = Movie.where(director:self.director).where.not(id: self.id)
  end
end
