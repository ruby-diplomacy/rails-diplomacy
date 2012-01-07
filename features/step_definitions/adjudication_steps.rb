require_relative '../../lib/adjudicator/adjudicator'

Given /^current state "([^"]*)"$/ do |currentstate|
  parse_units(currentstate)
  
  adjudicator.map.areas[:Tri].should_not be_nil
end

When /^I adjudicate a set of "([^"]*)"$/ do |orderblob|
  # read orders
  parse_orders(orderblob)
  
  # adjudicate orders
  new_state, @adjudicated_orders = adjudicator.resolve(gamestate, orders)
end

Then /^the "([^"]*)" should be correct\.$/ do |adjudication|
  adjudication.length.should == @adjudicated_orders.length
  
  # check orders
  adjudication.length.times do |index|
    case adjudication[index]
    when 'S'
      @adjudicated_orders[index].status.should == Diplomacy::OrderWrapper::SUCCESS
    when 'F'
      @adjudicated_orders[index].status.should == Diplomacy::OrderWrapper::FAILURE
    end
  end
end

