class Region < ActiveRecord::Base
  has_many :organisations, :class_name => 'Organisation'
end
