module DiplomacyWorld
  def adjudicator
    if @adjudicator.nil?
      mapreader = Diplomacy::MapReader.new
      mapreader.read_map_file(Rails.root+'lib/graph/maps.yml')
      @adjudicator = Diplomacy::Adjudicator.new(mapreader.maps['Standard'])
    end
    @adjudicator
  end
end

World(DiplomacyWorld)
