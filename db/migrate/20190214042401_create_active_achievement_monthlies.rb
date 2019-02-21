class CreateActiveAchievementMonthlies < ActiveRecord::Migration[5.2]
  def change
    create_table :active_achievement_monthlies do |t|
      t.references :user, index: true
      t.references :master_target, index: true
      t.integer :nilai_proposal
      t.integer :nilai_sf
      t.integer :hit_rate
      t.integer :one_time
      t.integer :nilai_renewal
      t.integer :cross_selling
      t.timestamps
    end
  end
end
