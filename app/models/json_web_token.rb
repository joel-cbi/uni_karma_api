require 'jwt'
class JsonWebToken
 class << self
   def encode(payload = ENV['API_TOKEN_PAYLOAD'])
     JWT.encode(payload, ENV['API_SECRET'], 'HS256')
   end

   def decode(token)
    begin
      JWT.decode(token, ENV['API_SECRET'], {algorithm: 'HS256'})[0]
     rescue
       nil
     end
   end

 end
end
