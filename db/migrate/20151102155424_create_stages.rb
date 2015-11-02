class CreateStages < ActiveRecord::Migration
  def change
    create_table :stages do |t|
      t.column :name, :string, limit: 100, null: false
      t.column :url, :string, limit: 100, null: false
      t.column :uuid, :string, null: false, limit: 36
      t.column :branch, :string, limit: 100
      t.column :deployed_at, :timestamp
      t.column :comment, :text, limit: 1000
      t.column :state, :string, limit: 50, null: false, default: 'deployed'
      t.column :locked, :boolean, null: false, default: false
    end

    add_index :stages, :name, unique: true
    add_index :stages, :url, unique: true
    add_index :stages, :uuid, unique: true
  end
end
