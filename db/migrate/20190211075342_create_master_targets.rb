class CreateMasterTargets < ActiveRecord::Migration[5.2]
  def change
    create_table :master_targets do |t|
      t.references :user, index: true, null: false
      t.integer :nominal, null: false
      t.integer :hit_rate, null: false
      t.integer :one_time, null: false
      t.integer :periodic, null: false
      t.integer :nominal_tolerance, null: false
      t.integer :acquisition, null: false
      t.boolean :active, null: false
      t.timestamps
    end
  end
end
