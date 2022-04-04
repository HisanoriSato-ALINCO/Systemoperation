require "application_system_test_case"

class PreparationsTest < ApplicationSystemTestCase
  setup do
    @preparation = preparations(:one)
  end

  test "visiting the index" do
    visit preparations_url
    assert_selector "h1", text: "Preparations"
  end

  test "creating a Preparation" do
    visit preparations_url
    click_on "New Preparation"

    click_on "Create Preparation"

    assert_text "Preparation was successfully created"
    click_on "Back"
  end

  test "updating a Preparation" do
    visit preparations_url
    click_on "Edit", match: :first

    click_on "Update Preparation"

    assert_text "Preparation was successfully updated"
    click_on "Back"
  end

  test "destroying a Preparation" do
    visit preparations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Preparation was successfully destroyed"
  end
end
