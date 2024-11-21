class AddHashIdToUrls < ActiveRecord::Migration[8.0]
  def change
    add_column :urls, :hash_id, :string
  end
end
