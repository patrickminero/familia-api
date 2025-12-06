class ProfileSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :phone, :timezone, :bio, :notification_preferences, :app_preferences, :created_at, :updated_at
end
