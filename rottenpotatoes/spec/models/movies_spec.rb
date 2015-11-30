require 'rails_helper'
# http://stackoverflow.com/questions/5974360/rspec-difference-between-let-and-before-block

RSpec.describe 'Movies', type: :model do
  before(:each) do
    @fake_movie = FactoryGirl.create(:movie)
    @fake_movie2 = FactoryGirl.create(:movie)
    @fake_movie3 = FactoryGirl.create(:movie)
    @fake_results = [@fake_movie3, @fake_movie2]
    @diff_dir_movie = FactoryGirl.create(:diff_dir_movie)
    @empty_dir_movie = FactoryGirl.create(:no_dir_movie)
  end

  describe 'ratings' do
    it '#all_ratings has an array length of 5' do
      ratings = Movie.all_ratings
      expect(ratings.length).to eq(5)
    end
  end

  describe 'searching similar directors' do
    before(:each) do
      results = @fake_movie3.movies_with_same_director
      @results_array = []
      results.each do |result|
        @results_array << result.director
      end
    end

    it 'should find movies with the same directors' do
      # Don't manually check that each director is the same, rather do uniq
      # # expect(@results_array.uniq.first).to eql(@fake_movie3.director)
      # # expect(@results_array.uniq.first).to eql(@fake_movie2.director)
      # # expect(@results_array.uniq.first).to eql(@fake_movie.director)
      expect(@results_array.uniq.count).to eql(1)
    end

    it 'should return the correct number of movies with same director' do
      expect(@results_array.count).to eql(2)
    end

    it 'should not return movies which have different directors' do
      expect(@results_array.uniq.first).to_not eql(@empty_dir_movie.director)
      expect(@results_array.uniq.first).to_not eql(@diff_dir_movie.director)
    end
  end
end
