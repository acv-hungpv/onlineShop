class ResetPasswordMailer < ApplicationMailer
  def reset_password(user)
    @user = user
    mail(to: @user.email, subject: "Reset password")
  end
end
