class RemoveAnswerIdFromPollAnswers < ActiveRecord::Migration[5.2]
  def change
    remove_column :poll_answers, :answer_id, :bigint
  end
end
