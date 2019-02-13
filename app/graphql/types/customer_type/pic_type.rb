module Types
  class Types::CustomerType::PicType < Types::BaseObject
    field :email, String, null: true
    field :full_name, String, null: true

    def full_name
      object["fullName"]
    end
  end
end