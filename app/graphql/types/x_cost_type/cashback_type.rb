module Types
  class Types::XCostType::CashbackType < Types::BaseObject
    field :id ,ID, null: true
    field :cashback_type, String, null: false
    field :cashback_period, Int, null: true
    field :account_number, String, null: true
    field :receiver_name, String, null: true
    field :qty, Int, null: false
    field :price, Int, null: false
    field :mou_id, Int, null: false
    field :mou_product_id, Int, null: false
    field :item_name, String, null: true
    field :project_id, Int, null: false
    field :bank_name, String, null: true
    field :cashback_date, GraphQL::Types::ISO8601DateTime, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end