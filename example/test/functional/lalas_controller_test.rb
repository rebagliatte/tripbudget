require 'test_helper'

class LalasControllerTest < ActionController::TestCase
  setup do
    @lala = lalas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lalas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lala" do
    assert_difference('Lala.count') do
      post :create, lala: {  }
    end

    assert_redirected_to lala_path(assigns(:lala))
  end

  test "should show lala" do
    get :show, id: @lala
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lala
    assert_response :success
  end

  test "should update lala" do
    put :update, id: @lala, lala: {  }
    assert_redirected_to lala_path(assigns(:lala))
  end

  test "should destroy lala" do
    assert_difference('Lala.count', -1) do
      delete :destroy, id: @lala
    end

    assert_redirected_to lalas_path
  end
end
