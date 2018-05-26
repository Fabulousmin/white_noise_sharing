class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.signup.subject
  #
  def signup(user, verification)
    @user = user
    @verification = verification
    mail to:@user.email, subject: "인증을 해주세요" #이메일제목
    @host = ActionMailer::Base.default_url_options[:host]

  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.forgot.subject
  #
  def forgot
    @user = user

    mail to:@user.email, subject: "[사이트명] 비밀번호 찾기 이메일 입니다."

  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def welcome
    @user = user

    mail to:@user.email, subject: "[사이트명]회원가입 환영합니다."

  end
end