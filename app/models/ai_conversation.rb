class AiConversation < ApplicationRecord
  belongs_to :user

  enum :context, {
    workout: "workout",
    nutrition: "nutrition",
    general: "general"
  }, prefix: true

  validates :context, presence: true

  before_create :initialize_messages

  def add_message(role:, content:)
    self.messages ||= []
    self.messages << { role: role, content: content, timestamp: Time.current.iso8601 }
    save
  end

  def last_message
    messages&.last
  end

  def message_count
    messages&.size || 0
  end

  private

  def initialize_messages
    self.messages ||= []
  end
end
