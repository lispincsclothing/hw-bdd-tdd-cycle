require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  before :each do
    @fake_movie = FactoryGirl.create(:movie)
    @fake_movie2 = FactoryGirl.create(:movie)
    @fake_movie3 = FactoryGirl.create(:movie)
    @fake_results = [@fake_movie3, @fake_movie2]
    @empty_dir_movie = FactoryGirl.create(:no_dir_movie)
    @all_ratings = { :G => 'G', :PG => 'PG', 'PG-13'.to_sym => 'PG-13', 'NC-17'.to_sym => 'NC-17', :R => 'R' }
    @some_ratings = { :G => 'G'}
  end

  describe 'updating director information' do
    before(:each) do
      allow(Movie).to receive(:find).with(@fake_movie.id.to_s).and_return(@fake_movie)
    end

    it 'should call update_attributes and redirect to show movie page' do
      allow(@fake_movie).to receive(:update_attributes).and_return(true)
      put :update, id: @fake_movie.id, movie: @fake_movie.attributes
      expect(response).to redirect_to(movie_path(@fake_movie))
    end
  end

  describe 'update the total attributes' do
    let(:attr) do
      { director: 'content' }
    end
    before(:each) do
      put :update, id: @fake_movie.id.to_s, movie: attr
      # Have to reload since the database is updated
      @fake_movie.reload
    end

    it 'should update the actual attributes' do
      expect(response).to redirect_to(@fake_movie)
      expect(@fake_movie.director).to eql attr[:director]
    end
  end

  describe 'happy path directors' do
    before(:each) do
      allow_any_instance_of(Movie).to receive(:movies_with_same_director).and_return(@fake_results)
    end

    it 'should generate routing for similar movies' do
      expect route_to(controller: 'movies', action: 'similar', movie_id: @fake_movie.id.to_s)
      # TODO: Investigate why below works with both get and post routing (should fail with post)
      { get: similar_movie_path(@fake_movie.id.to_s) }
    end

    it 'should call the model method that finds similar movies' do
      # TODO: Reimplement when you have the model method as a class method (rather than instance method) - fundamental question is whether movie should know of other movies.  Perhaps post question on stackexchange?
      # @fake_movie.should_receive(:movies_with_same_director).and_return(@fake_results)
      # The two below are equivalent - note the first get calls the controller method (NOT the route)
      # # get :similar, id: @fake_movie.id.to_s
      { get: similar_movie_path(@fake_movie.id.to_s) }
    end

    it 'should render the similar template with the similar movies' do
      get :similar, id: @fake_movie.id.to_s
      expect(response).to render_template('similar')
    end

    it 'should assign instance variable @movies correctly' do
      # TODO: Is this actually checking same variable?  Or just exercising stub?
      get :similar, id: @fake_movie.id.to_s
      expect((assigns(:movies)) == @fake_results)
    end
  end

  describe 'sad path directors' do
    before(:each) do
      allow(Movie).to receive(:find).with(@empty_dir_movie.id.to_s).and_return(@empty_dir_movie)
    end

    it 'should generate routing for similar movies' do
      # TODO: Investigate why below works with both get and post routing (should fail with post)
      # should this even exist, as we're checking in happy path?
      expect route_to(controller: 'movies', action: 'similar', id: @empty_dir_movie.id.to_s)
      { get: similar_movie_path(@empty_dir_movie.id.to_s) }
    end

    it 'should return to home page w flash message' do
      get :similar, id: @empty_dir_movie.id.to_s
      expect(flash[:notice]).to_not be_blank
    end
  end

  describe 'create and destroy' do
    it 'should request the model to create a new movie & redirect' do
      # TODO: Explain why this words without destroy being implemented
      # allow(Movie).to receive(:create).with(@fake_movie.attributes).and_return(@fake_movie)
      post :create, movie: @fake_movie.attributes
      expect(response).to redirect_to(movies_path)
    end
    it 'should destroy a movie when valid and redirect to main movies' do
      # TODO: Explain why this words without destroy being implemented
      # # allow(@fake_movie).to receive(:destroy)
      delete :destroy, id: @fake_movie.id.to_s
      expect(response).to redirect_to(movies_path)
    end
    it 'should flash error on destroy a movie when valid and redirect to main movies' do
      delete :destroy, id: @fake_movie.id.to_s
      expect(flash { :notice }).to_not be_blank
    end
  end

  describe 'edit' do
    it 'should find the movie dirrect and render edit template' do
      delete :edit, id: @fake_movie.id.to_s
      expect(response).to render_template('edit')
    end
  end

  describe 'sort and filter at index' do
    it 'should redirect if sort order has been changed' do
      session[:sort] = 'release_date'
      get :index, sort: 'title'
      expect(response).to redirect_to(movies_path(sort: 'title', ratings: @all_ratings))
      # HOW TO CHECK ON REDIRECT WITH PARAMS  without doing this?????? => can we use uri like capybara OR can we capture the URI and regex the result for instance???
      # Expected <http://test.host/movies?ratings%5BG%5D=G&ratings%5BNC-17%5D=NC-17&ratings%5BPG%5D=PG&ratings%5BPG-13%5D=PG-13&ratings%5BR%5D=R&sort=release_date>
      # but was  <http://test.host/movies?ratings%5BG%5D=G&ratings%5BNC-17%5D=NC-17&ratings%5BPG%5D=PG&ratings%5BPG-13%5D=PG-13&ratings%5BR%5D=R&sort=title>.
      # @uri = URI.parse(current_url)
      # "#{@uri.path}?#{@uri.query}".should == people_path(:search => 'name')
    end

    it 'should be possible to order by release date' do
      get :index, {sort:'release_date'}
      expect(response).to redirect_to(movies_path(sort:'release_date', ratings: @all_ratings))
    end
    it 'should redirect if selected ratings are changed' do
      get :index, {ratings:@some_ratings}
      expect(response).to redirect_to(movies_path(ratings:@some_ratings))
    end
    it 'should call database to get movies' do
      allow(Movie).to receive(:all_ratings).and_return(@all_ratings)
      get :index
    end
  end
end
