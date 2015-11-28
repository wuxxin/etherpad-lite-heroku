#!/usr/bin/env ruby
require 'fileutils'
require 'json'
require 'uri'

# Create settings hash add merge in the user-provided JSON.
database_uri = URI.parse(ENV['DATABASE_URL'])
settings = {
  dbType: database_uri.scheme,
  dbSettings: {
    user: database_uri.user,
    host: database_uri.host,
    password: database_uri.password,
    database: database_uri.path.sub(%r{^/}, '')
  },
}.merge(JSON.parse(File.read(ENV.fetch('ETHERPAD_SETTINGS'))))

# Write the settings hash out as JSON.
File.open('./etherpad-lite/settings.json', 'w') { |f| f.write(settings.to_json) }

if ENV['ETHERPAD_ALLOW_ROOT'] == '1'
exec('./etherpad-lite/bin/run.sh --root')
else
exec('./etherpad-lite/bin/run.sh')
end
