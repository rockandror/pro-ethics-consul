class CreateGuestInformations < ActiveRecord::Migration[5.2]
  def change
    create_table :guest_informations do |t|
      t.string :email
      t.string :name
      t.belongs_to :user, foreign_key: true, index: { unique: true }

      t.timestamps null: false
    end
  end
end
