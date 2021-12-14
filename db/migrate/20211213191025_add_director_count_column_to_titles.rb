class AddDirectorCountColumnToTitles < ActiveRecord::Migration[6.1]
  def change
    add_column :titles, :director_count, :integer
  end
end
