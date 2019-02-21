class ApplicationController < ActionController::API
  before_action :authenticate_user!, if: :not_authenticate_token

  def check_auth_token
    user = nil
    token = request.headers["Authorization"]
    if token
      token = token.remove("Bearer ")
      user = User.find_by(authentication_token: token)
    end
    user
  end

  def not_authenticate_token
      user = check_auth_token
      if user
        pass_token(user)
        false
      else
        true
      end
  end

  def pass_token(user)
    GraphqlApi.token_api = user.authentication_token
  end
end
