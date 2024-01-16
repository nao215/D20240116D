class ChangeSchemaV1 < ActiveRecord::Migration[6.0]
  def change
    create_table :users, comment: 'Registered users of the note application' do |t|
      t.string :email

      t.string :password_hash

      t.string :username

      t.timestamps null: false
    end

    create_table :notes, comment: 'Notes created by users' do |t|
      t.string :title

      t.text :content

      t.timestamps null: false
    end

    add_reference :notes, :user, foreign_key: true
  end
end
