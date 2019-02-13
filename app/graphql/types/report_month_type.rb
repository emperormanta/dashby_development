class Types::ReportMonthType < GraphQL::Schema::Object
  field :user, String, null: true
  field :proposal, [Types::ReportMonthDetailType], null: true
end