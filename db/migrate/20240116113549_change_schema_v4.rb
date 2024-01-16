class ChangeSchemaV4 < ActiveRecord::Migration[6.0]
  def change
    create_table :failed_logins, comment: 'Tracks failed login attempts for users' do |t|
      t.datetime :attempted_at

      t.string :ip_address

      t.timestamps null: false
    end

    change_table_comment :sessions, from: 'User sessions for authentication',
                                    to: 'Stores session information for signed-in users'

    add_column :users, :two_factor_enabled, :boolean

    add_column :users, :lockout_end, :datetime

    add_reference :failed_logins, :user, foreign_key: true
  end
end
