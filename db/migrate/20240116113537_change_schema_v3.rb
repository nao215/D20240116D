class ChangeSchemaV3 < ActiveRecord::Migration[6.0]
  def change
    create_table :confirmation_tokens, comment: 'Stores tokens for email confirmation' do |t|
      t.string :token

      t.boolean :used

      t.datetime :expires_at

      t.timestamps null: false
    end

    change_table_comment :users, from: 'Registered users of the note application', to: 'Stores user account information'
    change_table_comment :notes, from: 'Notes created by users', to: 'Stores notes created by users'

    add_column :users, :phone_number, :string

    add_column :users, :email_confirmed, :boolean

    add_reference :confirmation_tokens, :user, foreign_key: true
  end
end
