require "test_helper"

class CalamitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @calamity = calamities(:one)
  end

  test "should get index" do
    get calamities_url
    assert_response :success
  end

  test "should get new" do
    get new_calamity_url
    assert_response :success
  end

  test "should create calamity" do
    assert_difference('Calamity.count') do
      post calamities_url, params: { calamity: {  } }
    end

    assert_redirected_to calamity_url(Calamity.last)
  end

  test "should show calamity" do
    get calamity_url(@calamity)
    assert_response :success
  end

  test "should get edit" do
    get edit_calamity_url(@calamity)
    assert_response :success
  end

  test "should update calamity" do
    patch calamity_url(@calamity), params: { calamity: {  } }
    assert_redirected_to calamity_url(@calamity)
  end

  test "should destroy calamity" do
    assert_difference('Calamity.count', -1) do
      delete calamity_url(@calamity)
    end

    assert_redirected_to calamities_url
  end
end
