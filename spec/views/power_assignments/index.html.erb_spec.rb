require 'spec_helper'

describe "power_assignments/index" do
  before(:each) do
    assign(:power_assignments, [
      stub_model(PowerAssignment),
      stub_model(PowerAssignment)
    ])
  end

  it "renders a list of power_assignments" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
