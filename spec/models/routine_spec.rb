require 'spec_helper'

describe Routine do
  describe 'relationships' do
    it { should have_many(:exercises) }
    it { should belong_to :user }
    it { should have_many :routine_logs }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe :nested_attributes do
    it "should create routine with exercise" do
      routine = Routine.new(routine_nested_attributes)
      routine.should be_valid
      routine.save!
      routine.reload
      routine.exercises.count.should eq(2)
      routine.exercises.first.name.should eq('one')
      routine.exercises.first.exercise_type.should eq('Time')
    end
  end
end