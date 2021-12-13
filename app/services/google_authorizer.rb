# frozen_string_literal: true

require 'googleauth'
require 'googleauth/web_user_authorizer'
require 'google/apis/oauth2_v2'

class GoogleAuthorizer
  attr_reader :credentials, :userinfo

  def authorize!(code)
    fetch_credentials_for!(code)
    set_authorization!
    fetch_userinfo!
  end

  def url_for(request)
    authorizer.get_authorization_url(request: request)
  end

  private

  def authorizer
    Google::Auth::WebUserAuthorizer.new(
      client_id, scope, nil, callback_path
    )
  end

  def client_id
    @client_id ||= Google::Auth::ClientId.from_file(client_config_path)
  end

  def client_config_path
    Rails.root.join(client_config_filename)
  end

  def client_config_filename
    ENV['GOOGLE_CLIENT_CONFIG']
  end

  def scope
    [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/userinfo.profile'
    ]
  end

  def fetch_credentials_for!(code)
    return credentials if credentials.present?

    @credentials = authorizer.get_credentials_from_code(code: code, base_url: base_url)
    @credentials
  end

  def fetch_userinfo!
    @userinfo = service.get_userinfo_v2
  end

  def signature
    raise 'Not authorized' if credentials.blank?

    Signet::OAuth2::Client.new(access_token: credentials.access_token)
  end

  def set_authorization!
    service.authorization = signature
  end

  def service
    @service ||= Google::Apis::Oauth2V2::Oauth2Service.new
  end

  def callback_path
    '/sessions/callback'
  end

  def base_url
    'http://localhost:3000'
  end
end
