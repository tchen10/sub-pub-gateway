FactoryBot.define do
  factory :user, class: User do
    # required
    email 'user@email.com'

    sequence :phone_number do |phone_number|
      "#{Random.rand(000000000..999999999)}"
    end

    sequence :key do |key|
      "#{Random.rand(1..1000)}"
    end

    password 'secret password'

    # optional
    full_name ''
    metadata ''
    account_key ''
  end
end