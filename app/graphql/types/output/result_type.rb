class Types::Output::ResultType < GraphQL::Schema::Object
  # General usage
  field :name, String, null: true
  field :current, Int, null: true
  field :percentage, Float, null: true
  field :current_month_target, Int, null: true
  field :last_month, Int, null: true

  # Specific for hit rate
  field :total_nominal_proposal, Int, null: true
  field :total_nominal_revenue, Int, null: true

  # Specific for renewal
  field :upcross, Int, null: true

  # Specific for data acquisition
  field :on_target, Int, null: true
  field :off_target, Int, null: true
end