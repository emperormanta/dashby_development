class CurrentUsersController < ApplicationController
  skip_before_action :authenticate_user!, :verify_authenticity_token
  def me
    query = {
      "client_id"     => params["client_id"],
      "client_secret" => params["client_secret"],
      "code" => params["code"],
      "grant_type"   => params["grant_type"],
      "redirect_uri" => params["redirect_uri"]
    }
    response = HTTParty.post("#{CONFIG['oauth']}/oauth/token",
    :query => query
    )

    if response["access_token"].present?

      access_token = response["access_token"]

      auth = "Bearer #{access_token}"
      response = HTTParty.get("#{CONFIG['oauth']}/me", :headers => { "Authorization" => auth})

      @user = CurrentUser.save_current_user(response)
      apps = AppsToken.all

      apps.each do |app|
        auth_token = check_user_auth_token(app.name, response)
        if auth_token["count"] == 0 && auth_token
          create_user(app.name, response)
          update_token(app.name)
        end
      end
    end
    render json: response
  end

  def check_user_auth_token(app_name, user_data)
    server = get_server_location(app_name)

    query = {
      "token" => "#{user_data['authentication_token']}"
    }

    if app_name == "customer"
      response = HTTParty.post("#{server}/api/v1/users/check",
      :query => query
      )
    else
      response = HTTParty.post("#{server}/users/check",
      :query => query
      )
    end

    if !response["count"].present?
      raise "#{app_name}: #{response}"
    end

    return response
  end

  def get_server_location(app_name)
    server = ""
    if app_name == "customer"
      server = "#{CONFIG['customer']}"
    end

    if app_name == "warehouse"
      server = "#{CONFIG['warehouse']}"
    end

    if app_name == "procurement"
      server = "#{CONFIG['procurement']}"
    end
    return server
  end

  def create_user(app_name, user_data)
    server = get_server_location(app_name)
    token_app_data = AppsToken.find_by(name: app_name)
    valid_token = check_token(token_app_data.name,token_app_data.token)
    if valid_token["result"]

      query = {
        "data" => "#{user_data}"
      }

      if app_name == "customer"
        response = HTTParty.post("#{server}/api/v1/users/create",
        :query => query
        )
      else
        response = HTTParty.post("#{server}/users/create",
        :query => query
        )
      end

      if !response["result"].present?
        raise "#{app_name}: #{response}"
      end
    else
      raise "#{app_name} token mismatch"
    end
  end

  def check_token(app_name,token)
    query = {
      "token" => "#{token}"
    }

    server = get_server_location(app_name)

    if app_name == "customer"
      response = HTTParty.post("#{server}/api/v1/maws/token/check",
      :query => query
      )
    else
      response = HTTParty.post("#{server}/maws/token/check",
      :query => query
      )
    end
    return response
  end

  def update_token(app_name)
    if app_name.present?
      o = [('a'..'z'), ('A'..'Z'), (0..9)].map(&:to_a).flatten
      token = (0...30).map { o[rand(o.length)] }.join
      data = AppsToken.find_by(name: app_name)

      if data
        data.token = token
        data.save

        server = get_server_location(app_name)

        query = {
          "token" => "#{token}"
        }

        if app_name == "customer"
          response = HTTParty.post("#{server}/api/v1/maws/token/update",
          :query => query
          )
        else
          response = HTTParty.post("#{server}/maws/token/update",
          :query => query
          )
        end

        if !response["result"].present?
          raise "#{app_name}: #{response}"
        end
      end
    end
  end
end
