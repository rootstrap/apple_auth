# frozen_string_literal: true

class <%= @scope_prefix %>AppleAuthController < DeviseTokenAuth::SessionsController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token
  before_action :skip_session_storage
  before_action :check_json_request

  def create
    apple_params = apple_validate
    @resource = sign_in_with_apple(apple_params)
    custom_sign_in
  rescue AppleAuth::Conditions::JWTValidationError, OAuth2::Error, JWT::ExpiredSignature => e
    render_error(:bad_request, e.message)
  end

  private

  def apple_validate
    data = AppleAuth::UserIdentity.new(
      apple_sign_in_params[:user_identity],
      apple_sign_in_params[:jwt]
    ).validate!
    AppleAuth::Token.new(apple_sign_in_params[:code]).authenticate!

    data.slice(:email)
  end

  def custom_sign_in
    sign_in(:api_v1_user, @resource)
    new_auth_header = @resource.create_new_auth_token
    response.headers.merge!(new_auth_header)
    render_create_success
  end

  def sign_in_with_apple(user_params)
    user = User.where(provider: 'apple', uid: user_params[:email]).first_or_create!
    user.password = Devise.friendly_token[0, 20]
    user.assign_attributes user_params.except('id')
    user
  end

  def apple_sign_in_params
    params.permit(:user_identity, :jwt, :code)
  end

  def check_json_request
    return if request_content_type&.match?(/json/)

    render json: { error: I18n.t('api.errors.invalid_content_type') }, status: :not_acceptable
  end

  def render_create_success
    render json: { user: resource_data }
  end

  def render_error(status, message, _data = nil)
    response = {
      error: message
    }
    render json: response, status: status
  end

  def skip_session_storage
    # Devise stores the cookie by default, so in api requests, it is disabled
    # http://stackoverflow.com/a/12205114/2394842
    request.session_options[:skip] = true
  end

  def request_content_type
    request.content_type
  end
end
