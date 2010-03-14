module SignedUser
  def signed_user
    @signed_user
  end

  def signed_user?
    !signed_user.nil?
  end

  def signed_user=(new_user)
    @signed_user = new_user
  end

  def unpack_signer
    return if (params[:message].blank? || params[:digest].blank?)
    unpacked_digest = Zlib::Inflate.inflate(Base64.decode64(params[:digest])) rescue nil
    username = MAGIC_KEY_AUTH.authenticate(:digest => unpacked_digest, :message => params[:message]) {|pem|
      self.signed_user = User.find_or_create_by_login(:login => pem)
    }
    Rails.logger.debug("do we have a signed user? #{self.signed_user.inspect}")
    self.signed_user
  rescue
    Rails.logger.error{"Exception unpacking user: #{$!.to_s}"}
    self.signed_user = nil
  end

  def self.included(base)
    base.send :helper_method, :signed_user, :signed_user?
    base.send :before_filter, :unpack_signer
  end
end