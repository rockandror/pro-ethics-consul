require_dependency "poll/answer"
require_dependency "poll/question/answer"

section "Creating surveys" do
  name = "Testing all kind of questions"
  poll = Poll.create!(name: name,
                      slug: name.parameterize,
                      starts_at: 7.days.ago,
                      ends_at:   1.year.from_now,
                      geozone_restricted: false)

  author = Administrator.first.user

  Poll::Question.create!(title: "Open answer question (Optional)", poll: poll, kind: :open_answer, mandatory_answer: false, author: author)
  Poll::Question.create!(title: "Open answer question (Required)", poll: poll, kind: :open_answer, mandatory_answer: true, author: author)

  question = Poll::Question.create!(title: "Single choice question (Optional)", poll: poll, kind: :single_choice, mandatory_answer: false, author: author)
  %w[A B C].each_with_index do |option, index|
    Poll::Question::Answer.create!(title: "Single choice question answer #{option}", question: question, given_order: index + 1)
  end
  question = Poll::Question.create!(title: "Single choice question (Required)", poll: poll, kind: :single_choice, mandatory_answer: true, author: author)
  %w[A B C].each_with_index do |option, index|
    Poll::Question::Answer.create!(title: "Single choice question answer #{option}", question: question, given_order: index + 1)
  end

  question = Poll::Question.create!(title: "Multiple choice question (Optional)", poll: poll, kind: :multiple_choice, mandatory_answer: false, author: author)
  %w[X Y W Z].each_with_index do |option, index|
    Poll::Question::Answer.create!(title: "Multiple choice question answer #{option}", question: question, given_order: index + 1)
  end
  question = Poll::Question.create!(title: "Multiple choice question (Required)", poll: poll, kind: :multiple_choice, mandatory_answer: true, author: author)
  %w[X Y W Z].each_with_index do |option, index|
    Poll::Question::Answer.create!(title: "Multiple choice question answer #{option}", question: question, given_order: index + 1)
  end
end
