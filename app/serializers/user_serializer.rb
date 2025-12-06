class UserSerializer
  include JSONAPI::Serializer

  attributes :id, :email, :created_at

  attribute :profile do |user|
    ProfileSerializer.new(user.profile).serializable_hash[:data][:attributes] if user.profile
  end
end
