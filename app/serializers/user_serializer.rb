class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :name, :avatar, :bio
end
