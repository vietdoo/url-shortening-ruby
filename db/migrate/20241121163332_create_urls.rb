class CreateUrls < ActiveRecord::Migration[8.0]
  def change
    create_table :urls do |t|
      t.string :original_url
      t.string :short_code
      t.datetime :time_init
      t.datetime :time_expired

      t.timestamps
    end
  end
end
