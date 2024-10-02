# frozen_string_literal: true

class CreateStudios < ActiveRecord::Migration[7.1]
  def change
    create_table :studios do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :studios, :name, unique: true
  end
end
