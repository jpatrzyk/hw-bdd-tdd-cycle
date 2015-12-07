require "rails_helper"

describe MoviesController do
  
  before(:each) do
    @movie = double("movie", :id => 123, :title => "The Godfather", :director => "Francis Ford Coppola", :rating => "R")
  end
  
  context "GET_similar_movies" do
    it "calls the model to find all movies with the same director" do
      Movie.stub(:find).with(@movie.id.to_s).and_return(@movie)
      expect(@movie).to receive(:find_similar)
      get :similar, :id => @movie.id
    end
    
    it "passes movie to view" do
      Movie.stub(:find).with(@movie.id.to_s).and_return(@movie)
      @movie.stub(:find_similar)
      get :similar, :id => @movie.id
      expect(assigns(:movie)).to eq(@movie)
    end
    
    it "passes similar movies to view" do
      Movie.stub(:find).with(@movie.id.to_s).and_return(@movie)
      @movie.stub(:find_similar).and_return([@movie])
      get :similar, :id => @movie.id
      expect(assigns(:movies)).to match_array([@movie])
    end
    
    it "redirects to home page if the movie has no director specified" do
      @movie.stub(:director).and_return(nil)
      Movie.stub(:find).with(@movie.id.to_s).and_return(@movie)
      get :similar, :id => @movie.id
      expect(response).to redirect_to(movies_path)
    end
  end
  
  context "GET_movie" do
    it "assigns movie for view" do
      Movie.stub(:find).with(@movie.id.to_s).and_return(@movie)
      get :show, :id => @movie.id
      expect(assigns(:movie)).to eq(@movie)
    end
  end
  
  context "GET_edit_movie" do
    it "calls Movie.find with proper id" do
      expect(Movie).to receive(:find).with(@movie.id.to_s)
      get :edit, :id => @movie.id
    end
  end
  
  context "PUT_(update)_movie" do
    it "redirects to Movie Details page" do
      Movie.stub(:find).with(@movie.id.to_s).and_return(@movie)
      expect(@movie).to receive(:update_attributes!).with({"director"=>"New Director"})
      put :update, :id => @movie.id, :movie => { :director => "New Director" }
    end
    
    it "redirects to Movie Details page" do
      Movie.stub(:find).with(@movie.id.to_s).and_return(@movie)
      @movie.stub(:update_attributes!)
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
      @movie.stub(:destroy)
      delete :destroy, :id => id
      expect(response).to redirect_to(movies_path)
    end
  end
  
end