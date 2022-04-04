require "application_system_test_case"

class OsystemsTest < ApplicationSystemTestCase
  setup do
    @osystem = osystems(:one)
  end

  test "visiting the index" do
    visit osystems_url
    assert_selector "h1", text: "Osystems"
  end

  test "creating a Osystem" do
    visit osystems_url
    click_on "New Osystem"

    click_on "Create Osystem"

    assert_text "Osystem was successfully created"
    click_on "Back"
  end

  test "updating a Osystem" do
    visit osystems_url
    click_on "Edit", match: :first

    click_on "Update Osystem"

    assert_text "Osystem was successfully updated"
    click_on "Back"
  end

  test "destroying a Osystem" do
    visit osystems_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Osystem was successfully destroyed"
  end
end
