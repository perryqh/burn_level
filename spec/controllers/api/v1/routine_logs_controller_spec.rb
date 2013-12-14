require 'spec_helper'

describe Api::V1::RoutineLogsController do
  render_views
  login_user :user
  let(:routine) { Routine.create(routine_nested_attributes.merge(user_id: @current_user.id)) }
  let(:routine_log) { create(:routine_log, routine: routine) }

  describe 'POST create' do
    before do
      post :create, routine_id: routine.id, format: :json
      @result = JSON.parse(response.body)['routine_log']
    end

    specify { response.status.should eq(201) }
  end

  describe 'GET show' do
    describe 'success' do
      before do
        get :show, routine_id: routine.id, id: routine_log.id, format: :json
        @result = JSON.parse(response.body)['routine_log']
      end

      specify { response.status.should eq(200) }
      specify { @result['id'].should eq(routine_log.id) }
    end

    describe 'bad routine id' do
      before do
        get :show, routine_id: 'madeup', id: routine_log.id, format: :json
      end

      specify { response.status.should eq(404) }
    end

    describe 'bad id' do
      before do
        get :show, routine_id: routine.id, id: 'madeup', format: :json
      end

      specify { response.status.should eq(404) }
    end
  end
end