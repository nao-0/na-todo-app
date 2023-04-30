class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.references :user, null: false
      t.references :board, null: false
      t.string :title, null: false
      t.text :content, null: false
      t.timestamps
    end
  end
end
