require "test_helper"

class ParticipantsControllerTest < ActionDispatch::IntegrationTest
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
    get participant_url(participants(:one))
    assert_response :success
  end

  test "should get scan" do
    get scan_participant_path(participants(:one))
    assert_response :redirect
  end

  test "should delete participant when authenticated as admin" do
    participant = participants(:one)
    
    # Set up basic auth credentials
    basic_auth_credentials = ActionController::HttpAuthentication::Basic.encode_credentials("admin", "password")
    
    assert_difference('Participant.count', -1) do
      delete participant_path(participant), headers: { 'HTTP_AUTHORIZATION' => basic_auth_credentials }
    end
    
    assert_redirected_to admin_participants_path
    assert_match /został usunięty/, flash[:notice]
  end

  test "should require authentication for delete participant" do
    participant = participants(:one)
    
    delete participant_path(participant)
    assert_response :unauthorized
  end

  test "should clear all participants when authenticated as admin" do
    # Set up basic auth credentials
    basic_auth_credentials = ActionController::HttpAuthentication::Basic.encode_credentials("admin", "password")
    
    # Ensure we have some participants
    assert Participant.count > 0
    
    delete clear_all_participants_path, headers: { 'HTTP_AUTHORIZATION' => basic_auth_credentials }
    
    assert_equal 0, Participant.count
    assert_redirected_to admin_participants_path
    assert_match /Usunięto wszystkich uczestników/, flash[:notice]
  end

  test "should require authentication for clear all participants" do
    delete clear_all_participants_path
    assert_response :unauthorized
  end
end
