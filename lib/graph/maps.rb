module Diplomacy
  Standard_map = Map.new
  Standard_map.areas[:StP] = Area.new(:"St. Petersburg", :StP)
  Standard_map.areas[:Mos] = Area.new(:Moscow, :Mos)
  Standard_map.areas[:Sev] = Area.new(:Sevastopol, :Sev)
  Standard_map.areas[:Arm] = Area.new(:Armenia, :Arm)
  Standard_map.areas[:Syr] = Area.new(:Syria, :Syr)
  Standard_map.areas[:Bla] = Area.new(:"Black Sea", :Bla)
  Standard_map.areas[:Ank] = Area.new(:Ankara, :Ank)
  Standard_map.areas[:Smy] = Area.new(:Smyrna, :Smy)
  Standard_map.areas[:Con] = Area.new(:Constantinople, :Con)
  Standard_map.areas[:Eas] = Area.new(:"Eastern Mediterranean Sea", :Eas)
  Standard_map.areas[:Aeg] = Area.new(:"Aegean Sea", :Aeg)
  Standard_map.areas[:Gre] = Area.new(:Greece, :Gre)
  Standard_map.areas[:Bul] = Area.new(:Bulgaria, :Bul)
  Standard_map.areas[:Alb] = Area.new(:Albania, :Alb)
  Standard_map.areas[:Ser] = Area.new(:Serbia, :Ser)
  Standard_map.areas[:Rum] = Area.new(:Rumania, :Rum)
  Standard_map.areas[:Ukr] = Area.new(:Ukraine, :Ukr)
  Standard_map.areas[:Bud] = Area.new(:Budapest, :Bud)
  Standard_map.areas[:Gal] = Area.new(:Galicia, :Gal)
  Standard_map.areas[:War] = Area.new(:Warsaw, :War)
  # TODO finish
  
  Standard_map.add_border(:StP, :Mos, Area::LAND_BORDER)
  Standard_map.add_border(:Sev, :Mos, Area::LAND_BORDER)
  # TODO finish
  
end
