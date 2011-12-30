require 'spec_helper'

describe Diplomacy::Adjudicator do
  let(:yaml_file) {Rails.root + '/lib/graph/maps.yaml'}
  let(:map_reader) {Diplomacy::MapReader.new(yaml_file)}
  let(:map) {map_reader.maps["Standard"]}
  let(:game_state) {GameState.new}

  subject {Diplomacy::Adjudicator.new(map)}

  before {
    game_state[:SEV] = FactoryGirl.create
    game_state[:CON] = FactoryGirl.create :area_state
  }
  
  describe "#validate_orders" 

  describe "#resolve" do  
    let(:orders) {[]}
    it "should resolve the orders" do 
      subject.should_receive(:validate_orders).with(any_args).and_return(orders)
      orders.each do |o|
        subject.should_receive(:resolve_order).with(o)
      end
      subject.resolve
    end
  end
end
