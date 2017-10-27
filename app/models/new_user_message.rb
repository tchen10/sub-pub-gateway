class NewUserMessage
  include ActiveModel::Validations

  attr_reader :email, :account_key

  validates :email, presence: true
  validates :account_key, presence: true

  def create_from_json(message)
    message = JSON.parse(message)
    @email = message['email']
    @account_key = message['account_key']
    self
  end
end