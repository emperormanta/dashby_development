module Types
  class Types::XCostType::ServiceDetailType < Types::BaseObject
    field :id ,ID, null: false
    field :mou_id,Int, null: false
    field :mou_product_id,Int, null: false
    field :component_name, String, null: false
    field :site_name, String, null: false
    field :vendor_name, String, null:false
    field :qty, Int, null: false
    field :price, Int, null: false
    field :one_time, Int, null: false
    field :periodic, Int, null: false
    field :recurring_period, Int, null: true
    field :installation_type, String, null: false
    field :component_type, String, null: false
    field :project_id, Int, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end