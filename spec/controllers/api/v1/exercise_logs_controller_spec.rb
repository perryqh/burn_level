require 'spec_helper'

describe Api::V1::ExerciseLogsController do
  render_views
  login_user :user
  let(:routine) { Routine.create(routine_nested_attributes.merge(user_id: @current_user.id)) }
  let(:routine_log) { create(:routine_log, routine: routine) }

  describe 'POST create' do
    describe 'success' do
      before do
        routine_log.exercise_logs.should be_empty
        post :create, routine_log_id: routine_log.id, exercise_log: first_exercise_log_attributes(routine.exercises.first.id), format: :json
        @result = JSON.parse(response.body)
      end

      specify { routine_log.reload; routine_log.exercise_logs.count.should eq(1) }
      specify { response.status.should eq(201) }
      specify { @result['routine_log_id'].should eq(routine_log.id) }
    end
  end

  describe 'failure' do
    let(:invalid_params) { first_exercise_log_attributes(routine.exercises.first.id).tap { |atts| atts.delete(:duration) } }

    before do
      post :create, routine_log_id: routine_log.id, exercise_log: invalid_params, format: :json
      @result = JSON.parse(response.body)
    end

    specify { response.status.should eq(422) }
    specify { @result['duration'].should eq(["can't be blank"]) }
  end
end