require "application_system_test_case"

class CalamitiesTest < ApplicationSystemTestCase
  setup do
    @calamity = calamities(:one)
  end

  test "visiting the index" do
    visit calamities_url
    assert_selector "h1", text: "Calamities"
  end

  test "creating a Calamity" do
    visit calamities_url
    click_on "New Calamity"

    click_on "Create Calamity"

    assert_text "Calamity was successfully created"
    click_on "Back"
  end

  test "updating a Calamity" do
    visit calamities_url
    click_on "Edit", match: :first

    click_on "Update Calamity"

    assert_text "Calamity was successfully updated"
    click_on "Back"
  end

  test "destroying a Calamity" do
    visit calamities_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Calamity was successfully destroyed"
  end
end
