class ParticipantsController < ApplicationController
  before_action :set_participant, only: [:show, :scan, :confirm]
  
  # Protect admin routes with basic authentication
  http_basic_authenticate_with name: ENV['ADMIN_USER'] || 'admin', 
                               password: ENV['ADMIN_PASSWORD'] || 'password', 
                               only: [:admin, :scanner, :process_scan]

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

  def scanner
    # Admin page for scanning QR codes
  end

  def process_scan
    # Extract participant ID from scanned URL
    scanned_url = params[:scanned_url]
    
    if scanned_url.include?('/participants/') && scanned_url.include?('/scan')
      participant_id = scanned_url.match(/\/participants\/(\d+)\/scan/)[1]
      @participant = Participant.find(participant_id)
      
      if @participant.scanned_at.present?
        flash[:alert] = "#{@participant.full_name} - Ten kod QR został już zeskanowany."
      else
        @participant.update(scanned_at: Time.current)
        flash[:notice] = "#{@participant.full_name} - Obecność została zarejestrowana!"
      end
    else
      flash[:alert] = "Nieprawidłowy kod QR"
    end
    
    redirect_to scanner_participants_path
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Nie znaleziono uczestnika"
    redirect_to scanner_participants_path
  end

  private

  def set_participant
    @participant = Participant.find(params[:id])
  end

  def participant_params
    params.require(:participant).permit(:first_name, :last_name, :email)
  end
end
