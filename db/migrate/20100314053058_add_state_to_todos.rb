class AddStateToTodos < ActiveRecord::Migration
  def self.up
    add_column :todos, :state, :string, :limit => 64, :null => false, :default => 'open'
  end

  def self.down
    remove_column :todos, :state
  end
end
