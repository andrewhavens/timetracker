class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :client
      t.string :description
      t.datetime :start
      t.datetime :end

      t.timestamps
    end
    add_index :tasks, :client_id
  end
end
