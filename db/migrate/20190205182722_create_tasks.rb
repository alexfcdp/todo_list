# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.integer :position, null: false, default: 0
      t.boolean :done, default: false
      t.datetime :deadline
      t.integer :comments_count, null: false, default: 0
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
