require "test_helper"

class MsystemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @msystem = msystems(:one)
  end

  test "should get index" do
    get msystems_url
    assert_response :success
  end

  test "should get new" do
    get new_msystem_url
    assert_response :success
  end

  test "should create msystem" do
    assert_difference('Msystem.count') do
      post msystems_url, params: { msystem: {  } }
    end

    assert_redirected_to msystem_url(Msystem.last)
  end

  test "should show msystem" do
    get msystem_url(@msystem)
    assert_response :success
  end

  test "should get edit" do
    get edit_msystem_url(@msystem)
    assert_response :success
  end

  test "should update msystem" do
    patch msystem_url(@msystem), params: { msystem: {  } }
    assert_redirected_to msystem_url(@msystem)
  end

  test "should destroy msystem" do
    assert_difference('Msystem.count', -1) do
      delete msystem_url(@msystem)
    end

    assert_redirected_to msystems_url
  end
end
