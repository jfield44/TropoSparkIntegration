require 'test_helper'

class SmsRetrievalsControllerTest < ActionController::TestCase
  setup do
    @sms_retrieval = sms_retrievals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sms_retrievals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sms_retrieval" do
    assert_difference('SmsRetrieval.count') do
      post :create, sms_retrieval: { phone_number: @sms_retrieval.phone_number, room_id: @sms_retrieval.room_id }
    end

    assert_redirected_to sms_retrieval_path(assigns(:sms_retrieval))
  end

  test "should show sms_retrieval" do
    get :show, id: @sms_retrieval
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sms_retrieval
    assert_response :success
  end

  test "should update sms_retrieval" do
    patch :update, id: @sms_retrieval, sms_retrieval: { phone_number: @sms_retrieval.phone_number, room_id: @sms_retrieval.room_id }
    assert_redirected_to sms_retrieval_path(assigns(:sms_retrieval))
  end

  test "should destroy sms_retrieval" do
    assert_difference('SmsRetrieval.count', -1) do
      delete :destroy, id: @sms_retrieval
    end

    assert_redirected_to sms_retrievals_path
  end
end
