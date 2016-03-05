jwt_key = OpenSSL::PKey::RSA.generate 2048

ENV['JWT_PRIVATE_KEY'] = jwt_key.to_s
ENV['JWT_PUBLIC_KEY'] = jwt_key.public_key.to_s
