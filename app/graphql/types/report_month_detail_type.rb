class Types::ReportMonthDetailType < GraphQL::Schema::Object

  field :month, String, null: true
  field :total, Int, null: true
end