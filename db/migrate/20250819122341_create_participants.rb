class CreateParticipants < ActiveRecord::Migration[8.0]
  def change
    create_table :participants do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.boolean :confirmed
      t.text :qr_code
      t.datetime :scanned_at

      t.timestamps
    end
  end
end
