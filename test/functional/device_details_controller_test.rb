require 'test_helper'

class DeviceDetailsControllerTest < ActionController::TestCase
  setup do
    @device_detail = device_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:device_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create device_detail" do
    assert_difference('DeviceDetail.count') do
      post :create, device_detail: { device_id: @device_detail.device_id, first_seen_tdt: @device_detail.first_seen, ip_addr: @device_detail.ip_addr, mac_addr: @device_detail.mac_addr, make: @device_detail.make, model: @device_detail.model, name: @device_detail.name, os: @device_detail.os, os_version: @device_detail.os_version }
    end

    assert_redirected_to device_detail_path(assigns(:device_detail))
  end

  test "should show device_detail" do
    get :show, id: @device_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @device_detail
    assert_response :success
  end

  test "should update device_detail" do
    put :update, id: @device_detail, device_detail: { device_id: @device_detail.device_id, first_seen_tdt: @device_detail.first_seen, ip_addr: @device_detail.ip_addr, mac_addr: @device_detail.mac_addr, make: @device_detail.make, model: @device_detail.model, name: @device_detail.name, os: @device_detail.os, os_version: @device_detail.os_version }
    assert_redirected_to device_detail_path(assigns(:device_detail))
  end

  test "should destroy device_detail" do
    assert_difference('DeviceDetail.count', -1) do
      delete :destroy, id: @device_detail
    end

    assert_redirected_to device_details_path
  end
end
