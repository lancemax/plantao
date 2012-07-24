require 'test_helper'

class PushTimesControllerTest < ActionController::TestCase
  setup do
    @push_time = push_times(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:push_times)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create push_time" do
    assert_difference('PushTime.count') do
      post :create, push_time: { name: @push_time.name, value: @push_time.value }
    end

    assert_redirected_to push_time_path(assigns(:push_time))
  end

  test "should show push_time" do
    get :show, id: @push_time
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @push_time
    assert_response :success
  end

  test "should update push_time" do
    put :update, id: @push_time, push_time: { name: @push_time.name, value: @push_time.value }
    assert_redirected_to push_time_path(assigns(:push_time))
  end

  test "should destroy push_time" do
    assert_difference('PushTime.count', -1) do
      delete :destroy, id: @push_time
    end

    assert_redirected_to push_times_path
  end
end
