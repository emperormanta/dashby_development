class Types::ReportMonthDetailType < GraphQL::Schema::Object
  field :name, String, null: true
  field :total, Int, null: true
end