module CSRF
  def protect_from_forgery
    @protect = true
  end

  def same_token?
    params[:authenticity_token] == session[:authenticity_token]
  end

  def reset_authenticity_token!
    session[:authenticity_token] = SecureRandom::urlsafe_base64
  end

  def form_authenticity_token
    session[:authenticity_token]
  end
end
