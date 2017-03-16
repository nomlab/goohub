class GoohubCLI < Clian::Cli
  ################################################################
  # Command: auth
  ################################################################
  desc "auth", "Authenticate interactively"
  def auth
    config = @config.general
    @authorizer.auth_interactively(config.default_user)
  end
end
