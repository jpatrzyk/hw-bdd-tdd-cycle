require "rails_helper"

describe Movie do
  it "is can have director specified" do
      movie = Movie.create(title: "Asd", director: "John Smith")
      movie.should be_valid
  end
end