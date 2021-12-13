class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :access_token
      t.string :refresh_token
      t.string :name
      t.string :given_name
      t.string :family_name
      t.string :google_id
      t.string :profile_picture_uri
      t.string :locale
      t.boolean :verified_email

      t.timestamps
    end
  end
end
