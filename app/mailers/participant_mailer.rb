class ParticipantMailer < ApplicationMailer
  def confirmation_email(participant)
    @participant = participant
    @confirmation_url = confirm_participant_url(@participant)

    mail(
      to: @participant.email,
      subject: 'Potwierdź swoją rejestrację na Accenture Community Meeting "25'
    )
  end
end
