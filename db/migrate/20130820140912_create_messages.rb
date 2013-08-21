class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :sender_id
      t.integer :reciever_id
      t.boolean :read
      t.boolean :delete_s, :default => false
      t.boolean :delete_r, :default => false
      t.string :subject
      t.text :content

      t.timestamps
    end
  end
end
