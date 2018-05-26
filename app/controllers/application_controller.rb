class ApplicationController < ActionController::Base
  #protect_from_forgery with: :exception

  before_filter :require_login

  protected

  def require_login
    @logined_user = logined_in  #logined_in메소드 호출
    if not @logined_user
      redirect_to controller:'user', action:'login_form'
    end
  end

  def logined_in #로그인 되있으면 현재유저 리턴, 로그인 안되있으면 false
    if session[:logined]
      current_user = session[:user]
      return current_user
    end
    return false
  end
end
