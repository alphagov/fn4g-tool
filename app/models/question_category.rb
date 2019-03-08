class QuestionCategory < ActiveRecord::Base
  has_many :questions, :class_name => 'Question'
end
