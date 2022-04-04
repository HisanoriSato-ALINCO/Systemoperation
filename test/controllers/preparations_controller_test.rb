require "test_helper"

class PreparationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @preparation = preparations(:one)
  end

  test "should get index" do
    get preparations_url
    assert_response :success
  end

  test "should get new" do
    get new_preparation_url
    assert_response :success
  end

  test "should create preparation" do
    assert_difference('Preparation.count') do
      post preparations_url, params: { preparation: {  } }
    end

    assert_redirected_to preparation_url(Preparation.last)
  end

  test "should show preparation" do
    get preparation_url(@preparation)
    assert_response :success
  end

  test "should get edit" do
    get edit_preparation_url(@preparation)
    assert_response :success
  end

  test "should update preparation" do
    patch preparation_url(@preparation), params: { preparation: {  } }
    assert_redirected_to preparation_url(@preparation)
  end

  test "should destroy preparation" do
    assert_difference('Preparation.count', -1) do
      delete preparation_url(@preparation)
    end

    assert_redirected_to preparations_url
  end
end
