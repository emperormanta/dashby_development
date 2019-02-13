module Types
  class Types::CustomerType::ProjectType < Types::BaseObject
    field :id, Int, null: true
    field :project_name, String, null: true
    field :pic, Types::CustomerType::PicType, null: true

    def project_name
      object["projectName"]
    end
  end
end