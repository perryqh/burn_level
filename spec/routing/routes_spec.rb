require 'spec_helper'

describe 'Routes' do
  describe :welcome do
    specify { {get: '/'}.should route_to(controller: 'welcome', action: 'index') }
  end

  describe :oauths do
    specify { {get: '/auth/twitter/callback'}.should route_to(controller: 'sessions', action: 'create', provider: 'twitter') }
    specify { {get: '/signout'}.should route_to(controller: 'sessions', action: 'destroy') }
  end

  describe 'Routines' do
    specify { {post: '/api/v1/routines'}.should route_to(controller: 'api/v1/routines', action: 'create', format: :json) }
    specify { {delete: '/api/v1/routines/3'}.should route_to(controller: 'api/v1/routines', action: 'destroy', id: '3', format: :json) }
    specify { {get: '/api/v1/routines/4'}.should route_to(controller: 'api/v1/routines', action: 'show', id: '4', format: :json) }
    specify { {get: '/api/v1/routines/4/edit'}.should route_to(controller: 'api/v1/routines', action: 'edit', id: '4', format: :json) }
    specify { {get: '/api/v1/routines/new'}.should route_to(controller: 'api/v1/routines', action: 'new', format: :json) }
    specify { {put: '/api/v1/routines/5'}.should route_to(controller: 'api/v1/routines', action: 'update', id: '5', format: :json) }
  end

  describe :routine_logs do
    specify { {post: '/api/v1/routines/23/routine_logs'}.should route_to(controller: 'api/v1/routine_logs', action: 'create', routine_id: '23', format: :json) }
  end

  describe :exercise_logs do
    specify { {get: '/api/v1/routine_logs/23/exercise_logs/new'}.should route_to(controller: 'api/v1/exercise_logs', action: 'new', routine_log_id: '23', format: :json) }
    specify { {post: '/api/v1/routine_logs/23/exercise_logs'}.should route_to(controller: 'api/v1/exercise_logs', action: 'create', routine_log_id: '23', format: :json) }
  end
end
