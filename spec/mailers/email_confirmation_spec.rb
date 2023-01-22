require "rails_helper"

RSpec.describe EmailConfirmationMailer, type: :mailer do
  describe "#email_confirmation" do
    let!(:confirmed_email) { create(:confirmed_email) }
    let(:mail) { EmailConfirmationMailer.email_confirmation(confirmed_email) }
    let!(:confirmation_link) { confirm_confirmed_emails_url(confirmation_token: confirmed_email.confirmation_token) }

    it "renders the headers" do
      expect(mail.subject).to eq("Confirm your email")
      expect(mail.to).to eq([confirmed_email.email])
      expect(mail.from).to eq(["answer-on-questions@example.com"])
    end

    it "have confirmation link" do
      expect(mail.body.encoded).to have_link('Confirm EMAIL', href: confirmation_link)
    end
  end
end
