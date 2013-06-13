require 'spec_helper'

describe "power_assignments/new" do
  before(:each) do
    assign(:power_assignment, stub_model(PowerAssignment).as_new_record)
  end

  it "renders new power_assignment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", power_assignments_path, "post" do
    end
  end
end
