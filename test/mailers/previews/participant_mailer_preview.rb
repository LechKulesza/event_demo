# Preview all emails at http://localhost:3000/rails/mailers/participant_mailer
class ParticipantMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/participant_mailer/confirmation_email
  def confirmation_email
    ParticipantMailer.confirmation_email
  end
end
