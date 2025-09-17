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

  test "should reset all statuses" do
    # Set up some participants with confirmed and scanned statuses
    participants(:one).update(confirmed: true, scanned_at: Time.current)
    participants(:two).update(confirmed: true)
    
    patch reset_statuses_participants_path, headers: admin_headers
    
    # Verify all statuses are reset
    Participant.all.each do |participant|
      participant.reload
      assert_not participant.confirmed
      assert_nil participant.scanned_at
      assert_nil participant.qr_code
    end
    
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
