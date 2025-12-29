require "rails_helper"

RSpec.describe Household, type: :model do
  describe "factory" do
    it "has a valid factory" do
      expect(create(:household)).to be_valid
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:household_members).dependent(:destroy) }
    it { is_expected.to have_many(:medical_records).dependent(:destroy) }
    it { is_expected.to have_many(:invitations).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:user_id) }
  end

  describe "callbacks" do
    describe "#create_admin_member" do
      it "automatically creates admin member on household creation" do
        user = create(:user, :with_profile)
        household = Household.create!(user: user, name: "Test Family")

        expect(household.household_members.count).to eq(1)
        
        admin_member = household.household_members.first
        expect(admin_member.user).to eq(user)
        expect(admin_member.role).to eq("admin")
        expect(admin_member.relationship).to eq("self")
      end

      it "uses user's name from profile" do
        user = create(:user)
        create(:profile, user: user, name: "John Smith")
        household = Household.create!(user: user, name: "Smith Family")

        expect(household.household_members.first.name).to eq("John Smith")
      end

      it "falls back to email prefix when no profile name" do
        user = create(:user, email: "jane.doe@example.com")
        household = Household.create!(user: user, name: "Doe Family")

        expect(household.household_members.first.name).to eq("jane.doe")
      end
    end
  end
end
