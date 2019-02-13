module Types
  class Types::NilaiSfType < Types::BaseObject
    field :sf , [Types::CustomerType::SfType], null: false
    field :nilai_proposal, Int, null: false

    def sf
      object["mousWithComponent"]
    end

    def nilai_proposal
      total_nilai_sf = object["mousWithComponent"].map{|x,y| (x["mouProducts"].map {|x,y|x["periodicFee"]["finalPrice"]})}
      total_nilai_sf.flatten.inject(:+)
    end
    
  end
end