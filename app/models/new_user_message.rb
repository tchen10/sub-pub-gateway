class NewUserMessage
  include ActiveModel::Validations

  attr_reader :email, :key

  validates :email, presence: true
  validates :key, presence: true

  def create_from_json(message)
    message = JSON.parse(message)
    @email = message['email']
    @key = message['key']
    self
  end
end