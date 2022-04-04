require "application_system_test_case"

class ExpeopleTest < ApplicationSystemTestCase
  setup do
    @experson = expeople(:one)
  end

  test "visiting the index" do
    visit expeople_url
    assert_selector "h1", text: "Expeople"
  end

  test "creating a Experson" do
    visit expeople_url
    click_on "New Experson"

    click_on "Create Experson"

    assert_text "Experson was successfully created"
    click_on "Back"
  end

  test "updating a Experson" do
    visit expeople_url
    click_on "Edit", match: :first

    click_on "Update Experson"

    assert_text "Experson was successfully updated"
    click_on "Back"
  end

  test "destroying a Experson" do
    visit expeople_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Experson was successfully destroyed"
  end
end
