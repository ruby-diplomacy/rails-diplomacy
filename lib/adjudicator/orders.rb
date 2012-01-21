require 'logger'

require_relative 'state'
require_relative '../graph/graph'

module Diplomacy 
  UNRESOLVED = 0
  SUCCESS = 1
  FAILURE = 2

  class GenericOrder
    attr_accessor :unit, :unit_area, :dst, :status
    def initialize(unit, unit_area, dst)
      @unit = unit
      @unit_area = unit_area
      @dst = dst
      @status = Diplomacy::UNRESOLVED
    end
    # affected area
    def affected
      dst
    end
    
    def succeed
      @status = SUCCESS
    end
    
    def fail
      @status = FAILURE
    end
    
    def nationality
      unit.nationality
    end
    
    def unresolved?
      @status == UNRESOLVED
    end
    
    def failed?
      @status == FAILURE
    end
    
    def succeeded?
      @status == SUCCESS
    end
    
    def status_readable
      case @status
      when 0
        stat_str = :UNRESOLVED
      when 1
        stat_str = :SUCCESS
      when 2
        stat_str = :FAILURE
      end
      return order.to_s+", "+stat_str.to_s
    end
    
    def prefix
      "#{@unit.type_to_s} #{unit_area.to_s}"
    end
  end

  class Hold < GenericOrder
    def initialize(unit, unit_area)
      super(unit, unit_area, unit_area)
    end
    
    def to_s
      "#{prefix} H"
    end
  end

  class Move < GenericOrder
    def to_s
      "#{prefix} -> #{@dst}"
    end
  end

  class Support < GenericOrder
    attr_accessor :src

    def initialize(unit, unit_area, src, dst)
      super(unit, unit_area, dst)
      @src = src
    end
    
    def to_s
      "#{prefix} S #{@src.to_s} -> #{@dst}"
    end
  end

  class SupportHold < GenericOrder
    def to_s
      "#{prefix} S #{@dst} H"
    end
  end

  class Convoy < GenericOrder
    attr_accessor :src
    def initialize(unit, unit_area, src, dst)
      super(unit, unit_area, dst)
      @src = src
    end
    
    def to_s
      "#{prefix} C #{@src} -> #{@dst}"
    end
  end
  
  class OrderCollection
    attr_accessor :orders
    attr_accessor :moves
    attr_accessor :supports
    attr_accessor :supportholds
    attr_accessor :holds
    attr_accessor :convoys
    
    def initialize(orders)
      @orders = []
      @moves = {}
      @supports = {}
      @holds = {}
      @supportholds = {}
      @convoys = {}
      
      # create wrappers and categorize orders
      orders.each do |order|
        case order
        when Move
          (self.moves[order.dst] ||= Array.new) << order
        when Support
          (self.supports[order.dst] ||= Array.new) << order
        when Hold 
          (self.holds[order.dst] ||= Array.new) << order
        when SupportHold
          (self.supportholds[order.dst] ||= Array.new) << order
        when Convoy
          (self.convoys[order.dst] ||= Array.new) << order
        end
        @orders << order
      end
    end
    
    def each(&blk)
      @orders.each(&blk)
    end
    
    def convoys_for_move(move)
      convoys_to_area = @convoys[move.dst]
      if convoys_to_area.nil?
        return []
      end
      
      return convoys_to_area.find_all { |convoy| convoy.src.eql? move.unit_area }
    end
    
    def moves_by_dst(area, skip_me=false, me=nil)
      moves = @moves[area] || []
      
      if skip_me
        moves.reject {|move| move.equal? me}
      else
        moves
      end
    end
    
    def supports_by_dst(area)
      supports = @supports[area] || []
    end
    
    def moves_by_origin(area)
      @moves.values.each do |moves_for_area|
        # only one at most can exist, so detect is enough
        if not (ret = moves_for_area.detect { |move| move.unit_area.eql? area }).nil?
          return ret
        end
      end
      
      # no compyling move was found, return nil
      return nil
    end
    
    def hold_in(area)
      hold = @holds[area] || []
    end
    
    def supportholds_to(area)
      supports = @supportholds[area] || []
    end
    
    def remove(order)
      # if object not found in @orders, don't try to find it anywhere else
      if @orders.delete(order)
        case order
        when Move
          self.moves[order.dst].delete(order)
        when Support
          self.supports[order.dst].delete(order)
        when Hold 
          self.holds[order.dst].delete(order)
        when SupportHold
          self.supportholds[order.dst].delete(order)
        when Convoy
          self.convoys[order.dst].delete(order)
        end
      end
    end
  end
end
