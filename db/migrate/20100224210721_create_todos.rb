class CreateTodos < ActiveRecord::Migration
  def self.up
    create_table :todos do |t|      
      t.integer :parent_id, :null => true
      t.string :type, :limit => 32, :null => false
      t.integer :user_id, :null => false
      t.string :detail, :limit => 512, :null => false      
      t.timestamps
    end
    add_index :todos, :parent_id
    add_index :todos, :type
    add_index :todos, [:parent_id, :type]
  end

  def self.down
    drop_table :todos
  end
end
