class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login,              :null => false
      t.string :email,              :null => false
      t.string :crypted_password,   :null => false
      t.string :password_salt,      :null => false
      t.string :persistence_token,  :null => false     
      t.timestamps
    end
    
    # create some users to test with
    User.create(:login => 'dev', :email => 'dev@thebattlebegins.com', :password => 'pass', :password_confirmation => 'pass')
    User.create(:login => 'bryan', :email => 'bryan@thebattlebegins.com', :password => 'pass', :password_confirmation => 'pass')
    User.create(:login => 'matt', :email => 'matt@thebattlebegins.com', :password => 'pass', :password_confirmation => 'pass')
    User.create(:login => 'james', :email => 'james@thebattlebegins.com', :password => 'pass', :password_confirmation => 'pass')
    User.create(:login => 'victor', :email => 'victor@thebattlebegins.com', :password => 'pass', :password_confirmation => 'pass')
  end
  
  def self.down
    drop_table :users
  end
end
