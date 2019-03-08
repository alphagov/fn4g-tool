class Role < ActiveRecord::Base
  has_many :user_roles, :class_name => 'UserRole'
end
