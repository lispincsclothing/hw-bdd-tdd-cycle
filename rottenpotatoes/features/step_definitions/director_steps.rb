Given(/^the following movies exist:$/) do |movies_table|
  movies_table.hashes.each { |movie| Movie.create!(movie) }
end

Then(/^the director of "(.*?)" should be "(.*?)"$/) do |movie, director|
  expect(page).to have_content(movie)
  expect(page).to have_content(director)
end
