# spec/models/user_spec.rb

require "rails_helper"

RSpec.describe User, type: :model do
  # Test factory works
  describe "factory" do
    it "has a valid factory" do
      expect(build(:user)).to be_valid
    end
  end

  # Associations
  describe "associations" do
    it { is_expected.to have_one(:profile).dependent(:destroy) }

    it "destroys profile when user is destroyed" do
      user = create(:user)
      create(:profile, user: user)
      profile_id = user.profile.id

      user.destroy

      expect(Profile.find_by(id: profile_id)).to be_nil
    end
  end

  # Nested attributes
  describe "nested attributes" do
    it { is_expected.to accept_nested_attributes_for(:profile) }

    it "creates user with profile in one call" do
      user = described_class.create!(
        email: "test@example.com",
        password: "password123",
        profile_attributes: { name: "John Doe" }
      )

      expect(user.profile).to be_present
      expect(user.profile.name).to eq("John Doe")
    end

    it "updates profile through nested attributes" do
      user = create(:user)
      create(:profile, user: user, name: "Old Name")

      user.update!(profile_attributes: { id: user.profile.id, name: "New Name" })

      expect(user.profile.name).to eq("New Name")
    end
  end

  # Delegations
  describe "delegations" do
    it "delegates name to profile" do
      user = create(:user)
      create(:profile, user: user, name: "Jane Smith")

      expect(user.name).to eq("Jane Smith")
    end

    it "returns nil for name when profile is missing" do
      user = create(:user)
      expect(user.name).to be_nil
    end

    it "raises error when trying to create profile with nil name" do
      user = create(:user)

      expect do
        create(:profile, user: user, name: nil)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  # Validations
  describe "validations" do
    subject { build(:user) }

    # Devise validations
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
  end

  # Devise modules
  describe "devise modules" do
    it "includes database_authenticatable" do
      expect(described_class.devise_modules).to include(:database_authenticatable)
    end

    it "includes validatable" do
      expect(described_class.devise_modules).to include(:validatable)
    end

    it "does not include recoverable" do
      expect(described_class.devise_modules).not_to include(:recoverable)
    end

    it "does not include rememberable" do
      expect(described_class.devise_modules).not_to include(:rememberable)
    end
  end

  # Authentication (API-focused)
  describe "authentication" do
    let(:user) { create(:user, password: "password123") }

    it "encrypts password" do
      expect(user.encrypted_password).to be_present
      expect(user.encrypted_password).not_to eq("password123")
    end

    it "authenticates with valid password" do
      expect(user.valid_password?("password123")).to be true
    end

    it "does not authenticate with invalid password" do
      expect(user.valid_password?("wrongpassword")).to be false
    end

    it "requires password on create" do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it "requires password to be at least 6 characters" do
      user = build(:user, password: "12345")
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end
  end

  # Email validation
  describe "email validation" do
    it "accepts valid email addresses" do
      valid_emails = %w[
        user@example.com
        USER@foo.COM
        A_US-ER@foo.bar.org
        first.last@foo.jp
      ]

      valid_emails.each do |email|
        user = build(:user, email: email)
        expect(user).to be_valid, "#{email} should be valid"
      end
    end

    it "rejects invalid email addresses" do
      invalid_emails = %w[
        user@example,com
        user_at_foo.org
        user.name@example.
        foo@bar_baz.com
      ]

      invalid_emails.each do |email|
        user = build(:user, email: email)
        expect(user).not_to be_valid, "#{email} should be invalid"
      end
    end

    it "rejects duplicate email addresses" do
      create(:user, email: "duplicate@example.com")
      user = build(:user, email: "duplicate@example.com")

      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it "rejects duplicate email addresses regardless of case" do
      create(:user, email: "user@example.com")
      user = build(:user, email: "USER@EXAMPLE.COM")

      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it "saves email in lowercase" do
      user = create(:user, email: "USER@EXAMPLE.COM")
      expect(user.reload.email).to eq("user@example.com")
    end
  end

  # Timestamps
  describe "timestamps" do
    it "sets created_at on create" do
      user = create(:user)
      expect(user.created_at).to be_present
    end

    it "sets updated_at on create" do
      user = create(:user)
      expect(user.updated_at).to be_present
    end

    it "updates updated_at on update" do
      user = create(:user)
      original_updated_at = user.updated_at

      sleep 1
      user.email = "something@something.com"
      user.save!

      expect(user.updated_at).to be > original_updated_at
    end
  end

  # Database constraints
  describe "database constraints" do
    it "enforces email uniqueness at database level" do
      create(:user, email: "test@example.com")

      expect do
        described_class.create!(email: "test@example.com", password: "password123")
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "requires email to be present" do
      user = build(:user, email: "")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "requires email to be present (nil)" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end
  end

  # API-specific behavior
  describe "API usage" do
    it "can be created without profile" do
      user = create(:user)
      expect(user).to be_valid
      expect(user.profile).to be_nil
    end

    it "can have profile added later" do
      user = create(:user)
      profile = create(:profile, user: user, name: "Added Later")

      expect(user.reload.profile).to eq(profile)
      expect(user.name).to eq("Added Later")
    end

    it "allows password updates" do
      user = create(:user, password: "oldpassword", password_confirmation: "oldpassword")
      user.update!(password: "newpassword123", password_confirmation: "newpassword123")

      expect(user.valid_password?("newpassword123")).to be true
      expect(user.valid_password?("oldpassword")).to be false
    end
  end
end
