require 'test_helper'

class DeviceFilesControllerTest < ActionController::TestCase
  setup do
    @device_file = device_files(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:device_files)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create device_file" do
    assert_difference('DeviceFile.count') do
      post :create, device_file: { device_id: @device_file.device_id, title_t: @device_file.title }
    end

    assert_redirected_to device_file_path(assigns(:device_file))
  end

  test "should show device_file" do
    get :show, id: @device_file
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @device_file
    assert_response :success
  end

  test "should update device_file" do
    put :update, id: @device_file, device_file: { device_id: @device_file.device_id, title_t: @device_file.title }
    assert_redirected_to device_file_path(assigns(:device_file))
  end

  test "should destroy device_file" do
    assert_difference('DeviceFile.count', -1) do
      delete :destroy, id: @device_file
    end

    assert_redirected_to device_files_path
  end
end
