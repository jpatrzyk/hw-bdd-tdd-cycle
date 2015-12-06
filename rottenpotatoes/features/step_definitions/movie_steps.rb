
Given /the following movies exist/ do |table|
  table.hashes.each do |movie|
    Movie.create!(movie);
  end
end

Then(/^the director of "(.*?)" should be "(.*?)"$/) do |movie, director|
  page.body.should match(Regexp.new("Director:.*#{director}", Regexp::MULTILINE))
end