class AddIndexToMicropost < ActiveRecord::Migration[5.2]
  def change
    add_index :microposts, :created_at
  end
end
