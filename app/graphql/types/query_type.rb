include ApplicationHelper
module Types
  class QueryType < Types::BaseObject
    field :value_of_proposal, Types::Output::OutputType, null: true do
      argument :user_token, String, required: false
    end
    def value_of_proposal(user_token:)
      result = {}
      target = get_target(user_token)
      value_of_proposal = total_periodic_proposal(user_token, [Date.today.month])
      result[:name] = get_month_name(Date.today.month)
      result[:current] = value_of_proposal.present? ? value_of_proposal : 0
      result[:percentage] = value_of_proposal.present? && target.present? ? get_percentage(value_of_proposal, target.nominal) : 0
      result[:last_month] = total_periodic_proposal(user_token, [Date.today.month - 1])
      output = {target: target.nominal, monthly_result: result, yearly_result: total_periodic_proposal(user_token)}
      return output
    end

    # field :value_of_proposal_yearly, Types::Output::OutputType, null: true do
    #   argument :user_token, String, required: false
    # end
    # def value_of_proposal_yearly(user_token:)
    #   output = {target: get_target(user_token).nominal, }
    #   return output
    #   # data = proposal["data"]["user"]["proposalYearly"]
    #   # return get_proposal(data, user_token)
    # end

    field :revenue, Types::Output::OutputType, null: true do
      argument :user_token, String, required: false
    end
    def revenue(user_token:)
      current = total_net_periodic_fee(user_token, [Date.today.month])
      target = get_target(user_token).periodic
      result = {name: get_month_name(Date.today.month),      
                current: current.present? ? current : 0, 
                percentage: get_percentage(current, target),
                last_month: total_net_periodic_fee(user_token, [Date.today.month - 1])}
      output = {target: target, monthly_result: result, yearly_result: total_net_periodic_fee(user_token)}
      return output

      # result = {}
      # user = User.find_by(authentication_token: user_token)
      # if user.present?
      #   target =  MasterTarget.find_by(user_id: user.id)
      #   current_month = Date.today.month
      #   result[:target_achievement] = target.present? ? target.periodic : 0
      #   result[:current_achievement] = total_net_periodic_fee(user_token, current_month)
      #   result[:percentage] = ((result[:current_achievement].to_f / result[:target_achievement].to_f) * 100).round
      #   result[:last_month_achievement] = current_month.to_i > 1 ? total_net_periodic_fee(user_token, current_month.to_i - 1) : 0
      # end
      # return result
    end

    # field :revenue_yearly, Types::Output::OutputType, null: true do 
    #   argument :user_token, String, required: false
    # end
    # def revenue_yearly(user_token:)
    #   output = {target: get_target(user_token).nominal, }
    #   return output
    # end

    field :get_hit_rate, Types::Output::OutputType, null: false do
    # field :get_hit_rate, [Types::HitRateType], null: false do
      argument :user_token, String, required: false
      argument :month, Int, required: false
      argument :year, Int, required: false
    end
    def get_hit_rate(user_token:, month: nil, year: nil)
      # user = User.find_by(authentication_token: token)
      datetime = DateTime.now
      month ||= datetime.strftime("%m")
      year ||= datetime.strftime("%Y")

      # # month = sprintf('%02d', month)
      # # start_date = "#{year}-#{month}-01"
      # # end_date = Date.civil(year.to_i, month.to_i, -1)
      # # end_date = end_date.strftime("%Y-%m-%d")

      # active_achievement = ActiveAchievementMonthly.where("user_id = #{user.id}")
      user = User.find_by(authentication_token: user_token)
      data = ActiveAchievementMonthly.find_by(user_id: user.id)
      result = {name: get_month_name(month.to_i), 
                current: data.hit_rate, 
                percentage: data.hit_rate,
                total_nominal_proposal: total_periodic_proposal(user_token, [Date.today.month]) ,
                total_nominal_revenue: total_net_periodic_fee(user_token, [Date.today.month])}
      yearly_result = []
      for month in 1..Date.today.month do
        first_date = Date.new(Date.today.year, month, 1)
        last_date = first_date.end_of_month
        data = ActiveAchievementMonthly.where("created_at between '#{first_date}' and '#{last_date}' and user_id = #{user.id}")
        binding.pry
        result_detail = {name: get_month_name(month),
                         current: data.present? ? data.last.hit_rate : 0,
                         total_nominal_proposal: total_periodic_proposal(user_token, [Date.today.month]),
                         total_nominal_revenue: total_net_periodic_fee(user_token, [Date.today.month]),
                         percentage: data.present? ? data.last.hit_rate : 0}
        yearly_result.push(result_detail)
      end
      output = {target: get_target(user_token).hit_rate, monthly_result: result,  yearly_result: yearly_result}
      return output
    end

    # field :get_hit_rate_yearly, Types::Output::OutputType, null: false do
    #   argument :user_token, String, required: false
    # end
    # def get_hit_rate_yearly(user_token:)
    #   result = []
    #   for month in 1..Date.today.month do
    #     first_date = Date.new(Date.today.year, month, 1)
    #     last_date = first_date.end_of_month
    #     data = ActiveAchievementMonthly.where("created_at between '#{first_date}' and '#{last_date}'")
    #     result_detail = {name: get_month_name(month),
    #                      current: data.present? ? data.last.hit_rate : 0,
    #                      percentage: data.present? ? data.last.hit_rate : 0}
    #     result.push(result_detail)
    #   end
    #   output = {target: get_target(user_token).hit_rate,}
    #   return output
    # end

    field :network_installation_registration, Types::Output::OutputType, null: true do 
      argument :user_token, String, required: false
    end
    def network_installation_registration(user_token:)
      current = total_installation_registration_fee(user_token, [Date.today.month])
      target = get_target(user_token).one_time
      result = {name: get_month_name(Date.today.month),      
                current: current.present? ? current : 0, 
                percentage: get_percentage(current, target),
                last_month: total_installation_registration_fee(user_token, [Date.today.month - 1])}
      output = {target: get_target(user_token).one_time, monthly_result: result, yearly_result: total_installation_registration_fee(user_token)}
      return output
    end

    # field :network_installation_registration_yearly, Types::Output::OutputType, null: true do 
    #   argument :user_token, String, required: false
    # end
    # def network_installation_registration_yearly(user_token:)
    #   output = {target: get_target(user_token).one_time, }
    #   return output
    # end

    field :new_user, Types::Output::OutputType, null: true do 
      argument :user_token, String, required: false
    end
    def new_user(user_token:)
      current = total_new_user(user_token, [Date.today.month])
      # target = get_target(user_token).one_time
      target = 2
      result = {name: get_month_name(Date.today.month),
                current: current.present? ? current : 0,
                percentage: get_percentage(current.present? ? current : 0, target),
                last_month: total_new_user(user_token, [Date.today.month - 1])}
      output = {target: target, monthly_result: result, yearly_result: total_new_user(user_token)}
    end

    field :get_nilai_sf_setahun, Types::ReportMonthType, null: true do
      argument :user_token, String, required: false
    end
    def get_nilai_sf_setahun(user_token:)
      sf = GraphqlApi.customer(QueryModules::QueryCustomer.get_mou_yearly(user_token))
      data = sf["data"]["user"]["mousWithComponentYearly"]
      return get_sf(data, user_token)
    end

    field :get_acquisition, [Types::GetAcquisitionType], null: false do
      argument :token, String, required: true
      argument :month, Int, required: false
      argument :year, Int, required: false
    end
    def get_acquisition(token:,month: nil,year: nil)
      user = User.find_by(authentication_token: token)
      datetime = DateTime.now
      # day = datetime.strftime("%d")

      month = month.nil? ? datetime.strftime("%m") : month
      year = year.nil? ?  datetime.strftime("%Y") : year

      month = sprintf('%02d', month)
      start_date = "#{year}-#{month}-01"
      end_date = Date.civil(year.to_i, month.to_i, -1)
      end_date = end_date.strftime("%Y-%m-%d")
      Acquisition.where("user_id = #{user.id} AND first_payment_date >= '#{start_date}' AND first_payment_date <= '#{end_date}'")
    end

    field :get_renewal, Types::RenewalMonthlyType, null: true do
      argument :user_token, String, required: false
    end
    def get_renewal(user_token:)
      return get_renewal_format(user_token, Date.today.month)
    end

    field :get_renewal_yearly, [Types::RenewalYearlyType], null: true do
      argument :user_token, String, required: false
    end
    def get_renewal_setahun(user_token:)
      result = []
      month = 0
      12.times do
        result_detail = {}
        month += 1
        result_detail = {:name => Date::MONTHNAMES[month].to_date.strftime('%b').upcase, :total => get_renewal_format(user_token, month)}
        result.push(result_detail)
      end
      return result
    end

    field :get_installation_registration, Types::MonthlyType, null: true do 
      argument :user_token, String, required: false
    end
    def get_installation_registration(user_token:)
    end

    field :get_installation_registration_yearly, [Types::YearlyType], null: true do
      argument :user_token, String, required: false
    end
    def get_installation_registration_yearly(user_token:)
      result = []
      month = 0
      12.times do
        result_detail = {}
        month += 1
        result_detail = {:name => Date::MONTHNAMES[month].to_date.strftime('%b').upcase, :total => get_installation_registration_format(user_token, month)}
        result.push(result_detail)
      end
      return result
    end

    field :get_new_user, Types::MonthlyType, null: true do
      argument :user_token, String, required: false
    end
    def get_new_user(user_token:)
      return get_new_user_format(user_token, Date.today.month)
    end
    
    field :get_new_user_yearly, [Types::YearlyType], null: true do
      argument :user_token, String, required: false
    end
    def get_new_user_yearly(user_token:)
      result = []
      month = 0
      12.times do
        result_detail = {}
        month += 1
        result_detail = {:name => Date::MONTHNAMES[month].to_date.strftime('%b').upcase, :total => get_new_user_format(user_token, month)}
        result.push(result_detail)
      end
      return result
    end

    field :get_targets, [Types::TargetType], null: true
    def get_targets
      MasterTarget.all.where(active: true)
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
    def get_renewal_format(user_token, month)
      target = current_target_portofolio(user_token)
      current = current_active_portofolio(user_token, month)
      current = current > target ? target : current
      upcross = current > target ? current - target : 0
      percentage = (current.to_f / target.to_f) * 100
      last_month = month != 1 ? current_active_portofolio(user_token, month - 1) : 0
      result = {:target => target, :current => current, :percentage => percentage, :last_month => last_month, :upcross => upcross}
      return result
    end
    def get_installation_registration_format(user_token, month)
      result = {}
      user = User.find_by(authentication_token: user_token)
      target = MasterTarget.find_by(user_id: user.id)
      result[:target] = target.one_time
      instalasi = total_installation_fee(user_token, month).to_f
      registrasi = total_registration_fee(user_token, month).to_f
      result[:current] = (instalasi + registrasi).to_i
      result[:percentage] = (instalasi + registrasi) / target.one_time * 100
      result[:last_month] = month != 1 ? total_installation_fee(user_token, month - 1) + total_registration_fee(user_token, month - 1) : 0
      return result
    end
    def get_new_user_format(user_token, month)
      result = {}
      result[:target] = 2
      result[:current] = total_new_user(user_token, month)
      result[:percentage] = (total_new_user(user_token, month).to_f / 2) * 100
      result[:last_month] = month != 1 ? total_new_user(user_token, month - 1) : 0
      return result
    end
  end
