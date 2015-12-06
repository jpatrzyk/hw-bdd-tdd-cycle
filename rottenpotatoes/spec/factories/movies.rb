# This will guess the User class
FactoryGirl.define do
  factory :movie do
    title "The Godfather"
    rating "R"
    description "Opowieść o nowojorskiej rodzinie mafijnej. Starzejący się Don Corleone pragnie przekazać władzę swojemu synowi."
    release_date 1972-03-15
    director "Francis Ford Coppola"
  end
end