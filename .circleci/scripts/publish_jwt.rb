#!/usr/bin/env ruby

require 'openssl'
require 'jwt'  # https://rubygems.org/gems/jwt

def wrap(s, width=78)
  s.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n")
end

# Private key contents
private_pem = wrap(ENV['GITHUBAPP_PRIVATE_KEY'], 39)
private_key = OpenSSL::PKey::RSA.new(private_pem)

# Generate the JWT
payload = {
  # issued at time
  iat: Time.now.to_i + 5,
  # JWT expiration time (10 minute maximum)
  exp: Time.now.to_i + (10 * 60),
  # GitHub App's identifier
  iss: 7837

}

jwt = JWT.encode(payload, private_key, "RS256")
puts jwt
