require 'spec_helper'

describe RoutineLog do
  describe 'relationships' do
    it { should have_many(:exercise_logs) }
    it { should belong_to(:routine) }
  end

  let(:routine) { Routine.create(routine_nested_attributes) }
  let(:routine_log) { create(:routine_log, routine: routine) }

  describe :next_exercise do
    it "should return next exercise" do
      routine_log.next_exercise.should eq(routine.exercises.first)
      routine_log.exercise_logs.create(first_exercise_log_attributes(routine.exercises.first.id))
      routine_log.next_exercise.should eq(routine.exercises.last)
      routine_log.exercise_logs.create(last_exercise_log_attributes(routine.exercises.last.id))
      routine_log.next_exercise.should be_nil
    end
  end
end