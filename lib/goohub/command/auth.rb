class GoohubCLI < Clian::Cli
  ################################################################
  # Command: auth
  ################################################################
  desc "auth", "Authenticate interactively"
  def auth
    config = @config.general
    authorizer = Clian::Authorizer.new(config.client_id,
                                        config.client_secret,
                                        Google::Apis::CalendarV3::AUTH_CALENDAR,
                                        config.token_store_path)
    authorizer.auth_interactively(config.default_user)
  end
end
