module Types
  class Types::CustomerType::ProposalType < Types::BaseObject
    field :project, Types::CustomerType::ProjectType, null: true
    field :product, [Types::CustomerType::ProductType], null: true
    field :customer, Types::CustomerType::CustomersType, null: true
  end
end