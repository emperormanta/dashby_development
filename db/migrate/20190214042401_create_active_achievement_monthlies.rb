class CreateActiveAchievementMonthlies < ActiveRecord::Migration[5.2]
  def change
    create_table :active_achievement_monthlies do |t|
      t.references :user, index: true
      t.references :master_target, index: true
      t.integer :nilai_proposal, :limit => 12
      t.integer :nilai_sf, :limit => 12
      t.integer :hit_rate
      t.integer :one_time, :limit => 12
      t.integer :nilai_renewal, :limit => 12
      t.integer :cross_selling, :limit => 12
      t.timestamps
    end
  end
end
