class UserController < ApplicationController

  ##로그인 세션 체크 제외할 action 명시
  skip_before_filter :require_login, :only => [:login_form, :login, :new, :create, :verify, :forgot_form, :forgot_change, :forgot, :forgot_change]


##login_start
  def login_form
  end


  def login
    _account  = params[:account]
    _password = params[:password]

    user = User.find_by(account:_account)

      ## test12 ==100000000 번의 ... 시도 .. 120 * 6
    if user == nil #유저가 nil 이면 뒤로감.
      flash[:error]   = "존재하지 않는 계정입니다."
      flash[:warning] = "존재하지 않는 계정입니다."

      redirect_to controller:'user', action: 'login_form'
      return
    end

    if user.password == Digest::SHA256.hexdigest(_password) ##SHA256 의 특징 .. 복호화 불가능..단방향 암호
        ##login_fail
      if user.is_verified == false #아직 인증 안했으면 .
        flash[:error] = "이메일 인증을 완료해 주세요."
        redirect_to controller: 'user', action:'login_form'
      else
        ##login_succses
      session[:logined] = true
      session[:user]    = user #해쉬임..

      redirect_to controller: 'post',action:'list'
      end
    end
  end

##login_end

##logout_start
  def logout
     reset_session
     redirect_to controller:'post', action:'list'
  end
##logout_end


##add_new_account_start
  def new
  end

  def create
    _account  = params[:account]
    _password = params[:password]
    _name     = params[:name]
    _email    = params[:email]


    user             = User.new
    user.account     = _account
    user.password    = Digest::SHA256.hexdigest(_password)
    user.email       = _email
    user.is_verified = false
    user.name        = _name
    user.save

    verification             = Verification.new
    verification.user        = user   ##verification 은 user 를 상속받기때문에 user 를 가짐.
    verification.is_active   = true   ##verification 이 유효한가?
    verification.is_verified = false  ##verification 이 인증을 받았는가?
    verification.code        = SecureRandom.hex(16) #랜덤 16자리 코드
    verification.save

    UserMailer.signup(user,verification).deliver


    flash[:success] ="가입이 완료되었습니다. 인증을 해주세요."
    redirect_to controller:'post', action:'list'
   end
##add_new_account_end


##verify_start
  def verify
    _code        = params[:code]

    verification = Verification.find_by(code:_code)

    ##인증실패
    if verification ==nil or verification.is_active ==false #인증이 만료되었거나 nil일때
      flash[:error] ="인증이 만료되었습니다"
      redirect_to '/' #기본 페이지로 복구
      return
    end

    ##인증성공
    user                     = verification.user
    user.is_verified         = true #사용자 정보 인증되었다고 표시
    user.save

    verification.is_verified = true  #인증이 완료됨
    verification.is_active   = false #한번 사용했으므로 false
    verification.save

    flash[:sucess]           = "인증이 완료되었습니다. 로그인해주세요."

    UserMailer.welcome(user).deliver #메일 전송

    redirect_to controller: 'user', action: 'login_form' #로그인 화면으로 이동
  end
##verify_end

  ##forgot_start
  def forgot_form

  end

  def forgot
    _email = params[:email]
    user = User.find_by(email:_email)

    if user == nil
      flash[:error] ="존재하지 않는 계정입니다."
      redirect_to :back
      return
    elsif user.is_verified == false
      flash[:error] ="이메일 인증을 완료해주세요."
      redirect_to :back
      return
    end

    verification             = Verification.new
    verification.is_verified = true
    verification.is_active   = true
    verification.user        = user
    verification.code        = SecureRandom.hex(16)
    verification.save

    UserMailer.forgot(user, verification).deliver

    flash[:success] ="이메일을 확인해 주세요"

    redirect_to :back
  end

  def forgot_change
    _code        = params[:code]
    verification = Verification.find_by(code:_code)

    ##인증실패
    if verification ==nil or verification.is_active ==false #인증이 만료되었거나 nil일때
      flash[:error] ="인증이 만료되었습니"
      redirect_to '/' #기본 페이지로 복구
      return
    end

    if verification.is_verified == false
      flash[:error] ="인증이 완료되지 않은 계정입니다."
      redirect_to '/'
      return
    end

    @code = _code


  end

  def forgot_confirm
    _code = params[:code]
    _password = params[:password]

    user = User.find_by(code:_code)

    if verification == nil or verification.is_active == false
      flash[:error] ="인증이 만료되었습니다"
      redirect_to '/'

    if user == nil or user.is_verified == false
      flash[:error]= "유효하지 않은 계정입니다."
      redirect_to '/'
      return
    end

    user.password = Digest::SHA256.hexdigest(_password)
    user.save

    verification.is_active = false
    verification.save

    flash[:success] ="비밀번호가 변경되었습니다."
    redirect_to controller: 'post', action: 'list'
  end

  end
  ##forgot_end

end
