class BinomialOption < ActiveRecord::Base
  has_many :answers, :class_name => 'Answer'
end
