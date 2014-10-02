require 'test_helper'

class UserFiltersControllerTest < ActionController::TestCase
  setup do
    @user_filter = user_filters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_filters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_filter" do
    assert_difference('UserFilter.count') do
      post :create, user_filter: { create_tdt: @user_filter.create_tdt, filters: @user_filter.filters, last_ran_tdt: @user_filter.last_ran_tdt, queries: @user_filter.queries, title_t: @user_filter.title_t, user_id: @user_filter.user_id }
    end

    assert_redirected_to user_filter_path(assigns(:user_filter))
  end

  test "should show user_filter" do
    get :show, id: @user_filter
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_filter
    assert_response :success
  end

  test "should update user_filter" do
    put :update, id: @user_filter, user_filter: { create_tdt: @user_filter.create_tdt, filters: @user_filter.filters, last_ran_tdt: @user_filter.last_ran_tdt, queries: @user_filter.queries, title_t: @user_filter.title_t, user_id: @user_filter.user_id }
    assert_redirected_to user_filter_path(assigns(:user_filter))
  end

  test "should destroy user_filter" do
    assert_difference('UserFilter.count', -1) do
      delete :destroy, id: @user_filter
    end

    assert_redirected_to user_filters_path
  end
end
