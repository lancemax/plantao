require 'test_helper'

class StatusRequestsControllerTest < ActionController::TestCase
  setup do
    @status_request = status_requests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:status_requests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create status_request" do
    assert_difference('StatusRequest.count') do
      post :create, status_request: { name: @status_request.name }
    end

    assert_redirected_to status_request_path(assigns(:status_request))
  end

  test "should show status_request" do
    get :show, id: @status_request
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @status_request
    assert_response :success
  end

  test "should update status_request" do
    put :update, id: @status_request, status_request: { name: @status_request.name }
    assert_redirected_to status_request_path(assigns(:status_request))
  end

  test "should destroy status_request" do
    assert_difference('StatusRequest.count', -1) do
      delete :destroy, id: @status_request
    end

    assert_redirected_to status_requests_path
  end
end
