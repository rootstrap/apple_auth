class AppleSignInController < DeviseTokenAuth::SessionsController
  protect_from_forgery with: :null_session
  include Api::Concerns::ActAsApiRequest

  def apple_sign_in
    apple_params = apple_validate
    @resource = sign_in_with_apple(apple_params)
    custom_sign_in
  rescue AppleSignIn::Conditions::JWTValidationError
    render_error(:bad_request, I18n.t('api.errors.apple_sign_in'))
  rescue JWT::ExpiredSignature => e
    render_error(:bad_request, e.message)
  rescue ActiveRecord::RecordNotUnique
    render_error(:bad_request, I18n.t('api.errors.user.already_registered'))
  end

  private
  def apple_validate
    data = AppleSignIn::UserIdentity.new(
      apple_sign_in_params[:user_identity],
      apple_sign_in_params[:jwt]
    ).validate!
    AppleSignIn::Token.new(apple_sign_in_params[:code]).authenticate

    data.slice(:email)
  end

  def custom_sign_in
    sign_in(:api_v1_user, @resource)
    new_auth_header = @resource.create_new_auth_token
    # update response with the header that will be required by the next request
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

  def render_create_success
    render json: { user: resource_data }
  end
end