require "rails_helper"

describe MoviesController do
  
  before(:each) do
    @movie = FactoryGirl.create(:movie)
  end
  
  context "GET_similar_movies" do
    it "calls the model to find all movies with the same director" do
      expect_any_instance_of(Movie).to receive(:find_similar)
      get :similar, :id => @movie.id
    end
    
    it "passes movie to view" do
      get :similar, :id => @movie.id
      expect(assigns(:movie)).to eq(@movie)
    end
    
    it "passes similar movies to view" do
      get :similar, :id => @movie.id
      expect(assigns(:movies)).not_to be_empty
    end
    
    it "redirects to home page if the movie has no director specified" do
      movie1 = FactoryGirl.create(:movie, director: nil)
      get :similar, :id => movie1.id
      expect(response).to redirect_to(movies_path)
    end
  end
  
  context "PUT_(update)_movie" do
    it "redirects to Movie Details page" do
      put :update, :id => @movie.id, :movie => { :director => "New Director" }
      expect(response).to redirect_to(movie_path(@movie))
    end
  end
  
  context "GET /movies" do
    it "can filter movies by PG rating" do
      session[:ratings] = {"R" => "R"}
      where_stub = double("receiver")
      where_stub.stub(:order)
      expect(Movie).to receive(:where).with(:rating => ["R"]).and_return(where_stub)
      get :index, {:ratings => {"R" => "R"}}
    end
    
    it "can sort movies by title" do
      session[:sort] = 'title'
      where_stub = double("receiver")
      Movie.stub(:where).and_return(where_stub)
      expect(where_stub).to receive(:order).with({:title => :asc})
      get :index, {:sort => 'title'}
    end
    
    it "can sort movies by release_date" do
      session[:sort] = 'release_date'
      where_stub = double("receiver")
      Movie.stub(:where).and_return(where_stub)
      expect(where_stub).to receive(:order).with({:release_date => :asc})
      get :index, {:sort => 'release_date'}
    end
    
    it "shows movies not filtered by default" do
      where_stub = double("receiver")
      where_stub.stub(:order)
      expect(Movie).to receive(:where).with(:rating => Movie.all_ratings).and_return(where_stub)
      get :index
    end
    
    it "shows movies not sorted by default" do
      where_stub = double("receiver")
      Movie.stub(:where).and_return(where_stub)
      expect(where_stub).to receive(:order).with(nil)
      get :index
    end
    
    it "redirects when sort or ordering params dont equal to session" do
      ratings = Hash[Movie.all_ratings.map {|rating| [rating, rating]}]
      get :index, {:sort => 'title'}
      expect(response).to redirect_to movies_path(:sort => 'title', :ratings => ratings)
    end
  end
  
  context "create_movie" do
    it "calls Movie.create" do
      movie_stub = double("receiver")
      movie_stub.stub(:title)
      expect(Movie).to receive(:create!).and_return(movie_stub)
      post :create, {:movie => {:title => "some title", :director => "some director", :rating => "PG-13"}}
    end
    
    it "redirects to /movies path" do
      movie_stub = double("receiver")
      movie_stub.stub(:title)
      Movie.stub(:create!).and_return(movie_stub)
      post :create, {:movie => {:title => "some title", :director => "some director", :rating => "PG-13"}}
      expect(response).to redirect_to(movies_path)
    end
  end
  
  context "delete_movie" do
    it "calls destroy on found instance" do
      id = "2"
      Movie.stub(:find).with(id).and_return(@movie)
      expect(@movie).to receive(:destroy)
      delete :destroy, :id => id
    end
    
    it "redirects to /movies path" do
      id = "2"
      Movie.stub(:find).with(id).and_return(@movie)
      delete :destroy, :id => id
      expect(response).to redirect_to(movies_path)
    end
  end
  
end