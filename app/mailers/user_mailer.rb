class UserMailer < ApplicationMailer

  def test_email
    mail(to: 'dom@marek-piechocki.pl',
         subject: 'Test')
  end

  def broadcast_info(user_id:, broadcast_id:)
    @user = User.find(user_id)
    @broadcast = Broadcast.find(broadcast_id)

    mail(to: 'dom@marek-piechocki.pl',
         subject: "Transmisja zebrania: #{@broadcast.day_label}")
  end

end
