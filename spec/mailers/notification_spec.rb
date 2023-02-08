require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  let!(:user) { create(:user) }
  let!(:question) { create(:question) }

  describe "#notify_about_new_answer_for_question" do
    let!(:answer) { create(:answer, question: question) }
    let!(:mail) { NotificationMailer.notify_about_new_answer_for_question(user, question) }

    it "renders the headers" do
      expect(mail.subject).to eq("New answer")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["answer-on-questions@example.com"])
    end

    it "renders link to new answer" do
      have_link('Open', href: answer_url(answer))
    end
  end

  describe "#notify_about_change_question" do
    let!(:mail) { NotificationMailer.notify_about_change_question(user, question) }

    it "renders the headers" do
      expect(mail.subject).to eq("Question changed")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["answer-on-questions@example.com"])
    end

    it "renders link to changed question" do
      have_link('Open', href: question_url(question))
    end
  end
end
