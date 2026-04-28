require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "requires email_address" do
    user = User.new(password: "password123")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "can't be blank"
  end

  test "requires unique email_address" do
    duplicate = User.new(email_address: users(:alice).email_address, password: "password123")
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:email_address], "has already been taken"
  end

  test "normalizes email to lowercase and strips whitespace" do
    user = User.create!(email_address: "  Alice@EXAMPLE.ORG  ", password: "password123")
    assert_equal "alice@example.org", user.email_address
  end

  test "bmr returns nil without required fields" do
    user = User.new(email_address: "test@example.com", password: "password")
    assert_nil user.bmr
  end

  test "bmr calculates correctly for female" do
    alice = users(:alice)
    # Mifflin-St Jeor: (10 * 70) + (6.25 * 170) - (5 * 30) - 161 = 1451.5
    assert_in_delta 1451.5, alice.bmr, 0.1
  end

  test "bmr calculates correctly for male" do
    bob = users(:bob)
    # Mifflin-St Jeor: (10 * 80) + (6.25 * 180) - (5 * 25) + 5 = 1805.0
    assert_in_delta 1805.0, bob.bmr, 0.1
  end

  test "tdee returns nil without activity_level" do
    user = User.new(weight: 70, height: 170, age: 30, gender: :female)
    assert_nil user.tdee
  end

  test "tdee applies moderate multiplier" do
    alice = users(:alice)
    # moderate = 1.55
    expected = (alice.bmr * 1.55).round
    assert_equal expected, alice.tdee
  end

  test "tdee applies active multiplier" do
    bob = users(:bob)
    # active = 1.725
    expected = (bob.bmr * 1.725).round
    assert_equal expected, bob.tdee
  end
end
