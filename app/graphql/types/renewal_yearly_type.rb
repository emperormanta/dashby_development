class Types::RenewalYearlyType < GraphQL::Schema::Object

  field :name, String, null: true
  field :total, Types::RenewalMonthlyType, null: true
  
end