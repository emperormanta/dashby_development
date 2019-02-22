class Types::YearlyType < GraphQL::Schema::Object
  # For general yearly data type
  field :name, String, null: true
  field :total, Types::MonthlyType, null: true
end