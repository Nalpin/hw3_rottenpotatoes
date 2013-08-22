# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    unless Movie.find_by_title(movie[:title])
      Movie.create(movie)
    end
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  row_num = []
  # debugger
  [e1, e2].each do |e|
    row_num << page.find('table#movies tbody td[1]', :text => e).path.match(/.*tr\[(\d)\]/)[1]
  end
  row_num[0].should < row_num[1]
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(', ').each do |rating|
    # debugger
    step uncheck ? %{I uncheck "ratings_#{rating}"} : %{I check "ratings_#{rating}"}
  end
end


Then /I should (not\s)?see movies with the ratings: (.*)/ do |dont_see, rating_list|
  page.all('table#movies tbody td[2]').map(&:text).each do |cell| 
    #debugger
    rating_list.split(', ').include?(cell) != dont_see
  end 
end 

When /I check all the ratings/ do 
  Movie.all_ratings.each do |rating|
    # debugger
    step %{I check "ratings_#{rating}"}
  end
end

Then /I should see all the movies/ do
  # debugger
  # page.should have_css("table#movies tr", :count => Movie.find(:all).length)
  page.all('table#movies tbody tr').count.should == Movie.find(:all).length
end 
