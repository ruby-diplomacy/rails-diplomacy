require 'spec_helper'

describe Order do

  it {should belong_to (:state)}

  it {should belong_to (:power)}

  it {should validate_presence_of(:order).with_message(/order/)}
end
