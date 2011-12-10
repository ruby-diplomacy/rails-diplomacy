require "test/unit"

require_relative 'orders'
require_relative 'state'
require_relative 'adjudicator'
require_relative '../graph/maps'

class TestAdjudication < Test::Unit::TestCase
  def setup
    @engine = Diplomacy::Adjudicator.new(Diplomacy::Standard_map)
    
    @gs = Diplomacy::GameState.new
  end
  
  def test_support
    russian_units = [Diplomacy::Unit.new(:Russia, Diplomacy::Unit::ARMY), Diplomacy::Unit.new(:Russia, Diplomacy::Unit::ARMY)]
    @gs[:Sev] = Diplomacy::AreaState.new(:Russia, russian_units[0])
    @gs[:Mos] = Diplomacy::AreaState.new(:Russia, russian_units[1])
    
    german_units = [Diplomacy::Unit.new(:Germany, Diplomacy::Unit::ARMY), Diplomacy::Unit.new(:Germany, Diplomacy::Unit::ARMY)]
    @gs[:War] = Diplomacy::AreaState.new(:Germany, german_units[0])
    @gs[:Ukr] = Diplomacy::AreaState.new(:Germany, german_units[1])
    
    orders = []
    orders << Diplomacy::Support.new(russian_units[0], :Sev, :Mos, :Ukr)
    orders << Diplomacy::Move.new(russian_units[1], :Mos, :Ukr)
    orders << Diplomacy::Support.new(german_units[0], :War, :Mos, :Ukr)
    orders << Diplomacy::Hold.new(german_units[1], :Ukr)
    
    state_after,orders = @engine.resolve(@gs, orders)
    
    orders.each do |order|
      puts order.to_s
    end
    
    assert_equal(Diplomacy::OrderWrapper::SUCCESS, orders[0].status, orders[0].to_s+" should have succeeded")
    assert_equal(Diplomacy::OrderWrapper::SUCCESS, orders[2].status, orders[2].to_s+" should have succeeded")
    
  end
  
  def test_simple
    
    russian_units = [Diplomacy::Unit.new(:Russia, Diplomacy::Unit::ARMY), Diplomacy::Unit.new(:Russia, Diplomacy::Unit::ARMY)]
    @gs[:Ukr] = Diplomacy::AreaState.new(:Russia, russian_units[0])
    @gs[:Mos] = Diplomacy::AreaState.new(:Russia, russian_units[1])
    
    german_units = [Diplomacy::Unit.new(:Germany, Diplomacy::Unit::ARMY), Diplomacy::Unit.new(:Germany, Diplomacy::Unit::ARMY)]
    @gs[:War] = Diplomacy::AreaState.new(:Russia, german_units[0])
    @gs[:Gal] = Diplomacy::AreaState.new(:Russia, german_units[1])
    
    orders = []
    orders << Diplomacy::Support.new(russian_units[0], :Ukr, :War, :Mos)
    orders << Diplomacy::Move.new(russian_units[1], :Mos, :War)
    
    orders << Diplomacy::Move.new(german_units[0], :War, :Mos)
    orders << Diplomacy::Move.new(german_units[1], :Gal, :Ukr)
    
    state_after,orders = @engine.resolve(@gs, orders)
    
    orders.each do |order|
      puts order.to_s
    end
    
    assert_equal(Diplomacy::OrderWrapper::FAILURE, orders[0].status, orders[0].to_s+" should have been cut by "+orders[3].to_s)
  end
end
