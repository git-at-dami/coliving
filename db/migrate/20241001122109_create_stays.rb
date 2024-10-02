# frozen_string_literal: true

class CreateStays < ActiveRecord::Migration[7.1]
  def change
    create_table :stays do |t|
      t.date :start_date
      t.date :end_date
      t.references :studio, null: false, foreign_key: true

      t.timestamps
    end
  end
end
