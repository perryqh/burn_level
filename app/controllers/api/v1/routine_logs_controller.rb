module Api
  module V1
    class RoutineLogsController < ApiController
      before_filter :load_routine

      def create
        @routine_log = @routine.routine_logs.build
        if @routine_log.save
          render 'api/v1/routine_logs/show', status: 201
        else
          render json: @routine_log.errors, status: 422
        end
      end

      def show
        @routine_log = @routine.routine_logs.find(params[:id])
        render 'api/v1/routine_logs/show', status: 200
      end

      private
      def load_routine
        @routine = current_user.routines.find(params[:routine_id])
      end
    end
  end
end