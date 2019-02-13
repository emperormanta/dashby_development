module Types
  class Types::CustomerType::PeriodicFeeType < Types::BaseObject
    field :component_name, String, null: true
    field :quantity, Int, null:true
    field :unit, Int, null: true
    field :final_price, Int, null: true
    field :component_type, String, null: true
    field :charge_period, String, null: true

    def component_name
      object["componentName"]
    end

    def final_price
      object["finalPrice"]
    end

    def component_type
      object["componentType"]
    end

    def charge_period
      object["chargePeriod"]
    end
  end
end