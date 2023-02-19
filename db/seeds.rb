# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
COUNT_OF_USERS = 10
COUNT_COMMENTS_FOR_QUESTION = 10
COUNT_COMMENTS_FOR_ANSWER = 10

def create_random_question_by_user(user)
  title = Faker::Lorem.question
  body = Faker::Lorem.paragraph(sentence_count: 2, random_sentences_to_add: 4)
  user.questions.create!(title: title, body: body)
end

def create_random_answer_by_user_for_question(user, question)
  body = Faker::Lorem.paragraph(sentence_count: 3, random_sentences_to_add: 7)
  question.answers.create!(body: body, author: user)
end

def create_random_comment_by_random_user_for_commeteable(commenteable)
  comment_body = Faker::Lorem.paragraph(sentence_count: 4)
  commenteable.comments.create!(body: comment_body, author: random_user)
end

def users_other_than(user)
  User.where.not(id: user.id)
end

def random_user
  offset = rand(User.count)
  User.offset(offset).first
end

# Create admin
admin = User.create(email: 'admin@mail.ru', password: '123456789', password_confirmation: '123456789', admin: true)

# Create users
COUNT_OF_USERS.times do |i|
  User.create(email: "user#{i}@mail.ru", password: '123456789', password_confirmation: '123456789')
end

# Create questions and answers (and comments for )
User.all.each do |user|
  question = create_random_question_by_user(user)
  COUNT_COMMENTS_FOR_QUESTION.times { create_random_comment_by_random_user_for_commeteable(question) }

  users_other_than(user).each { |u| create_random_answer_by_user_for_question(u, question) }

  question.answers.each do |answer|
    COUNT_COMMENTS_FOR_ANSWER.times { create_random_comment_by_random_user_for_commeteable(answer) }
  end
end



