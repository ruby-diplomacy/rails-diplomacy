class AddSeasonAndYearToState < ActiveRecord::Migration
  def change
    change_table :states do |t|
      t.string :season, default: 'Spring'
      t.integer :year, limit: 2, default: 1901
    end
  end
end
