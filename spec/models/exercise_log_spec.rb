require 'spec_helper'

describe ExerciseLog do
  describe 'relationships' do
    it { belong_to :routine_log }
    it { belong_to :exercise }
  end

  describe 'validations' do
    it { should ensure_inclusion_of(:mass_units).in_array(%w{kilograms pounds}) }
    it { should ensure_inclusion_of(:distance_units).in_array(%w{kilometers miles}) }

    context 'weighted-reps' do
      subject { ExerciseLog.new(exercise: build(:weighted_reps_exercise)) }
      let(:valid_exercise_log) { subject.rep_count=3; subject.mass=50; subject.mass_units='pounds'; subject }

      it { should validate_presence_of :rep_count }
      it { should validate_presence_of :mass }
      it { should validate_presence_of :mass_units }
      specify { valid_exercise_log.should be_valid }
    end

    context 'reps' do
      subject { ExerciseLog.new(exercise: build(:reps_exercise)) }
      let(:valid_exercise_log) { subject.rep_count=3; subject }

      it { should validate_presence_of :rep_count }
      specify { valid_exercise_log.should be_valid }
    end

    context 'time' do
      subject { ExerciseLog.new(exercise: build(:time_exercise)) }
      let(:valid_exercise_log) { subject.duration='1:15'; subject }

      it { should validate_presence_of :duration }
      specify { valid_exercise_log.should be_valid }
    end

    context 'distance' do
      subject { ExerciseLog.new(exercise: build(:distance_exercise)) }
      let(:valid_exercise_log) { subject.distance='12'; subject.distance_units='miles'; subject }

      it { should validate_presence_of :distance }
      it { should validate_presence_of :distance_units }
      specify { valid_exercise_log.should be_valid }
    end
  end

  describe :last_recorded_for_exercise do
    before do
      @routine      = Routine.create routine_nested_attributes
      @routine_log  = create(:routine_log, routine: @routine)
      @exercise_log = @routine_log.exercise_logs.create(first_exercise_log_attributes(@routine.exercises.first.id))
    end

    it "should return last recorded exercise log" do
      log = @routine_log.exercise_logs.build(first_exercise_log_attributes(@routine.exercises.first.id))
      log.last_recorded_for_exercise.should eq(@exercise_log)
    end

    it "should return nil if not previously recorded" do
      log = @routine_log.exercise_logs.build(last_exercise_log_attributes(@routine.exercises.last.id))
      log.last_recorded_for_exercise.should be_nil
    end
  end
end