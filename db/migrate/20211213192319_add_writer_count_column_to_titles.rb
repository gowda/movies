class AddWriterCountColumnToTitles < ActiveRecord::Migration[6.1]
  def change
    add_column :titles, :writer_count, :integer
  end
end
