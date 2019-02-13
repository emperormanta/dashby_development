class MasterTargetController < ApplicationController
    include UploadCsvHelper
    require 'csv'
    
    def download_template
        send_file("#{Rails.root}/public/uploads/template_target.csv")
    end

    def upload
        file = params[:file]
        
        if file.present? && file.content_type == "text/csv"
            arr_full_name = []
            arr_target_nominal = [] #Rp
            arr_target_hitrate = [] #Percentage
            arr_target_periodic = [] #Rp
            arr_target_one_time = [] #Rp
            arr_target_nominal_tolerance = [] #Rp
            arr_target_acquisition = [] #Monthly

            error = false
            messages = ""

            time = Time.now
            csv_text = File.read(file.path)
            csv = CSV.parse(csv_text, headers: true, skip_blanks: true).delete_if { |row| row.to_hash.values.all?(&:blank?) }
            csv.each_with_index do |row, row_index|
                
                row.each_with_index do |col, col_index|
                    if col[1].present?
                        data = col[1].gsub(/[,.]/, "," => "", "." => "")
                        if col_index == 0
                            arr_full_name.push(data.downcase)
                        elsif col_index == 3
                            arr_target_nominal.push(data)
                        elsif col_index == 4
                            arr_target_hitrate.push(data)
                        elsif col_index == 5
                            arr_target_periodic.push(data)
                        elsif col_index == 6
                            arr_target_one_time.push(data)
                        elsif col_index == 7
                            arr_target_nominal_tolerance.push(data)
                        elsif col_index = 8
                            arr_target_acquisition.push(data)
                        end
                    else
                        error = true
                        messages = "Terdapat data yang kosong"
                        break
                    end
                end
            end

            if error == true
                render json: { success: false, messages: messages }
            else
                users = User.select(:id).where("LOWER(full_name) IN (?)", arr_full_name)
            
                if users.present?
                    data_insert = []
                    for i in 0..users.length-1
                        data_insert.push("(#{users[i]['id']}, #{arr_target_nominal[i]}, #{arr_target_hitrate[i]}, #{arr_target_periodic[i]},
                            #{arr_target_one_time[i]}, #{arr_target_nominal_tolerance[i]}, #{arr_target_acquisition[i]}, true, 
                            '#{time.strftime("%Y-%d-%m %H:%M:%S")}', '#{time.strftime("%Y-%d-%m %H:%M:%S")}')")
                    end

                    MasterTarget.update_all(active: false)

                    sql = 'INSERT INTO master_targets ("user_id", "nominal", "hit_rate", "one_time", "periodic", 
                    "nominal_tolerance","acquisition","active","created_at", "updated_at") VALUES '+data_insert.join(", ")
                    
                    ActiveRecord::Base.connection.execute(sql)
                    upload_csv(file)
                    render json: { success: true, messages: "Data updated successfully" }
                else
                    render json: { success: false, messages: "Users on CSV file doesnt exist on table 'users'" }
                end
            end
        else
            render json: { success: false, messages: "File is not CSV" }
        end
    end
end
