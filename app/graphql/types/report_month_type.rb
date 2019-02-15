class Types::ReportMonthType < GraphQL::Schema::Object
  field :user, String, null: true
  field :proposal, [Types::ReportMonthDetailType], null: true
  field :target_proposal, Int, null: true
  field :sf, [Types::ReportMonthDetailType], null: true
  field :target_sf, Int, null: true
end