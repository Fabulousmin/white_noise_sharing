class UserController < ApplicationController

  skip_before_filter :require_login, :only => [:login_form, :login, :new, :create, :verify]
  def login_form
  end

  def login
    _account = params[:account]
    _password = params[:password]


    user = User.find_by(account:_account)

    ## test12 ==100000000 번의 ... 시도 .. 120 * 6
    if user == nil #유저가 nil 이면 뒤로감.
      flash[:error] = "존재하지 않는 계정입니다."
      flash[:warning] = "존재하지 않는 계정입니다."

      redirect_to :back
      return
    end

    if user.password == Digest::SHA256.hexdigest(_password) ##SHA256 의 특징 .. 복호화 불가능..단방향 암호
      if user.is_verified == false #아직 인증 안했으면 .
        flash[:error] = "이메일 인증을 완료해 주세요."
      redirect_to controller:'user', action:'login_form'
      else
        ##sucess
      session[:logined] = true
      session[:user] = user #해쉬임..

      redirect_to controller:'post',action:'list'
      end
    end
  end

  def logout
     reset_session
     redirect_to controller:'post', action:'list'
  end

  def new

  end

  def create
    _account = params[:account]
    _password = params[:password]
    _name = params[:name]
    _email = params[:email]


    user = User.new
    user.account =_account
    user.password = Digest::SHA256.hexdigest(_password)
    user.email =_email
    user.is_verified = false
    user.name =_name

    verification =Verification.new
    verification.user = user
    verification.is_active = true
    verification.is_verified =false
    verification.code = SecureRandom.hex(16)
    verification.save

    UserMailer.signup(user, verification).deliver

    user.save

    redirect_to controller:'post', action:'list'
   end


  def verify
    _code = params[:code]

    verification = Verification.find_by(code:_code)

    if verification ==nil or verification.is_active ==false #인증이 만료되었거나 nil일때
      flash[:error] ="인증이 만료되었습니다"
      redirect_to '/' #기본 페이지로 복구
      return
    end

    user = verification.user
    user.is_verified = true #사용자 정보 인증되었다고 표시
    user.save

    verification.is_verified = true
    verification.is_active = false #한번 사용했으므로 false
    verification.save

    flash[:sucess] = "인증이 완료되었습니다. 로그인해주세요."

    UserMailer.welcome(user).deliver #메일 전송

    redirect_to controller:'user', action: 'login_form' #로그인 화면으로 이동
  end
end
