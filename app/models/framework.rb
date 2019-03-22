class Framework < ActiveRecord::Base
  has_many :mappings, :class_name => 'Mapping'
  has_many :framework_compliances, :class_name => 'FrameworkCompliance'
end
