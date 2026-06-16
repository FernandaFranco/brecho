module AuthenticationHelper
  def sign_in(user = nil)
    user ||= create(:user)
    post session_url, params: { email_address: user.email_address, password: "password123" }
    user
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelper, type: :request
end
