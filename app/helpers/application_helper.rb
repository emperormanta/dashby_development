module ApplicationHelper
  def total_net_periodic_fee(token, month = nil)
    current_user_mou_product_ids = []
    total_periodic_sf = 0
    month ||= [*1..Date.today.month] # Isi dengan array bulan 1 sampai bulan berjalan
    sf = GraphqlApi.customer(QueryModules::QueryCustomer.get_sf_user(token, month, Date.today.year))
    if sf["data"]["user"]["mousWithComponent"].present?
      if month.length == 1
        sf["data"]["user"]["mousWithComponent"].each do |mou|
          # mou_ids.push(mou["mouId"].to_i)
          mou["mouProducts"].each do |mou_product|
            current_user_mou_product_ids.push(mou_product["id"].to_i)
            total_periodic_sf += mou_product["periodicFee"]["finalPrice"]
          end
        end
        total_periodic_xcost = get_total_xcost(current_user_mou_product_ids)
        return total_periodic_sf - total_periodic_xcost
      else
        yearly_data = []
        month.each do |current_month|
          current_month_total = 0
          sf["data"]["user"]["mousWithComponent"].each do |mou|
            if mou["paymentDate"].to_date.month == current_month 
              mou["mouProducts"].each do |mou_product|
                current_user_mou_product_ids.push(mou_product["id"].to_i)
                current_month_total += mou_product["periodicFee"]["finalPrice"]
              end
            end
          end
          total_periodic_xcost = get_total_xcost(current_user_mou_product_ids)
          current_month_target = get_target(token).periodic
          result = {name: get_month_name(current_month), current:  current_month_total - total_periodic_xcost, percentage: get_percentage(current_month_total - total_periodic_xcost, current_month_target), current_month_target: current_month_target}
          yearly_data.push(result)
        end
        return yearly_data
      end
    end
  end

  def total_periodic_proposal(token, month = nil)
    total = 0
    month ||= [*1..Date.today.month] # Isi dengan array bulan 1 sampai bulan berjalan
    data = GraphqlApi.customer(QueryModules::QueryCustomer.get_proposal_user(token, month, Date.today.year))
    if data["data"]["user"]["proposals"].present?
      if month.length == 1
        data["data"]["user"]["proposals"].each do |proposal|
          proposal["product"].each do |product|
              total += product["periodicFee"]["finalPrice"]
          end
        end
        return total
      else
        yearly_data = []
        month.each do |current_month|
          current_month_total = 0
          data["data"]["user"]["proposals"].each do |proposal|
            if proposal["createdAt"].to_date.month == current_month 
              proposal["product"].each do |product|
                current_month_total += product["periodicFee"]["finalPrice"]
              end
            end
          end
          current_month_target = get_target(token).nominal
          result = {name: get_month_name(current_month), current:  current_month_total, percentage: get_percentage(current_month_total, current_month_target), current_month_target: current_month_target}
          yearly_data.push(result)
        end
        return yearly_data
      end
    end
  end

  def total_installation_registration_fee(token, month = nil)
    total_registration_sf = 0
    total_installation_sf = 0
    month ||= [*1..Date.today.month] # Isi dengan array bulan 1 sampai bulan berjalan
    sf = GraphqlApi.customer(QueryModules::QueryCustomer.get_installation_registration_fee(token, month, Date.today.year))
    if sf["data"]["user"]["mousWithComponent"].present?
      if month.length == 1
        sf["data"]["user"]["mousWithComponent"].each do |mou|
          mou["mouProducts"].each do |mou_product|
            total_registration_sf += mou_product["registrationFee"]["finalPrice"]
            total_installation_sf += mou_product["installationFee"]["finalPrice"]
          end
        end
        return (total_registration_sf + total_installation_sf)
      else
        yearly_data = []
        month.each do |current_month|
          sf["data"]["user"]["mousWithComponent"].each do |mou|
            if mou["paymentDate"].to_date.month == current_month
              mou["mouProducts"].each do |mou_product|
                total_registration_sf += mou_product["registrationFee"]["finalPrice"]
                total_installation_sf += mou_product["installationFee"]["finalPrice"]
              end
            end
          end
          current_month_target = get_target(token).one_time
          result = {name: get_month_name(current_month), 
                    current:  total_registration_sf + total_installation_sf, 
                    percentage: get_percentage(total_registration_sf + total_installation_sf, current_month_target), 
                    current_month_target: current_month_target,}
          yearly_data.push(result)
        end
        return yearly_data
      end
    end
  end

  def total_installation_fee(token, month)
     # current_user_mou_product_ids = []
     total_installation_sf = 0
     sf = GraphqlApi.customer(QueryModules::QueryCustomer.get_installation_fee(token, month))
     if sf["data"]["user"]["mousWithComponent"].present?
       sf["data"]["user"]["mousWithComponent"].each do |mou|
           # mou_ids.push(mou["mouId"].to_i)
           mou["mouProducts"].each do |mou_product|
            #  current_user_mou_product_ids.push(mou_product["id"].to_i)
             total_installation_sf += mou_product["installationFee"]["finalPrice"]
           end
       end
     end
     return total_installation_sf
  end

  def total_new_user(token, month)
    total_new_user = 0
    sf = GraphqlApi.customer(QueryModules::QueryCustomer.get_sf_user(token, month))
    if sf["data"]["user"]["mousWithComponent"].present?
      total_new_user = sf["data"]["user"]["mousWithComponent"].length
    end
    return total_new_user
  end

  def current_target_portofolio(token)
    total_target_portofolio = 0
    mou_product_id_for_xcost = []
    data = GraphqlApi.customer(QueryModules::QueryCustomer.get_target_portofolio(token))
    if data["data"]["user"]["getTargetPortofolioCrm"].present?
      data["data"]["user"]["getTargetPortofolioCrm"].each do |contact_product|
        if contact_product["mouProductId"].present?
          mou_product_id_for_xcost.push(contact_product["mouProductId"])
        end
        total_target_portofolio += contact_product["product"]["periodicFee"]["finalPrice"]
      end
    end
    total_periodic_xcost = get_total_xcost(mou_product_id_for_xcost)
    return total_target_portofolio - total_periodic_xcost

  end

  def current_active_portofolio(token, month)
    total_active_portofolio = 0
    mou_product_id_for_xcost = []
    data = GraphqlApi.customer(QueryModules::QueryCustomer.get_active_portofolio(token, month))
    if data["data"]["user"]["getActivePortofolioCrm"].present?
      data["data"]["user"]["getActivePortofolioCrm"].each do |contact_product|
        if contact_product["mouProductId"].present?
          mou_product_id_for_xcost.push(contact_product["mouProductId"])
        end
        total_active_portofolio += contact_product["product"]["periodicFee"]["finalPrice"]
      end
    end
    total_periodic_xcost = get_total_xcost(mou_product_id_for_xcost)
    return total_active_portofolio - total_periodic_xcost
  end

  def get_total_xcost(mou_product_ids)
    total = 0
    if mou_product_ids.present?
      xcosts = GraphqlApi.xcost(QueryModules::QueryXcost.get_costs(mou_product_ids))
      if xcosts["data"]["getCosts"].present?
        xcosts = JSON.parse(xcosts["data"]["getCosts"])
        xcosts["mou_products"].each do |mou_product|
          mou_product["costs"].each do |cost|
            total += cost["periodic"]
          end
        end
      end
    end
    return total
  end

  def get_month_name(month)
    return Date::MONTHNAMES[month].to_date.strftime('%b').upcase
  end

  def get_target(token)
    user_id = User.find_by(authentication_token: token).id
    return user_id.present? ? MasterTarget.find_by(user_id: user_id) : nil
  end

  def get_percentage(current, target)
    return (current.to_f / target.to_f) * 100
  end
end
