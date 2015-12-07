require "rails_helper"

describe Movie do
  it "can have director specified" do
      movie = Movie.create(title: "Asd", director: "John Smith")
      expect(movie).to be_valid
  end
  
  it "finds similar movies by director" do
    movie1 = Movie.create(title: "Asd", director: "John Smith")
    movie2 = Movie.create(title: "Other title", director: "John Smith")
    expect(movie1.find_similar).to match_array([movie1, movie2])
  end
end