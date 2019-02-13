module Types
  class Types::CustomerType::SfType < Types::BaseObject
    field :mou_products, [Types::CustomerType::MouProductType], null: true
    field :pic, Types::CustomerType::PicType, null: true

    def mou_products
      object["mouProducts"]
    end
  end
end