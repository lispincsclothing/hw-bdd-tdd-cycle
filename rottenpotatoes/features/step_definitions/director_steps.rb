Given(/^the following movies exist:$/) do |movies_table|
  movies_table.hashes.each { |movie| Movie.create!(movie) }
end
