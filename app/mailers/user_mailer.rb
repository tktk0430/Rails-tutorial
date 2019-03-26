class UserMailer < ApplicationMailer

  def account_activation(user) 
    #インスタンスメソッドではない！この特殊なクラスで呼び出されたメソッドはクラスメソッド！
    @user=user
    mail to: @user.email 
    #このアドレス宛に/view/account_activationのtxtないしはhtmlがとどく
  end

  def password_reset(user)
    @user=user
    mail to: @user.email, subject: "Password Reset"
  end
end
