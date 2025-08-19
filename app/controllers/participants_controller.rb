class ParticipantsController < ApplicationController
  before_action :set_participant, only: [:show, :scan, :confirm]

  def index
    @participants = Participant.all
    @confirmed_count = Participant.confirmed.count
    @scanned_count = Participant.scanned.count
    @attendance_percentage = Participant.attendance_percentage
  end

  def new
    @participant = Participant.new
  end

  def create
    @participant = Participant.new(participant_params)
    
    if @participant.save
      redirect_to @participant, notice: 'Rejestracja została zakończona pomyślnie! Sprawdź email w celu potwierdzenia.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # Show participant details and QR code
  end

  def scan
    if @participant.scanned_at.present?
      redirect_to @participant, alert: 'Ten kod QR został już zeskanowany.'
    else
      @participant.update(scanned_at: Time.current)
      redirect_to @participant, notice: 'Obecność została zarejestrowana!'
    end
  end

  def confirm
    if @participant.confirmed?
      redirect_to @participant, notice: 'Rejestracja została już wcześniej potwierdzona!'
    else
      @participant.update(confirmed: true)
      redirect_to @participant, notice: 'Rejestracja została potwierdzona! Twój kod QR jest gotowy.'
    end
  end

  def admin
    @participants = Participant.all
    @statistics = {
      total: Participant.count,
      confirmed: Participant.confirmed.count,
      scanned: Participant.scanned.count,
      attendance_percentage: Participant.attendance_percentage
    }
  end

  private

  def set_participant
    @participant = Participant.find(params[:id])
  end

  def participant_params
    params.require(:participant).permit(:first_name, :last_name, :email)
  end
end
