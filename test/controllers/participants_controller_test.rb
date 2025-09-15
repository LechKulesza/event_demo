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
end
