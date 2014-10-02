require 'test_helper'

class DeviceEventsControllerTest < ActionController::TestCase
  setup do
    @device_event = device_events(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:device_events)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create device_event" do
    assert_difference('DeviceEvent.count') do
      post :create, device_event: { device_id: @device_event.device_id, duration_i: @device_event.duration, event_tdt: @device_event.event_dtg, event_geo_lat: @device_event.event_geo_lat, event_geo_long: @device_event.event_geo_long, title_t: @device_event.title }
    end

    assert_redirected_to device_event_path(assigns(:device_event))
  end

  test "should show device_event" do
    get :show, id: @device_event
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @device_event
    assert_response :success
  end

  test "should update device_event" do
    put :update, id: @device_event, device_event: { device_id: @device_event.device_id, duration_i: @device_event.duration, event_tdt: @device_event.event_dtg, event_geo_lat: @device_event.event_geo_lat, event_geo_long: @device_event.event_geo_long, title_t: @device_event.title }
    assert_redirected_to device_event_path(assigns(:device_event))
  end

  test "should destroy device_event" do
    assert_difference('DeviceEvent.count', -1) do
      delete :destroy, id: @device_event
    end

    assert_redirected_to device_events_path
  end
end
