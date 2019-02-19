class CreateAcquisitions < ActiveRecord::Migration[5.2]
  def change
    create_table :acquisitions do |t|
      t.references :user, index: true
      t.references :master_target, index: true
      t.integer :project_id
      t.integer :mou_id
      t.datetime :proposal_created_date
      t.datetime :first_payment_date
      t.integer :spent_time_day
      t.timestamps
    end
  end
end
