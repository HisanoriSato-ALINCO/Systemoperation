require "test_helper"

class OsystemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @osystem = osystems(:one)
  end

  test "should get index" do
    get osystems_url
    assert_response :success
  end

  test "should get new" do
    get new_osystem_url
    assert_response :success
  end

  test "should create osystem" do
    assert_difference('Osystem.count') do
      post osystems_url, params: { osystem: {  } }
    end

    assert_redirected_to osystem_url(Osystem.last)
  end

  test "should show osystem" do
    get osystem_url(@osystem)
    assert_response :success
  end

  test "should get edit" do
    get edit_osystem_url(@osystem)
    assert_response :success
  end

  test "should update osystem" do
    patch osystem_url(@osystem), params: { osystem: {  } }
    assert_redirected_to osystem_url(@osystem)
  end

  test "should destroy osystem" do
    assert_difference('Osystem.count', -1) do
      delete osystem_url(@osystem)
    end

    assert_redirected_to osystems_url
  end
end
