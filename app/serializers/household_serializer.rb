class HouseholdSerializer
  include JSONAPI::Serializer

  set_type :household
  attributes :name
end
