module Types
  class Types::NilaiProposalType < Types::BaseObject
    field :proposal , [Types::CustomerType::ProposalType], null: false
    field :nilai_proposal, Int, null: false

    def proposal
        object["proposals"]
    end

    def nilai_proposal
        total_nilai_proposal = object["proposals"].map{|x,y| (x["product"].map {|x,y|x["periodicFee"]["finalPrice"]})}
        total_nilai_proposal.flatten.inject(:+)
    end
    
  end
end