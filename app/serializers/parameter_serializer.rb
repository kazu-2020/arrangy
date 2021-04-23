class ParameterSerializer
  include JSONAPI::Serializer

  set_type :parameter
  attributes :taste, :spiciness, :sweetness, :satisfaction

  belongs_to :arrangement
end
