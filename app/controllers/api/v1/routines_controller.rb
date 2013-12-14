module Api
  module V1
    class RoutinesController < ApiController
      respond_to :json
      before_filter :load_routine, only: [:update, :destroy, :show]

      def index
        respond_with :api, :v1, current_user.routines
      end

      def create
        respond_with :api, :v1, Routine.create(routine_params)
      end

      def update
        respond_with :api, :v1, Routine.update(params[:id], routine_params)
      end

      def destroy
        respond_with :api, :v1, @routine.destroy
      end

      private
      def load_routine
        @routine = current_user.routines.find(params[:id])
      end

      def routine_params
        params[:routine].merge!(user_id: current_user.id.to_s)
        params.require(:routine).permit(:name, :user_id, exercises_attributes: [:id, :name, :_destroy, :exercise_type, :order_num, :duration])
      end
    end
  end
end