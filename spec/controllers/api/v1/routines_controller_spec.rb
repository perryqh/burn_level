require 'spec_helper'

describe Api::V1::RoutinesController do
  render_views
  login_user :user
  let(:routine) { create(:routine).tap { |r| @current_user.routines << r } }
  let(:routine_attributes) { attributes_for(:routine).merge(user_id: @current_user.id) }

  describe 'GET index' do
    before do
      get :index, format: :json
    end

    specify { response.should be_success }
  end

  describe 'POST create' do
    describe 'success' do
      before do
        post :create, routine: routine_attributes, format: :json
        @result = JSON.parse(response.body)['routine']
      end

      specify { response.status.should eq(201) }
      specify { @result['name'].should eq(routine_attributes[:name]) }

      it "should create the routine" do
        User.find(@current_user.id).routines.collect(&:name).should eq([routine_attributes[:name]])
      end
    end

    describe 'success with nested' do
      before do
        post :create, routine: routine_nested_attributes.merge(user_id: @current_user.id), format: :json
        @result = JSON.parse(response.body)['routine']
      end

      specify { response.status.should eq(201) }
      specify { @result['name'].should eq('jimmy') }
      specify { @result['user_id'].should eq(@current_user.id) }

      it "should create routine and exercise" do
        routine = User.find(@current_user.id).routines.first
        routine.exercises.count.should eq(2)
      end
    end

    describe 'failure' do
      before do
        post :create, routine: {}, format: :json
        @result = JSON.parse(response.body)
      end

      specify { response.status.should eq(422) }
      specify { @result['errors']['name'].should eq(["can't be blank"]) }
    end
  end

  describe 'PUT update' do
    describe 'success' do
      before do
        put :update, id: routine.id, routine: {name: 'new-name'}, format: :json
      end

      specify { response.status.should eq(204) }

      it "should update the routine" do
        routine.reload
        routine.name.should eq('new-name')
      end
    end

    describe 'failure' do
      before do
        put :update, id: routine.id, routine: {name: ''}, format: :json
        @result = JSON.parse(response.body)
      end

      specify { response.status.should eq(422) }
      specify { @result['errors']['name'].should eq(["can't be blank"]) }
    end
  end

  describe 'DELETE destroy' do
    before do
      delete :destroy, id: routine.id, format: :json
    end

    it "should delete the routine" do
      Routine.where(id: routine.id).should be_empty
      response.status.should eq(204)
    end
  end
end