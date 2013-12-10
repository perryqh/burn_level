require 'spec_helper'

describe Exercise do
  describe 'relationships' do
    it { belong_to :routine }
  end

  describe 'validations' do
    it { should validate_presence_of :order_num }
    it { should validate_presence_of :name }
    it { should validate_numericality_of(:order_num).is_greater_than_or_equal_to(0) }
    it { should ensure_inclusion_of(:exercise_type).in_array(Exercise::EXERCISE_TYPES) }
  end

  describe 'required helpers' do
    let(:weighted_reps_exercise) { build(:weighted_reps_exercise) }
    let(:reps_exercise) { build(:reps_exercise) }
    let(:time_exercise) { build(:time_exercise) }
    let(:distance_exercise) { build(:distance_exercise) }

    specify { weighted_reps_exercise.reps_required?.should be_true }
    specify { weighted_reps_exercise.mass_required?.should be_true }
    specify { weighted_reps_exercise.time_required?.should be_false }
    specify { weighted_reps_exercise.distance_required?.should be_false }

    specify { reps_exercise.reps_required?.should be_true }
    specify { reps_exercise.mass_required?.should be_false }
    specify { reps_exercise.time_required?.should be_false }
    specify { reps_exercise.distance_required?.should be_false }

    specify { time_exercise.reps_required?.should be_false }
    specify { time_exercise.mass_required?.should be_false }
    specify { time_exercise.time_required?.should be_true }
    specify { time_exercise.distance_required?.should be_false }

    specify { distance_exercise.reps_required?.should be_false }
    specify { distance_exercise.mass_required?.should be_false }
    specify { distance_exercise.time_required?.should be_false }
    specify { distance_exercise.distance_required?.should be_true }
  end
end