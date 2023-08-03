class RevokedJwtToken < ApplicationRecord

  def self.revoke(token)
    create(token: token)
  end
end

