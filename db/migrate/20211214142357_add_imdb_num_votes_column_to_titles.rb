class AddIMDbNumVotesColumnToTitles < ActiveRecord::Migration[6.1]
  def change
    add_column :titles, :imdb_num_votes, :integer
    add_index :titles, :imdb_num_votes
  end
end
