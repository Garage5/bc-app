class AddSubdomainToInstances < ActiveRecord::Migration
  # def self.up
  #   add_column :instances, :subdomain, :string, :null => false
  #   add_column :instances, :domain, :string, :null => false
  #   Instance.all.each { |i| i.update_attribute(:subdomain, i.name.underscore) ; i.update_attribute(:domain, 'tbblive.com') }
  # end
  # 
  # def self.down
  #   remove_column :instances, :domain
  #   remove_column :instances, :subdomain
  # end
end
