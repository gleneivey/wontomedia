class AddFlagsToEdges < ActiveRecord::Migration
  def self.up
    add_column :edges, :flags, :integer
  end

  def self.down
    remove_column :edges, :flags
  end
end
