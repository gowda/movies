class AddFileMd5ToDatasets < ActiveRecord::Migration[6.1]
  def change
    add_column :datasets, :file_md5sum, :string
  end
end
