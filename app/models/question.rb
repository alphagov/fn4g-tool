class Question < ActiveRecord::Base
  belongs_to :question_category, :class_name => 'QuestionCategory', :foreign_key => :question_category_id
  belongs_to :question_type, :class_name => 'QuestionType', :foreign_key => :question_type_id
  belongs_to :section, :class_name => 'Section', :foreign_key => :section_id
  has_many :answers, :class_name => 'Answer'
  has_many :mappings, :class_name => 'Mapping'
  has_many :frameworks, :class_name => 'Framework'
  has_many :framework_compliances, :class_name => 'FrameworkCompliance'
end
