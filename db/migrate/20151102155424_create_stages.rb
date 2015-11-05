class CreateStages < ActiveRecord::Migration
  def change
    create_table :stages do |t|
      t.column :url, :string, limit: 100, null: false
      t.column :uuid, :string, null: false, limit: 36
      t.column :comment, :text, limit: 1000
      t.column :locked, :boolean, null: false, default: false
    end

    add_index :stages, :url, unique: true
    add_index :stages, :uuid, unique: true
  end
end
