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

    total_periodic_xcost = 0
    if current_user_mou_product_ids.present?
      xcosts = GraphqlApi.xcost(QueryModules::QueryXcost.get_costs(current_user_mou_product_ids))
      if xcosts["data"].present?
        xcosts = JSON.parse(xcosts["data"]["getCosts"])
        xcosts["mou_products"].each do |mou_product|
          mou_product["costs"].each do |cost|
              total_periodic_xcost += cost["periodic"]
          end
        end
      end
    end
    return total_periodic_sf - total_periodic_xcost
  end
end
