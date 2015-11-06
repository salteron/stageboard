class CreateLocks < ActiveRecord::Migration
  def change
    create_table :locks do |t|
      t.column :stage_id, :integer, null: false
      t.column :initiated_by, :string, limit: 100, null: false
      t.column :expired_at, :timestamp, null: false
      t.column :branch_whitelist, :string, limit: 150
      t.timestamps null: false
    end

    add_index :locks, :stage_id, unique: true
  end
end
