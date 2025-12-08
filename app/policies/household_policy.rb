class HouseholdPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    owned_or_member?
  end

  def create?
    true
  end

  def update?
    owned?
  end

  def destroy?
    owned?
  end

  class Scope < Scope
    def resolve
      user_households = scope.where(user_id: user.id)
      member_households = scope.joins(:household_members).where(household_members: { user_id: user.id })
      scope.where(id: user_households.select(:id)).or(scope.where(id: member_households.select(:id)))
    end
  end

  private

  def owned?
    record.user_id == user.id
  end

  def owned_or_member?
    owned? || record.household_members.exists?(user_id: user.id)
  end
end
