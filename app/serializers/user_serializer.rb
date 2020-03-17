class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :password_digest, :name, :bio, :avatar, :created_at, :updated_at
end
