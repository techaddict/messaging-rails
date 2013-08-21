class AddNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :phone, :integer
    add_column :users, :houseno, :string
    add_column :users, :addline1, :string
    add_column :users, :addline2, :string
  end
end
