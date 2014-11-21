class CreatePriorities < ActiveRecord::Migration
  def change
    create_table :priorities do |t|
      t.string :description
      t.integer :position

      t.timestamps
    end
  end
end
