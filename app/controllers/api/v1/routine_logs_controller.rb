module Api
  module V1
    class RoutineLogsController < ApiController
      respond_to :json
      before_filter :load_routine

      def create
        respond_with :api, :v1, @routine.routine_logs.create
      end

      def show
        respond_with :api, :v1, @routine.routine_logs.find(params[:id])
      end

      private
      def load_routine
        @routine = current_user.routines.find(params[:routine_id])
      end
    end
  end
end