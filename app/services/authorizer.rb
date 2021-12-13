# frozen_string_literal: true

class Authorizer
  def authorize!(code)
    raise ArgumentError, 'Code is required' if code.blank?

    fetch_credentials!(code)
    update_user!

    user
  end

  delegate :url_for, :credentials, :userinfo, to: :google_authorizer

  private

  def user
    @user ||= User.find_or_create_by!(email: userinfo.email)
  end

  def update_user!
    user.update!(**credentials_attrs, **userinfo_attrs)
  end

  def credentials_attrs
    {
      access_token: credentials.access_token,
      refresh_token: credentials.refresh_token
    }
  end

  def userinfo_attrs
    {
      given_name: userinfo.given_name,
      family_name: userinfo.family_name,
      name: userinfo.name,
      google_id: userinfo.id,
      profile_picture_uri: userinfo.picture,
      locale: userinfo.locale,
      verified_email: userinfo.verified_email
    }
  end

  def fetch_credentials!(code)
    google_authorizer.authorize!(code)
  end

  def google_authorizer
    @google_authorizer ||= GoogleAuthorizer.new
  end
end
