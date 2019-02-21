module Types
    class Types::HitRateType < Types::BaseObject
      field :target_hit_rate, Int, null: false
      field :actual_hit_rate, Int, null: false
      field :total_nominal_proposal, Int, null: false
      field :total_nominal_sf, Int, null: false
  
      def target_hit_rate
        master_target = MasterTarget.find_by(id: object.master_target_id)
        master_target.hit_rate
      end

      def actual_hit_rate
        object.hit_rate
      end

      def total_nominal_proposal
        object.nilai_proposal
      end

      def total_nominal_sf
        object.nilai_sf
      end
      
    end
  end