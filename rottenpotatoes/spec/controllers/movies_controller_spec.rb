require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  describe 'add director' do
    before(:each) do
      @m = FactoryGirl.create(:movie)
      # @m=double(Movie, title:"Star Wars", director:"director", id:1)
      # allow(Movie).to receive(:find).with(@m.id.to_s).and_return(@m)
    end
    it 'should call update_attributes and redirect' do
      # allow(@m).to receive(:update_attributes).and_return(true)
      put :update, {id:@m.id, movie:@m.attributes}
    end
  end
end
