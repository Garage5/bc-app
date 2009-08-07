class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login,              :null => false
      t.string :name,               :null => false
      t.string :email,              :null => false
      t.string :crypted_password,   :null => false
      t.string :password_salt,      :null => false
      t.string :persistence_token,  :null => false     
      t.timestamps
    end
    
    # create some users to test with
    User.create(:login => 'dev', :name => 'Developer User', :email => 'dev@thebattlebegins.com', :password => 'pass', :password_confirmation => 'pass')
    User.create(:login => 'bryan', :name => 'Bryan Cinman', :email => 'bryan@thebattlebegins.com', :password => 'pass', :password_confirmation => 'pass')
    User.create(:login => 'matt', :name => 'Matt Johnson', :email => 'matt@thebattlebegins.com', :password => 'pass', :password_confirmation => 'pass')
    User.create(:login => 'james', :name => 'James Au', :email => 'james@thebattlebegins.com', :password => 'pass', :password_confirmation => 'pass')
    User.create(:login => 'victor', :name => 'Victor Au', :email => 'victor@thebattlebegins.com', :password => 'pass', :password_confirmation => 'pass')
    User.create(:login => 'davi', :name => 'Davi Medrade', :email => 'davi@thebattlebegins.com', :password => 'pass', :password_confirmation => 'pass')
  end
  
  def self.down
    drop_table :users
  end
end
