class CreateDeploys < ActiveRecord::Migration
  def change
    create_table :deploys do |t|
      t.column :branch, :string, limit: 100, null: false
      t.column :initiated_by, :integer
      t.column :finished_at, :timestamp
      t.column :stage_id, :integer, null: false
    end

    add_index :deploys, [:stage_id, :finished_at], unique: true
  end
end
