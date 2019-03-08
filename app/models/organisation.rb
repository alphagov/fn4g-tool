class Organisation < ActiveRecord::Base
  has_many :formfills, :class_name => 'Formfill'
  belongs_to :country, :class_name => 'Country', :foreign_key => :country_id
  belongs_to :region, :class_name => 'Region', :foreign_key => :region_id
  has_many :users, :class_name => 'User'
end
