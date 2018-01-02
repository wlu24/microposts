# $ rails generate integration_test following

require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other = users(:archer)
    log_in_as(@user)
  end

  test "following page" do
    get following_user_path(@user)

    # this line is included to make sure that the block below isn’t vacuously true
    #
    # In other words, if @user.following.empty? were true, not a single
    # assert_select would execute in the loop, leading the tests to pass and
    # thereby give us a false sense of security.
    assert_not @user.following.empty?

    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path(@user)

    # detailed explanation in the above test case
    assert_not @user.followers.empty?

    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end



  test "should follow a user the standard way" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, params: { followed_id: @other.id }
    end
  end

  test "should follow a user with Ajax" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, xhr: true, params: { followed_id: @other.id }
    end
  end

  test "should unfollow a user the standard way" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test "should unfollow a user with Ajax" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end
end
