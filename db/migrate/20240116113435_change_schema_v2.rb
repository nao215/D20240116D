class ChangeSchemaV2 < ActiveRecord::Migration[6.0]
  def change
    create_table :sessions, comment: 'User sessions for authentication' do |t|
      t.datetime :expires_at

      t.string :token

      t.timestamps null: false
    end

    add_reference :sessions, :user, foreign_key: true
  end
end
