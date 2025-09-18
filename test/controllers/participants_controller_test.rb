require "test_helper"

class ParticipantsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @participant = participants(:one)
  end

  test "should get index" do
    get participants_url
    assert_response :success
  end

  test "should get new" do
    get new_participant_url
    assert_response :success
  end

  test "should post create" do
    post participants_path, params: { participant: { first_name: "John", last_name: "Doe", email: "first@example.com" } }
    assert_response :redirect
  end

  test "should get show" do
    get participant_url(@participant)
    assert_response :success
  end

  test "should get scan" do
    get scan_participant_path(@participant)
    assert_response :redirect
  end

  test "should delete participant" do
    assert_difference("Participant.count", -1) do
      delete participant_path(@participant), headers: admin_headers
    end
    assert_redirected_to admin_participants_path
  end

  test "should clear all participants" do
    assert_difference("Participant.count", -Participant.count) do
      delete clear_all_participants_path, headers: admin_headers
    end
    assert_redirected_to admin_participants_path
  end

  test "should reset confirmed status for individual participant" do
    # Set participant as confirmed
    @participant.update(confirmed: true, qr_code: "some_qr_code")
    
    patch reset_confirmed_participant_path(@participant), headers: admin_headers
    
    @participant.reload
    assert_not @participant.confirmed
    assert_nil @participant.qr_code
    assert_redirected_to admin_participants_path
  end

  test "should reset scan status for individual participant" do
    # Set participant as scanned
    @participant.update(scanned_at: Time.current)
    
    patch reset_scan_participant_path(@participant), headers: admin_headers
    
    @participant.reload
    assert_nil @participant.scanned_at
    assert_redirected_to admin_participants_path
  end

  test "should handle reset confirmed for unconfirmed participant" do
    # Ensure participant is not confirmed
    @participant.update(confirmed: false)
    
    patch reset_confirmed_participant_path(@participant), headers: admin_headers
    
    assert_redirected_to admin_participants_path
  end

  test "should handle reset scan for unscanned participant" do
    # Ensure participant has no scan
    @participant.update(scanned_at: nil)
    
    patch reset_scan_participant_path(@participant), headers: admin_headers
    
    assert_redirected_to admin_participants_path
  end

  private

  def admin_headers
    # Basic auth headers for admin routes
    username = ENV["ADMIN_USER"] || "admin"
    password = ENV["ADMIN_PASSWORD"] || "password"
    { "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials(username, password) }
  end
end
