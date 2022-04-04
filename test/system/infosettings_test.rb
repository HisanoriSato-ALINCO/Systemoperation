require "application_system_test_case"

class InfosettingsTest < ApplicationSystemTestCase
  setup do
    @infosetting = infosettings(:one)
  end

  test "visiting the index" do
    visit infosettings_url
    assert_selector "h1", text: "Infosettings"
  end

  test "creating a Infosetting" do
    visit infosettings_url
    click_on "New Infosetting"

    click_on "Create Infosetting"

    assert_text "Infosetting was successfully created"
    click_on "Back"
  end

  test "updating a Infosetting" do
    visit infosettings_url
    click_on "Edit", match: :first

    click_on "Update Infosetting"

    assert_text "Infosetting was successfully updated"
    click_on "Back"
  end

  test "destroying a Infosetting" do
    visit infosettings_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Infosetting was successfully destroyed"
  end
end