end

    
# Ga dipake
# # Cara v1
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

# # Cara v2
# field :get_proposal_user, [Types::CustomerType::ProposalType], null: true do
#   argument :token, String, required: true
#   argument :month, Int, required: true
# end
# def get_proposal_user(token:, month:)
#   proposal = GraphqlApi.customer(QueryModules::QueryCustomer.get_proposal_user(token, month))
#   proposal["data"]["user"]["proposals"]
# end

# field :get_sf_user, [Types::CustomerType::SfType], null: true do
#   argument :token, String, required: true
#   argument :month, Int, required: true
# end
# def get_sf_user(token:, month:)
#   sf = GraphqlApi.customer(QueryModules::QueryCustomer.get_sf_user(token, month))
#   sf["data"]["user"]["mousWithComponent"]
# end

# field :get_nilai_sf, Types::NilaiSfType, null: true do
#   argument :token, String, required: true
#   argument :month, Int, required: true
# end
# def get_nilai_sf(token:, month:)
#   sf = GraphqlApi.customer(QueryModules::QueryCustomer.get_sf_user(token, month))
#   sf["data"]["user"]
# end

# field :get_target, Types::TargetType, null: true do 
#   argument :user_token, String, required: false
# end
# def get_target(user_token:)
#   user = User.find_by(authentication_token: user_token)
#   MasterTarget.find_by(user_id: user.id,active: true)
# end