require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "#digest" do
    let(:user) { create(:user) }
    let(:mail) { DailyDigestMailer.digest(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Daily digest")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["answer-on-questions@example.com"])
    end
  end
end
