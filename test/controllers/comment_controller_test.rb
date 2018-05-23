require 'test_helper'

class CommentControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get comment_new_url
    assert_response :success
  end

  test "should get create" do
    get comment_create_url
    assert_response :success
  end

  test "should get delete" do
    get comment_delete_url
    assert_response :success
  end

  test "should get modify" do
    get comment_modify_url
    assert_response :success
  end

  test "should get update" do
    get comment_update_url
    assert_response :success
  end

end
