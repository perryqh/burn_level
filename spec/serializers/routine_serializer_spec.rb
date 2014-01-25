require 'spec_helper'

describe RoutineSerializer do
  let(:routine) { build(:routine) }
  subject { JSON.parse(RoutineSerializer.new(routine).to_json) }

  specify { subject['routine'].should have_key('id') }
  specify { subject['routine'].should have_key('name') }
  specify { subject['routine'].should have_key('user_id') }
  specify { subject['routine'].should have_key('exercise_ids') }
  specify { subject.should have_key('exercises') }
end