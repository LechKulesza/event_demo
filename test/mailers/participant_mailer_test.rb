require "test_helper"

class ParticipantMailerTest < ActionMailer::TestCase
  test "confirmation_email" do
    participant = participants(:one)
    mail = ParticipantMailer.confirmation_email(participant)
    assert_equal 'Potwierdź swoją rejestrację na Accenture Community Meeting "25', mail.subject
    assert_equal [ participant.email ], mail.to
    assert_equal [ "no-reply@kw-house.com" ], mail.from
    assert_match participant.full_name, mail.body.encoded
  end
end
