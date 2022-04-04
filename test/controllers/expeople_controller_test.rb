require "test_helper"

class ExpeopleControllerTest < ActionDispatch::IntegrationTest
  setup do
    @experson = expeople(:one)
  end

  test "should get index" do
    get expeople_url
    assert_response :success
  end

  test "should get new" do
    get new_experson_url
    assert_response :success
  end

  test "should create experson" do
    assert_difference('Experson.count') do
      post expeople_url, params: { experson: {  } }
    end

    assert_redirected_to experson_url(Experson.last)
  end

  test "should show experson" do
    get experson_url(@experson)
    assert_response :success
  end

  test "should get edit" do
    get edit_experson_url(@experson)
    assert_response :success
  end

  test "should update experson" do
    patch experson_url(@experson), params: { experson: {  } }
    assert_redirected_to experson_url(@experson)
  end

  test "should destroy experson" do
    assert_difference('Experson.count', -1) do
      delete experson_url(@experson)
    end

    assert_redirected_to expeople_url
  end
end
