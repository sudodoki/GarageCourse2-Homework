class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :scenic_name
      t.string :bio
      t.timestamps
    end
  end
end

