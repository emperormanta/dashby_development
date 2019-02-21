class SyncController < ApplicationController
    skip_before_action :authenticate_user!
    require 'date'
    include ApplicationHelper
    
    def update_hit_rate
        # SyncWorker.perform_async()
        # SyncWorker.perform_at("00:00:01".to_time)
        
        # month = Time.now.strftime("%m")
        month = 1 # BUAT TESTING SAJA
        
        sales_crm_users_division = []
        sales_crm_users_division.push("division LIKE '%\"id\":\"I-02\"%'")
        sales_crm_users_division.push("division LIKE '%\"id\":\"F-02\"%'")
        sales_crm_users_division = sales_crm_users_division.join(' OR ')

        # users = User.where(sales_crm_users_division)
        users = User.where(authentication_token: "71b94738d925deac6690baa81750c357") # BUAT TESTING SAJA

        users.each do |user|
            mou_ids = []
            token = user.authentication_token

            total_net_periodic = total_net_periodic_fee(token, month)
            total_net_periodic_proposal = total_periodic_proposal(token, month)
            
            if total_net_periodic_proposal > 0
                hit_rate_user = (total_net_periodic.to_f / total_net_periodic_proposal.to_f) * 100
                master_target = MasterTarget.find_by(user_id: user.id, active:true)

                # SAVE / UPDATE KE TABEL
                data = ActiveAchievementMonthly.new
                data.hit_rate = hit_rate_user
                data.user_id = user.id
                data.master_target_id = master_target.id
                
                if data.save
                    render json: { success: true, messages: "Updated Successfully" }
                else
                    render json: { success: false, messages: data.errors.full_messages }
                end
            end
        end
    end

    def update_acquisition_times
        month = Time.now.strftime("%m")
        month = sprintf('%02d', month).to_i

        sales_crm_users_division = []
        sales_crm_users_division.push("division LIKE '%\"id\":\"I-02\"%'")
        sales_crm_users_division.push("division LIKE '%\"id\":\"F-02\"%'")
        sales_crm_users_division = sales_crm_users_division.join(' OR ')

        users = User.where(sales_crm_users_division)
        # users = User.where(authentication_token: "1c59629411140c526f3f6c996856b049")

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

                    # SAVE / UPDATE KE TABEL
                end
            end
        end
    end
end
