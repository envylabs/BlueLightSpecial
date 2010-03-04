class BlueLightSpecialCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string   :email
      t.string   :encrypted_password,   :limit => 128
      t.string   :salt,                 :limit => 128
      t.string   :remember_token,       :limit => 128
      t.string   :facebook_uid,         :limit => 50
      t.string   :password_reset_token, :limit => 128
      t.timestamps
    end

    add_index :users, :email
    add_index :users, :remember_token
  end

  def self.down
    drop_table :users
  end
end
