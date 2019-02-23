class Types::Output::OutputType < GraphQL::Schema::Object
  field :target, Int, null: true
  field :monthly_result, Types::Output::ResultType, null: true
  field :yearly_result, [Types::Output::ResultType], null: true
end