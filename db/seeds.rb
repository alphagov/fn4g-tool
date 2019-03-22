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

weight = 0
mapping_weight = {}
['No', 'Not specific', 'Partial', 'Yes'].each do |option|
  mapping_weight[option.downcase] = weight
  weight += 1
end

frameworks = []
['ISO 27001', 'Cyber Essentials', '10 STCS', 'CIS 20', 'PSN'].each do |option|
  frameworks << Framework.create!(name: option)
end


assessmentType = AssessmentType.create!(name: 'Security assessment')


compliance_qs = Questionset.create!(name: 'Compliance frameworks',
                                    assessment_type_id: assessmentType.id)

section = nil
CSV.foreach('./db/MQ_Compliance.csv') do |row|
  if row[2] == '1'
    section = Section.create!(
        name: row[7],
        questionset_id: compliance_qs.id,
        guidance: row[8],
        compliance: true
    )
  end
  if row[2] != '1' && row[0] != 'Index' && !section.nil?
    if row[2] == '2'
      section.description = row[7].to_s
      section.save!
    else
      category = QuestionCategory.find_by_name(row[4])
      if category.nil?
        category = QuestionCategory.create!(name: row[4])
      end
      type = if row[9] == 'Yes/No'
               QuestionType.find_by_name('Binomial')
             elsif row[9] == 'Numeric'
               QuestionType.find_by_name('Numeric')
             else
               QuestionType.find_by_name('Trinomial')
             end
      question = Question.create!(
          question: row[7],
          section_id: section.id,
          question_category_id: category.id,
          question_type_id: type.id,
          index: (row[0].to_i * 10),
          reference: row[3],
          mcss_reference: row[6],
          guidance: row[8]
      )

      [
          ['PSN Compliant','PSN'],
          ['Cyber Essentials Certified','Cyber Essentials'],
          ['ISO 27001 Compliant','ISO 27001']
      ].each do |framework_map|
        if framework_map[0].downcase == row[7].to_s.strip.downcase
          framework = Framework.find_by_name(framework_map[1])
          FrameworkCompliance.create!(question_id: question.id, framework_id: framework.id)
        end
      end
    end
  end
end

mapping_questionsets = {}
['Identify', 'Protect', 'Detect', 'Respond', 'Recover'].each do |option|
  mapping_questionsets[option] = Questionset.create!(name: option,
                                                     assessment_type_id: assessmentType.id)
end

section = nil
CSV.foreach('./db/MQ_Mapping.csv') do |row|
  if row[2] == '1'
    questionset = mapping_questionsets[row[5]]
    section = Section.create!(
        name: row[7],
        questionset_id: questionset.id,
        guidance: row[8]
    )
  end
  if row[2] != '1' && row[0] != 'Index' && !section.nil?
    if row[2] == '2'
      section.description = row[7].to_s
      section.save!
    else
      category = QuestionCategory.find_by_name(row[4])
      if category.nil?
        category = QuestionCategory.create!(name: row[4])
      end
      type = if row[9] == 'Yes/No'
               QuestionType.find_by_name('Binomial')
             elsif row[9] == 'Numeric'
               QuestionType.find_by_name('Numeric')
             else
               QuestionType.find_by_name('Trinomial')
             end
      question = Question.create!(
          question: row[7],
          section_id: section.id,
          question_category_id: category.id,
          question_type_id: type.id,
          index: (row[0].to_i * 10),
          reference: row[3],
          mcss_reference: row[6],
          guidance: row[8]
      )
      column = 10
      frameworks.each do |framework|
        Mapping.create!(
            question_id: question.id,
            framework_id: framework.id,
            name: row[column].strip,
            weight: mapping_weight[row[column].strip.downcase]
        )
        column += 1
      end

    end
  end
end

tools_qs = Questionset.create!(name: 'Automated metrics',
                                   assessment_type_id: assessmentType.id)
section = nil
CSV.foreach('./db/MQ_Tools.csv') do |row|
  if row[2] == '1'
    section = Section.create!(
        name: row[7],
        questionset_id: tools_qs.id,
        guidance: row[8]
    )
  end
  if row[2] != '1' && row[0] != 'Index' && !section.nil?
    if row[2] == '2'
      section.description = row[7].to_s
      section.save!
    else
      category = QuestionCategory.find_by_name(row[4])
      if category.nil?
        category = QuestionCategory.create!(name: row[4])
      end
      type = if row[8] == 'Yes/No'
               QuestionType.find_by_name('Binomial')
             elsif row[8] == 'Numeric'
               QuestionType.find_by_name('Numeric')
             else
               QuestionType.find_by_name('Trinomial')
             end
      section.questions.create!(
          question: row[7],
          section_id: section.id,
          question_category_id: category.id,
          question_type_id: type.id,
          index: (row[0].to_i * 10),
          reference: row[3],
          mcss_reference: row[6],
          guidance: row[8]
      )
    end
  end
end
