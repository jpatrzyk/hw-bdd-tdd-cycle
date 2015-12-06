require "rails_helper"

describe MoviesController do
  it "redirects to Movie Details page" do
    movie = FactoryGirl.create(:movie)
    put :update, :id => movie.id, :movie => { :director => "New Director" }
    response.should redirect_to(movie_path(movie))
  end
  
  it "shows similar movies" do
      
  end
end