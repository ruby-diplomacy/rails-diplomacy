require 'spec_helper'

describe "power_assignments/edit" do
  before(:each) do
    @power_assignment = assign(:power_assignment, stub_model(PowerAssignment))
  end

  it "renders the edit power_assignment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", power_assignment_path(@power_assignment), "post" do
    end
  end
end
