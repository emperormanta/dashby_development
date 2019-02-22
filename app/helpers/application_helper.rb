module ApplicationHelper
  def total_net_periodic_fee(token, month)
    current_user_mou_product_ids = []
    total_periodic_sf = 0
    sf = GraphqlApi.customer(QueryModules::QueryCustomer.get_sf_user(token, month))

    if sf["data"]["user"].present?
      sf["data"]["user"]["mousWithComponent"].each do |mou|
          # mou_ids.push(mou["mouId"].to_i)
          mou["mouProducts"].each do |mou_product|
            current_user_mou_product_ids.push(mou_product["id"].to_i)
            total_periodic_sf += mou_product["periodicFee"]["finalPrice"]
          end
      end
    end

    total_periodic_xcost = get_total_xcost(current_user_mou_product_ids)
    return total_periodic_sf - total_periodic_xcost
  end

  def total_periodic_proposal(token,month)
    total = 0
    data = GraphqlApi.customer(QueryModules::QueryCustomer.get_proposal_user(token, month))
    if data["data"]["user"].present?
        data["data"]["user"]["proposals"].each do |proposal|
            proposal["product"].each do |product|
                total += product["periodicFee"]["finalPrice"]
            end
        end
    end
    return total
  end

  # def current_active_portofolio(token, month)
  #   total_active_portofolio = 0
  #   data = GraphqlApi.customer(QueryModules::QueryCustomer.get_active_portofolio(token, month))
  #   if data["data"]["user"].present?
  #     data["data"]["user"]["getActivePortofolioCrm"].each do |contact_product|
  #       mou_product_id_for_xcost.push(contact_product["mouProductId"])
  #       total_active_portofolio += contact_product["product"]["periodicFee"]["finalPrice"]
  #     end
  #   end
  #   total_periodic_xcost = get_total_xcost(mou_product_id_for_xcost)
  #   return total_active_portofolio - total_periodic_xcost
  # end

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

  # def current_active_portofolio(token, month)
  #   total_active_portofolio = 0
  #   data = GraphqlApi.customer(QueryModules::QueryCustomer.get_active_portofolio(token, month))
  #   if data["data"]["user"].present?
  #     data["data"]["user"]["getActivePortofolioCrm"].each do |contact_product|
  #       mou_product_id_for_xcost.push(contact_product["mouProductId"])
  #       total_active_portofolio += contact_product["product"]["periodicFee"]["finalPrice"]
  #     end
  #   end
  #   total_periodic_xcost = get_total_xcost(mou_product_id_for_xcost)
  #   return total_active_portofolio - total_periodic_xcost
  # end

  def get_total_xcost(mou_product_ids)
    total = 0
    if mou_product_ids.present?
      xcosts = GraphqlApi.xcost(QueryModules::QueryXcost.get_costs(mou_product_ids))
      if xcosts["data"].present?
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
end
