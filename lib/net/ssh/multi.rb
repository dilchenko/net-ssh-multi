require 'net/ssh/multi/session'

module Net; module SSH
  # Net::SSH::Multi is a library for controlling multiple Net::SSH
  # connections via a single interface. It exposes an API similar to that of
  # Net::SSH::Connection::Session and Net::SSH::Connection::Channel, making it
  # simpler to adapt programs designed for single connections to be used with
  # multiple connections.
  #
  # This library is particularly useful for automating repetitive tasks that
  # must be performed on multiple machines. It executes the commands in
  # parallel, and allows commands to be executed on subsets of servers
  # (defined by groups).
  #
  #   require 'net/ssh/multi'
  # 
  #   Net::SSH::Multi.start do |session|
  #     # access servers via a gateway
  #     session.via 'gateway', 'gateway-user'
  # 
  #     # define the servers we want to use
  #     session.use 'host1', 'user1'
  #     session.use 'host2', 'user2'
  # 
  #     # define servers in groups for more granular access
  #     session.group :app do
  #       session.use 'app1', 'user'
  #       session.use 'app2', 'user'
  #     end
  # 
  #     # execute commands
  #     session.exec "uptime"
  # 
  #     # execute commands on a subset of servers
  #     session.with(:app) { session.exec "hostname" }
  # 
  #     # run the aggregated event loop
  #     session.loop
  #   end
  # 
  # See Net::SSH::Multi::Session for more documentation.
  module Multi
    # This is a convenience method for instantiating a new
    # Net::SSH::Multi::Session. If a block is given, the session will be
    # yielded to the block automatically closed (see Net::SSH::Multi::Session#close)
    # when the block finishes. Otherwise, the new session will be returned.
    #
    #   Net::SSH::Multi.start do |session|
    #     # ...
    #   end
    #
    #   session = Net::SSH::Multi.start
    #   # ...
    #   session.close
    def self.start
      session = Session.new

      if block_given?
        begin
          yield session
          session.loop
          session.close
        end
      else
        return session
      end
    end
  end
end; end