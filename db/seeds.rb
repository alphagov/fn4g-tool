# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

country = Country.create!(name: 'UK')
region = Region.create!(name: 'Greater London')

org = Organisation.create!(
  name: 'Government Digital Service',
  country_id: country.id,
  region_id: region.id
)

org.users.create!(
  name: 'John Doe',
  email: 'john.doe@gov.uk',
  encrypted_password: 'asdbla',
  mobile: '+441234567899'
)

['Binomial', 'Trinomial', 'Percentage', 'Numeric', 'Free Text'].each do |question_type|
  QuestionType.create!(name: question_type)
end

['Yes', 'No', "I don't know"].each do |option|
  TrinomialOption.create!(name: option)
end

['Yes', 'No'].each do |option|
  BinomialOption.create!(name: option)
end

assessmentType = AssessmentType.create!(name: 'Comprehensive security assessment')


questionset1 = Questionset.create!(name: 'Compliance frameworks',
                                   assessment_type_id: assessmentType.id)

section = nil
CSV.foreach('./db/MQ_Compliance.csv') do |row|
  if row[2] == '1'
    section = Section.create!(name: row[5], questionset_id: questionset1.id)
  end
  if row[2] != '1' && row[0] != 'Index' && !section.nil?
    if row[2] == '2'
      section.description = row[5].to_s
      section.save!
    else
      category = QuestionCategory.find_by_name(row[4])
      if category.nil?
        category = QuestionCategory.create!(name: row[4])
      end
      type = if row[6] == 'Yes/No'
               QuestionType.find_by_name('Binomial')
             elsif row[6] == 'Numeric'
               QuestionType.find_by_name('Numeric')
             else
               QuestionType.find_by_name('Trinomial')
             end
      section.questions.create!(
          question: row[5],
          section_id: section.id,
          question_category_id: category.id,
          question_type_id: type.id,
          index: (row[0].to_i * 10),
          reference: row[3]
      )
    end
  end
end


questionset2 = Questionset.create!(name: 'Assessment questions',
                                  assessment_type_id: assessmentType.id)

section = nil
CSV.foreach('./db/MQ_Mapping.csv') do |row|
  if row[2] == '1'
    section = Section.create!(name: row[5], questionset_id: questionset2.id)
  end
  if row[2] != '1' && row[0] != 'Index' && !section.nil?
    if row[2] == '2'
      section.description = row[5].to_s
      section.save!
    else
      category = QuestionCategory.find_by_name(row[4])
      if category.nil?
        category = QuestionCategory.create!(name: row[4])
      end
      type = if row[6] == 'Yes/No'
        QuestionType.find_by_name('Binomial')
      else
        QuestionType.find_by_name('Trinomial')
      end
      section.questions.create!(
        question: row[5],
        section_id: section.id,
        question_category_id: category.id,
        question_type_id: type.id,
        index: (row[0].to_i * 10),
        reference: row[3]
      )
    end
  end
end

questionset3 = Questionset.create!(name: 'Automated metrics',
                                   assessment_type_id: assessmentType.id)
section = nil
CSV.foreach('./db/MQ_Tools.csv') do |row|
  if row[2] == '1'
    section = Section.create!(name: row[5], questionset_id: questionset3.id)
  end
  if row[2] != '1' && row[0] != 'Index' && !section.nil?
    if row[2] == '2'
      section.description = row[5].to_s
      section.save!
    else
      category = QuestionCategory.find_by_name(row[4])
      if category.nil?
        category = QuestionCategory.create!(name: row[4])
      end
      type = if row[6] == 'Yes/No'
               QuestionType.find_by_name('Binomial')
             elsif row[6] == 'Numeric'
               QuestionType.find_by_name('Numeric')
             else
               QuestionType.find_by_name('Trinomial')
             end
      section.questions.create!(
          question: row[5],
          section_id: section.id,
          question_category_id: category.id,
          question_type_id: type.id,
          index: (row[0].to_i * 10),
          reference: row[3]
      )
    end
  end
end
