require 'test_helper'

class GoodTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:mysize1)
    @kickspost = kicksposts(:orange)
    @comment = comments(:apple)
    @good = Good.new(user_id: @user.id, post_id: @kickspost.id, post_type: "Kickspost")
    @good2 = Good.new(user_id: @user.id, post_id: @comment.id, post_type: "Comment")
  end

  test "should be valid" do
    assert @good.valid?
    assert @good2.valid?
  end

  test "should require a user_id" do
    @good.user_id = nil
    assert_not @good.valid?
  end

  test "should require a post_id" do
    @good.post_id = nil
    assert_not @good.valid?
  end

  test "should require a post_type" do
    @good.post_type = nil
    assert_not @good.valid?
  end
end
