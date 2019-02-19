class SyncController < ApplicationController
    require 'date'
    def update_hit_rate
        # SyncWorker.perform_async()
        # SyncWorker.perform_in(24.hours)
        
        month = Time.now.strftime("%m")
        # month = 2
        
        sales_crm_users_division = []
        sales_crm_users_division.push("division LIKE '%\"id\":\"I-02\"%'")
        sales_crm_users_division.push("division LIKE '%\"id\":\"F-02\"%'")
        sales_crm_users_division = sales_crm_users_division.join(' OR ')

        users = User.where(sales_crm_users_division)

        users.each do |user|
            mou_ids = []
            token = user.authentication_token

            total_periodic_sf = 0
            data = GraphqlApi.customer(QueryModules::QueryCustomer.get_sf_user(token, month))
            if data["data"]["user"].present?
                data["data"]["user"]["mousWithComponent"].each do |mou|
                    mou_ids.push(mou["mouId"].to_i)
                    mou["mouProducts"].each do |mou_product|
                        total_periodic_sf += mou_product["periodicFee"]["finalPrice"]
                    end
                end
            end

            total_periodic_xcost = 0
            if mou_ids.present?
                data2 = GraphqlApi.xcost(QueryModules::QueryXcost.get_costs(mou_ids))

                if data2["data"].present?
                    data2 = JSON.parse(data2["data"]["getCosts"])
                    data2["mou_products"].each do |mou_product|
                        mou_product["costs"].each do |cost|
                            total_periodic_xcost += cost["periodic"]
                        end
                    end
                end
            end
            
            total_periodic_proposal = 0
            data3 = GraphqlApi.customer(QueryModules::QueryCustomer.get_proposal_user(token, month))
            if data3["data"]["user"].present?
                data3["data"]["user"]["proposals"].each do |proposal|
                    proposal["product"].each do |product|
                        total_periodic_proposal += product["periodicFee"]["finalPrice"]
                    end
                end
            end
            
            if total_periodic_proposal > 0
                hit_rate_user = ((total_periodic_sf - total_periodic_xcost) / total_periodic_proposal) * 100
                # user = User.find_by(authentication_token: token)
                master_target = MasterTarget.find_by(user_id: user.id, active:true)

                if master_target.present?
                    test = ActiveAchievementMonthly.find_by(user_id: user.id)
                    if test.present?
                        test.hit_rate = hit_rate_user
                        # test.nilai_sf = total_periodic_sf
                        # test.nilai_proposal = total_periodic_proposal
                        test.master_target_id = master_target.id
                        test.save
                    else
                        test2 = ActiveAchievementMonthly.new
                        test2.user_id = user.id
                        test2.hit_rate = hit_rate_user
                        # test2.nilai_sf = total_periodic_sf
                        # test2.nilai_proposal = total_periodic_proposal
                        test2.master_target_id = master_target.id
                        test2.save
                    end
                end
            end
        end
    end

    def update_acquisition_times
        # month = Time.now.strftime("%m")
        # month = sprintf('%02d', month).to_i
        month = 1 # BUAT TESTING

        sales_crm_users_division = []
        sales_crm_users_division.push("division LIKE '%\"id\":\"I-02\"%'")
        sales_crm_users_division.push("division LIKE '%\"id\":\"F-02\"%'")
        sales_crm_users_division = sales_crm_users_division.join(' OR ')

        # users = User.where(sales_crm_users_division).limit(3)
        users = User.where(authentication_token: "1c59629411140c526f3f6c996856b049")

        users.each do |user|
            token = user.authentication_token
            mou = GraphqlApi.customer(QueryModules::QueryCustomer.get_mou_dashby(token,month))
            
            if mou["data"]["getMouDashby"].present?
                mou["data"]["getMouDashby"].each do |mou|
                    project_id = mou["projectId"]
                    mou_id = mou["mouId"]
                    proposal_created_date = ""
                    first_payment_date = mou["paymentDate"].to_time

                    proposal = GraphqlApi.customer(QueryModules::QueryCustomer.get_proposal_dashby(project_id))
                    
                    if proposal["data"]["getProposalDashby"].present?
                        proposal_created_date = proposal["data"]["getProposalDashby"][0]["createdAt"].to_time
                    end

                    t = (first_payment_date - proposal_created_date).to_i
                    mm, ss = t.divmod(60)
                    hh, mm = mm.divmod(60)
                    dd, hh = hh.divmod(24)

                    user = User.find_by(authentication_token: token)
                    master_target = MasterTarget.find_by(user_id: user.id)

                    acquisition = Acquisition.new
                    acquisition.project_id = project_id
                    acquisition.mou_id = mou_id
                    acquisition.proposal_created_date = proposal_created_date
                    acquisition.first_payment_date = first_payment_date
                    acquisition.spent_time_day = dd
                    acquisition.master_target_id = master_target.id
                    acquisition.user_id = user.id
                    acquisition.save!
                end
            end
        end
    end
end
