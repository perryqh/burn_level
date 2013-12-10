module Api
  module V1
    class ExerciseLogsController < ApiController
      respond_to :json, :html
      before_filter :load_routine_log

      def create
        @exercise_log = @routine_log.exercise_logs.build exercise_log_params
        if @exercise_log.save
          render 'api/v1/exercise_logs/show', status: 201
        else
          render json: @exercise_log.errors, status: 422
        end
        #location = !!@routine_log.next_exercise ? new_api_v1_routine_log_exercise_log_url(routine_log_id: @routine_log.id, exercise_id: @routine_log.next_exercise.id) : api_v1_routine_routine_log_url(@routine_log.routine, @routine_log.id)
      end

      private
      def exercise_log_params
        params[:exercise_log].merge!(exercise_id: @routine_log.routine.exercises.find(params[:exercise_log][:exercise_id]).id)
        params.require(:exercise_log).permit(:rep_count, :mass, :mass_units, :distance, :distance_units, :duration, :exercise_id)
      end

      def load_routine_log
        @routine_log = RoutineLog.find(params[:routine_log_id])
        @routine = current_user.routines.find(@routine_log.routine.id)
      end
    end
  end
end