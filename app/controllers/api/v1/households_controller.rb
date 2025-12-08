module Api
  module V1
    class HouseholdsController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_household, only: %i[show update destroy]

      def index
        households = policy_scope(Household).includes(:user, :household_members)
        data = HouseholdSerializer.new(households).serializable_hash[:data].map do |d|
          d[:attributes].merge(id: d[:id].to_i)
        end
        render_json(data: data, message: "Households retrieved")
      end

      def show
        authorize @household
        data = HouseholdSerializer.new(@household).serializable_hash[:data][:attributes].merge(id: @household.id)
        render_json(data: data, message: "Household retrieved")
      end

      def create
        household = Household.new(household_params.merge(user: current_user))
        authorize household

        if household.save
          data = HouseholdSerializer.new(household).serializable_hash[:data][:attributes].merge(id: household.id)
          render_json(data: data, message: "Household created", status: :created)
        else
          render_json(data: nil, message: "Validation failed", errors: household.errors.full_messages,
                      status: :unprocessable_content)
        end
      end

      def update
        authorize @household

        if @household.update(household_params)
          data = HouseholdSerializer.new(@household).serializable_hash[:data][:attributes].merge(id: @household.id)
          render_json(data: data, message: "Household updated")
        else
          render_json(data: nil, message: "Validation failed", errors: @household.errors.full_messages,
                      status: :unprocessable_content)
        end
      end

      def destroy
        authorize @household
        @household.destroy
        render_json(data: nil, message: "Household deleted")
      end

      private

      def set_household
        @household = current_user.households.find_by(id: params[:id])
        return if @household

        render_json(data: nil, message: "Household not found", errors: ["not_found"], status: :not_found)
      end

      def household_params
        params.require(:household).permit(:name)
      end
    end
  end
end
