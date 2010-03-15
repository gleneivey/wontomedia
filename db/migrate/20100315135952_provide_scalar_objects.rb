class ProvideScalarObjects < ActiveRecord::Migration
  def self.up
    add_column :connections, :kind_of_obj, :string    # really an enum
    add_column :connections, :scalar_obj, :string

    # all existing Connections have Items as their objects
    execute 'UPDATE connections SET kind_of_obj="item"'
  end

  def self.down
    remove_column :connections, :kind_of_object
    remove_column :connections, :scalar_obj
  end
end
