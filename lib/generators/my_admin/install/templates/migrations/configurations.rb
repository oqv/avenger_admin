class CreateMyAdminConfigurations < ActiveRecord::Migration

  def self.up
    create_table :my_admin_configurations do |t|
      
      t.string :key
      t.string :name
      t.string :field_type
      t.string :hint
      t.text :value
      t.boolean :required

      t.timestamps
      
    end
  end

  def self.down
    drop_table :my_admin_configurations
  end

end
