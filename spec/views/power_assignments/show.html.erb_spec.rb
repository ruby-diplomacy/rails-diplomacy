require 'spec_helper'

describe "power_assignments/show" do
  before(:each) do
    @power_assignment = assign(:power_assignment, stub_model(PowerAssignment))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
