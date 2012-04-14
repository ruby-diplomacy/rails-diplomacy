require 'spec_helper'

describe Variant  do
  it {should have_many :games}
  it {should have_many :powers}

  describe "select_options" do
    it "should return options_for_select" do
      variants = FactoryGirl.create_list :variant, 3
      Variant.options_for_select.should == variants.collect {|v| [v.name, v.id]}
    end
  end

end
