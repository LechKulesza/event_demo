class Participant < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, uniqueness: true

  after_create :send_confirmation_email
  after_update :generate_qr_code_if_confirmed

  scope :confirmed, -> { where(confirmed: true) }
  scope :scanned, -> { where.not(scanned_at: nil) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def qr_code_data
    # Use configured host from action_mailer or fallback to localhost for development
    host = Rails.application.config.action_mailer.default_url_options[:host] rescue "localhost:3000"
    protocol = Rails.env.production? ? "https" : "http"

    Rails.application.routes.url_helpers.scan_participant_url(self, host: "#{protocol}://#{host}")
  end

  def self.attendance_percentage
    return 0 if confirmed.count == 0
    (scanned.count.to_f / confirmed.count * 100).round(2)
  end

  def safe_qr_code_html
    return nil unless qr_code.present?

    # Validate that the content is a valid SVG from our QR code generation
    if qr_code.start_with?('<?xml version="1.0"') && qr_code.include?("<svg") && qr_code.include?("</svg>")
      qr_code.html_safe
    else
      # If invalid, regenerate the QR code
      generate_qr_code
      qr_code.html_safe
    end
  end

  private

  def generate_qr_code_if_confirmed
    if confirmed? && qr_code.blank?
      generate_qr_code
    end
  end

  def generate_qr_code
    require "rqrcode"

    qr = RQRCode::QRCode.new(qr_code_data)
    self.update_column(:qr_code, qr.as_svg(
      offset: 0,
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 6,
      standalone: true
    ))
  end

  def send_confirmation_email
    ParticipantMailer.confirmation_email(self).deliver_later
  end
end
