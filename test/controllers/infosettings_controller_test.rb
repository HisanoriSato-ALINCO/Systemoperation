require "test_helper"

class InfosettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @infosetting = infosettings(:one)
  end

  test "should get index" do
    get infosettings_url
    assert_response :success
  end

  test "should get new" do
    get new_infosetting_url
    assert_response :success
  end

  test "should create infosetting" do
    assert_difference('Infosetting.count') do
      post infosettings_url, params: { infosetting: {  } }
    end

    assert_redirected_to infosetting_url(Infosetting.last)
  end

  test "should show infosetting" do
    get infosetting_url(@infosetting)
    assert_response :success
  end

  test "should get edit" do
    get edit_infosetting_url(@infosetting)
    assert_response :success
  end

  test "should update infosetting" do
    patch infosetting_url(@infosetting), params: { infosetting: {  } }
    assert_redirected_to infosetting_url(@infosetting)
  end

  test "should destroy infosetting" do
    assert_difference('Infosetting.count', -1) do
      delete infosetting_url(@infosetting)
    end

    assert_redirected_to infosettings_url
  end
end
