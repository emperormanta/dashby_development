module Types
  class Types::CustomerType::ProductType < Types::BaseObject
    field :name, String, null: true
    field :periodic_fee, Types::CustomerType::PeriodicFeeType, null: true

    def periodic_fee
      object["periodicFee"]
    end
  end
end