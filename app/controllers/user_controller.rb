class UserController < ApplicationController
  def login_form
  end

  def login
    _account = params[:account]
    _password = params[:password]

    user = User.find_by(account: _account)

    ## test12 ==100000000 번의 ... 시도 .. 120 * 6

    if user.password == Digest::SHA256.hexdigest(_password) ##SHA256 의 특징 .. 복호화 불가능..단방향 암호
      ##sucess
      session[:logined] = true
      session[:user] = user #해쉬임..

      redirect_to controller:'post',action:'list'

    else
      ##fail
      redirect_to :back
    end

  end

  def logout
     reset_session

     redirect_to controller:'post', aciton: 'list'
  end

  def new

  end

  def create
    _account = params[:account]
    _password = params[:password]
    _name = params[:name]

    if User.find_by(account: _account)!= nil
      redirect_to :back
      return
    end

    user = User.new
    user.account =_account
    user.password = Digest::SHA256.hexdigest(_password)
    user.name =_name

    user.save

    redirect_to controller:'post', action:'list'
  end

end
