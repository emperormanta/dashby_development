include ApplicationHelper
module Types
  class QueryType < Types::BaseObject
    field :hit_rate, Types::HitRateType, null: true do
      argument :tokens, [String], required: true
      argument :month, Int, required: true
    end
    def hit_rate(tokens:, month:)
      {
        tokens: tokens,
        month: month
      }
    end

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
      MasterTarget.find_by(user_id: user.id,active: true)
    end
    
    field :get_targets, [Types::TargetType], null: true
    def get_targets
      MasterTarget.all.where(active: true)
    end

    field :get_nilai_proposal_setahun, Types::ReportMonthType, null: true do
      argument :user_token, String, required: false
    end
    def get_nilai_proposal_setahun(user_token:)
      proposal = GraphqlApi.customer(QueryModules::QueryCustomer.get_proposal_yearly(user_token))
      data = proposal["data"]["user"]["proposalYearly"]
      return get_proposal(data, user_token)
    end

    field :get_nilai_sf_setahun, Types::ReportMonthType, null: true do
      argument :user_token, String, required: false
    end
    def get_nilai_sf_setahun(user_token:)
      sf = GraphqlApi.customer(QueryModules::QueryCustomer.get_mou_yearly(user_token))
      data = sf["data"]["user"]["mousWithComponentYearly"]
      return get_sf(data, user_token)
    end

    field :get_hit_rate, [Types::HitRateType], null: false do
      argument :token, String, required: true
      argument :month, Int, required: true
      argument :year, Int, required: true
    end
    def get_hit_rate(token:, month:, year:)
      user = User.find_by(authentication_token: token)
      month = sprintf('%02d', month)
      start_date = "#{year}-#{month}-01"
      end_date = Date.civil(year.to_i, month.to_i, -1)
      end_date = end_date.strftime("%Y-%m-%d")
      active_achievement = ActiveAchievementMonthly.where("user_id = #{user.id} AND created_at >= '#{start_date}' AND created_at <= '#{end_date}'")
    end

    field :get_acquisition, [Types::GetAcquisitionType], null: false do
      argument :token, String, required: true
      argument :month, Int, required: true
      argument :year, Int, required: true
    end

    def get_acquisition(token:,month:,year:)
      user = User.find_by(authentication_token: token)
      # datetime = DateTime.now
      # day = datetime.strftime("%d")
      # month = datetime.strftime("%m")
      # year = datetime.strftime("%Y")
      
      month = sprintf('%02d', month)
      start_date = "#{year}-#{month}-01"
      end_date = Date.civil(year.to_i, month.to_i, -1)
      end_date = end_date.strftime("%Y-%m-%d")
      Acquisition.where("user_id = #{user.id} AND first_payment_date >= '#{start_date}' AND first_payment_date <= '#{end_date}'")
    end

    field :get_achievement, Types::AchievementType, null: true do
      argument :user_token, String, required: false
    end

    def get_achievement(user_token:)
      result = {}
      user = User.find_by(authentication_token: user_token)
      if user.present?
        target =  MasterTarget.find_by(user_id: user.id)
        current_month = Time.now.strftime("%m")
        result[:target_achievement] = target.present? ? target.periodic : 0
        result[:current_achievement] = total_net_periodic_fee(user_token, current_month.to_i)
        result[:percentage] = ((result[:current_achievement].to_f / result[:target_achievement].to_f) * 100).round
        result[:last_month_achievement] = current_month.to_i > 1 ? total_net_periodic_fee(user_token, current_month.to_i - 1) : 0
      end
      return result
    end

    private
    def get_proposal(object, user_token)
      begin
        result = {}
        user = User.find_by(authentication_token: user_token)
        target = MasterTarget.find_by(user_id: user.id)
        if user.present? && target.present?
          result[:user] = user.email
          result[:proposal] = []
          result[:target_proposal] = target.nominal
          month = 0
          12.times do
            current_month_proposal = []
            proposal_price = 0
            data = {}
            month += 1
            current_month_name = Date::MONTHNAMES[month].to_date.strftime('%b').upcase
            object.map { |data| data["createdAt"].to_date.month == month ? current_month_proposal.push(data) : nil }
            current_month_proposal.map {|data| data["product"].map{ |periodic| proposal_price += periodic["periodicFee"]["finalPrice"]}}
            data[:name] = current_month_name
            data[:total] = proposal_price
            result[:proposal].push(data)
          end
          return result
        end
      rescue => e
        raise GraphQL::ExecutionError, "User atau Target tidak ditemukan"
      end
    end
    def get_sf(object, user_token)
      begin
        result = {}
        user = User.find_by(authentication_token: user_token)
        target = MasterTarget.find_by(user_id: user.id)
        if user.present? && target.present?
          result[:user] = user.email
          result[:sf] = []
          result[:target_sf] = target.periodic
          month = 0
          12.times do
            current_month_proposal = []
            proposal_price = 0
            data = {}
            month += 1
            current_month_name = Date::MONTHNAMES[month].to_date.strftime('%b').upcase
            object.map { |data| data["createdAt"].to_date.month == month ? current_month_proposal.push(data) : nil }
            current_month_proposal.map {|data| data["mouProducts"].map{ |periodic| proposal_price += periodic["periodicFee"]["finalPrice"]}}
            data[:name] = current_month_name
            data[:total] = proposal_price
            result[:sf].push(data)
          end
          return result
        end
      rescue => e
        raise GraphQL::ExecutionError, "User atau Target tidak ditemukan"
      end
    end
  end
end
