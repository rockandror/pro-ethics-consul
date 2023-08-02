class CreatePollChoices < ActiveRecord::Migration[5.2]
  def change
    create_table :poll_choices do |t|
      t.references :answer, foreign_key: { to_table: :poll_answers }
      t.references :question_answer, foreign_key: { to_table: :poll_question_answers }

      t.timestamps
    end
  end
end
