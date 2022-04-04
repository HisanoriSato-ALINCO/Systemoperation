require "application_system_test_case"

class MsystemsTest < ApplicationSystemTestCase
  setup do
    @msystem = msystems(:one)
  end

  test "visiting the index" do
    visit msystems_url
    assert_selector "h1", text: "Msystems"
  end

  test "creating a Msystem" do
    visit msystems_url
    click_on "New Msystem"

    click_on "Create Msystem"

    assert_text "Msystem was successfully created"
    click_on "Back"
  end

  test "updating a Msystem" do
    visit msystems_url
    click_on "Edit", match: :first

    click_on "Update Msystem"

    assert_text "Msystem was successfully updated"
    click_on "Back"
  end

  test "destroying a Msystem" do
    visit msystems_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Msystem was successfully destroyed"
  end
end
