class Poll::Choice < ApplicationRecord
  belongs_to :answer, class_name: "Poll::Answer"
  belongs_to :question_answer, class_name: "Poll::Question::Answer"
end
