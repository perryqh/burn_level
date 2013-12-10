module Api
  module V1
    class RoutinesController < ApiController
      respond_to :json
      before_filter :load_routine, only: [:update, :destroy, :show]

      def index
        @routines = current_user.routines
        respond_with @routines
      end

      def create
        @routine = Routine.new routine_params
        if @routine.save
          render 'api/v1/routines/show', status: 201
        else
          render json: @routine.errors, status: 422
        end
      end

      def update
        if @routine.update_attributes(routine_params)
          render 'api/v1/routines/show', status: 200
        else
          render json: @routine.errors, status: 422
        end
      end

      def destroy
        @routine.destroy
        respond_with(@routine, location: api_v1_routines_url)
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