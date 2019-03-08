class User < ActiveRecord::Base
  has_many :formfills, :class_name => 'Formfill'
  has_many :user_roles, :class_name => 'UserRole'
  belongs_to :organisation, :class_name => 'Organisation', :foreign_key => :organisation_id
end
