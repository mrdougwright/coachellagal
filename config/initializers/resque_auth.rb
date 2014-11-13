Resque::Server.use(Rack::Auth::Basic) do |user, password|
  # username and password for looking at resque admin
  [user, password] == ["admin", "password"]
end

