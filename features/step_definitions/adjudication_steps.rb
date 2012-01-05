require_relative '../../lib/adjudicator/adjudicator'

Given /^current state "([^"]*)"$/ do |currentstate|
  unit_match = /(\w{3}):([AF]\w{3})+/.match(currentstate)
  
  p "First match: #{unit_match[2]}" unless unit_match.nil?
  
  pending # express the regexp above with the code you wish you had
end

When /^I adjudicate a set of "([^"]*)"$/ do |orders|
  # adjudicate orders
  #new_state, @orders = adjudicator.resolve(state, order_list)
  pending # express the regexp above with the code you wish you had
end

Then /^the "([^"]*)" should be correct\.$/ do |adjudication|
  # check orders
  pending # express the regexp above with the code you wish you had
end

