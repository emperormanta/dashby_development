class CreateMasterTargets < ActiveRecord::Migration[5.2]
  def change
    create_table :master_targets do |t|
      t.references :user, index: true, null: false
      t.integer :nominal, :limit => 12, null: false
      t.integer :hit_rate, null: false
      t.integer :one_time, :limit => 12, null: false
      t.integer :periodic, :limit => 12, null: false
      t.integer :nominal_tolerance, :limit => 12, null: false
      t.integer :acquisition, :limit => 12, null: false
      t.boolean :active, null: false
      t.timestamps
    end
  end
end
