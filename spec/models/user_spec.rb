require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associações" do
    it { should have_many(:sessions).dependent(:destroy) }
  end

  describe "validações" do
    it { should have_secure_password }
  end

  describe "normalização" do
    it "normaliza o email pra downcase e sem espaços" do
      user = create(:user, email_address: "  FER@BRECHO.COM  ")
      expect(user.email_address).to eq("fer@brecho.com")
    end
  end
end
