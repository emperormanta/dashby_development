module Types
    class Types::GetAcquisitionType < Types::BaseObject
        field :on_target_total, Int, null: false
        field :not_on_target_total, Int, null: false
        
        def on_target_total
            total = 0
            if object.present?
                object.each do |acquisition|
                    master_acquisition = MasterTarget.find_by(id: acquisition["master_target_id"], active: true)
                    master_acquisition_day = master_acquisition.acquisition
                    if acquisition["spent_time_day"] < master_acquisition_day
                        total += 1
                    end
                end
            end
            return total
        end

        def not_on_target_total
            total = 0
            if object.present?
                object.each do |acquisition|
                    master_acquisition = MasterTarget.find_by(id: acquisition["master_target_id"], active: true)
                    master_acquisition_day = master_acquisition.acquisition
                    if acquisition["spent_time_day"] > master_acquisition_day
                        total += 1
                    end
                end
            end
            return total
        end
    end
  end