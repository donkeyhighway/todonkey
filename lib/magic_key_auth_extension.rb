require 'magic_key_auth'
class MagicKeyAuthExtension < MagicKeyAuth::SSL
  class << self
    def authenticate(opts = {})
      user = super
      yield user if block_given? && !user.blank?
      return user
    end
  end
end