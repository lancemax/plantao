require 'test_helper'

class HospitalsControllerTest < ActionController::TestCase
  setup do
    @hospital = hospitals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hospitals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hospital" do
    assert_difference('Hospital.count') do
      post :create, hospital: { address: @hospital.address, city_id: @hospital.city_id, complement: @hospital.complement, description: @hospital.description, name: @hospital.name, neighborhood: @hospital.neighborhood, photo: @hospital.photo, state_id: @hospital.state_id, zip_code: @hospital.zip_code }
    end

    assert_redirected_to hospital_path(assigns(:hospital))
  end

  test "should show hospital" do
    get :show, id: @hospital
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @hospital
    assert_response :success
  end

  test "should update hospital" do
    put :update, id: @hospital, hospital: { address: @hospital.address, city_id: @hospital.city_id, complement: @hospital.complement, description: @hospital.description, name: @hospital.name, neighborhood: @hospital.neighborhood, photo: @hospital.photo, state_id: @hospital.state_id, zip_code: @hospital.zip_code }
    assert_redirected_to hospital_path(assigns(:hospital))
  end

  test "should destroy hospital" do
    assert_difference('Hospital.count', -1) do
      delete :destroy, id: @hospital
    end

    assert_redirected_to hospitals_path
  end
end
