require "test_helper"

class AiConversationTest < ActiveSupport::TestCase
  # Validations

  test "valid conversation with context" do
    conv = users(:one).ai_conversations.build(context: "general")
    assert conv.valid?
  end

  test "invalid without context" do
    conv = users(:one).ai_conversations.build
    assert_not conv.valid?
    assert_includes conv.errors[:context], "can't be blank"
  end

  # Enums

  test "context enum includes expected values" do
    assert_equal %w[workout nutrition general], AiConversation.contexts.keys
  end

  test "context predicate methods work" do
    assert ai_conversations(:workout_chat).context_workout?
    assert ai_conversations(:nutrition_chat).context_nutrition?
  end

  # before_create callback

  test "messages initializes to empty array on create" do
    conv = users(:one).ai_conversations.create!(context: "general")
    assert_equal [], conv.messages
  end

  # add_message

  test "add_message appends to messages array" do
    conv = users(:one).ai_conversations.create!(context: "general")
    conv.add_message(role: "user", content: "Hello")
    assert_equal 1, conv.reload.messages.length
  end

  test "add_message stores role and content" do
    conv = users(:one).ai_conversations.create!(context: "general")
    conv.add_message(role: "user", content: "Test message")
    msg = conv.reload.messages.first
    assert_equal "user", msg["role"]
    assert_equal "Test message", msg["content"]
  end

  test "add_message stores timestamp" do
    conv = users(:one).ai_conversations.create!(context: "general")
    conv.add_message(role: "assistant", content: "Hi there")
    msg = conv.reload.messages.first
    assert msg.key?("timestamp")
  end

  test "add_message appends multiple messages" do
    conv = users(:one).ai_conversations.create!(context: "general")
    conv.add_message(role: "user", content: "First")
    conv.add_message(role: "assistant", content: "Second")
    assert_equal 2, conv.reload.messages.length
  end

  # last_message

  test "last_message returns nil when messages is empty" do
    conv = users(:one).ai_conversations.create!(context: "general")
    assert_nil conv.last_message
  end

  test "last_message returns the most recently added message" do
    conv = users(:one).ai_conversations.create!(context: "general")
    conv.add_message(role: "user", content: "Hello")
    conv.add_message(role: "assistant", content: "Hi there")
    last = conv.reload.last_message
    assert_equal "assistant", last["role"]
  end

  # message_count

  test "message_count returns 0 for new conversation" do
    conv = users(:one).ai_conversations.create!(context: "general")
    assert_equal 0, conv.message_count
  end

  test "message_count returns correct count for conversation with messages" do
    conv = users(:one).ai_conversations.create!(context: "general")
    conv.add_message(role: "user", content: "First")
    conv.add_message(role: "assistant", content: "Second")
    assert_equal 2, conv.reload.message_count
  end

  # Associations

  test "belongs to user" do
    assert_equal users(:one), ai_conversations(:workout_chat).user
  end
end
