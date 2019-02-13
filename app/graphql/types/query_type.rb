module Types
  class QueryType < Types::BaseObject
    # field :hit_rate, Types::HitRateType, null: true do
    #   argument :tokens, [String], required: true
    #   argument :month, Int, required: true
    # end
    # def hit_rate(tokens:, month:)
    #   {
    #     tokens: tokens,
    #     month: month
    #   }
    # end

    field :get_proposal_user, [Types::CustomerType::ProposalType], null: true do
      argument :token, String, required: true
      argument :month, Int, required: true
    end
    def get_proposal_user(token:, month:)
      proposal = GraphqlApi.customer(QueryModules::QueryCustomer.get_proposal_user(token, month))
      proposal["data"]["user"]["proposals"]
    end

    field :get_sf_user, [Types::CustomerType::SfType], null: true do
      argument :token, String, required: true
      argument :month, Int, required: true
    end
    def get_sf_user(token:, month:)
      sf = GraphqlApi.customer(QueryModules::QueryCustomer.get_sf_user(token, month))
      sf["data"]["user"]["mousWithComponent"]
    end

    field :get_nilai_proposal, Types::NilaiProposalType, null: true do
      argument :token, String, required: true
      argument :month, Int, required: true
    end
    def get_nilai_proposal(token:, month:)
      proposal = GraphqlApi.customer(QueryModules::QueryCustomer.get_proposal_user(token, month))
      proposal["data"]["user"]
    end

    field :get_nilai_sf, Types::NilaiSfType, null: true do
      argument :token, String, required: true
      argument :month, Int, required: true
    end
    def get_nilai_sf(token:, month:)
      sf = GraphqlApi.customer(QueryModules::QueryCustomer.get_sf_user(token, month))
      sf["data"]["user"]
    end

    field :get_target, Types::TargetType, null: true do 
      argument :user_token, String, required: false
    end
    def get_target(user_token:)
      user = User.find_by(authentication_token: user_token)
      MasterTarget.find_by(user_id: user.id)
    end
    
    field :get_targets, [Types::TargetType], null: true
    def get_targets
      MasterTarget.all
    end

    field :get_nilai_proposal_setahun, Types::ReportMonthType, null: true do
      argument :user_token, String, required: false
    end
    def get_nilai_proposal_setahun(user_token:)
      proposal = GraphqlApi.customer(QueryModules::QueryCustomer.test_get_proposal(user_token))
      data = proposal["data"]["user"]["proposalTest"]
      return get_current_month_proposal(data, user_token)
    end

    private
    def get_current_month_proposal(object, user_token)
      result = {}
      result[:user] = User.find_by(authentication_token: user_token).email
      result[:proposal] = []
      month = 0
      12.times do
        current_month_proposal = []
        proposal_price = 0
        data = {}
        month += 1
        current_month_name = Date::MONTHNAMES[month].to_date.strftime('%b').upcase
        object.map { |data| data["createdAt"].to_date.month == month ? current_month_proposal.push(data) : nil }
        current_month_proposal.map {|data| data["product"].map{ |periodic| proposal_price += periodic["periodicFee"]["finalPrice"]}}
        data[:month] = current_month_name
        data[:total] = proposal_price
        result[:proposal].push(data)
      end
      return result
    end
  end
end
