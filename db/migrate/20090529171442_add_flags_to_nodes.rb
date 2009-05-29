class AddFlagsToNodes < ActiveRecord::Migration
  def self.up
    add_column :nodes, :flags, :integer
  end

  def self.down
    remove_column :nodes, :flags
  end
end
