require 'googleauth'
require 'webrick'
require 'launchy'

class GoohubCLI < Clian::Cli
  ################################################################
  # Command: auth
  ################################################################
  desc "auth", "Authenticate interactively"
  def auth
    config = @config.general
    
    redirect_uri = 'http://localhost:8080'
    redirect_port = 8080

    authorizer = Google::Auth::UserAuthorizer.new(
      Google::Auth::ClientId.new(config.client_id, config.client_secret),
      Google::Apis::CalendarV3::AUTH_CALENDAR,
      Google::Auth::Stores::FileTokenStore.new(file: config.token_store_path),
      redirect_uri
    )
    url = authorizer.get_authorization_url
    begin
      Launchy.open(url)
    rescue
      puts "Open URL in your browser:\n #{url}"
    end

    auth_code = nil
    dev_null = WEBrick::Log.new('/dev/null', 7)
    srv = WEBrick::HTTPServer.new({ DocumentRoot: './',
                                    BindAddress: '127.0.0.1',
                                    Port: redirect_port,
                                    Logger: dev_null,
                                    AccessLog: dev_null })
    srv.mount_proc '/' do |req, res|
      auth_code = req.query['code']
      res.body = res_message
      srv.shutdown
    end
    srv.start

    authorizer.get_and_store_credentials_from_code(
      user_id:  config.default_user,
      code:     auth_code
    )
  end

  private

  def res_message
    <<~_EOT_
    <html>
      <head>
        <title>goohub</title>
      </head>
      <body>
        <center>
          <h3>Success to get authentication code</h3>
          <h4>Please close browser</h4>
        </center>
      </body>
    </html>
  _EOT_
  end
end
