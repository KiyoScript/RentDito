class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.text :message
      t.references :notifiable, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
