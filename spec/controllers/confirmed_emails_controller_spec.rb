require 'rails_helper'

RSpec.describe ConfirmedEmailsController, type: :controller do
  describe 'GET #new' do
    before { get :new, params: { provider: 'telegram', uid: "123" } }

    it 'assigns a params[:provider] to @provider' do
      expect(assigns(:provider)).to eq 'telegram'
    end

    it 'assigns a params[:uid] to @uid' do
      expect(assigns(:uid)).to eq "123"
    end

    it 'assigns a new ConfirmedEmail to @confirmed_email' do
      expect(assigns(:confirmed_email)).to be_a_new(ConfirmedEmail)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    subject(:create_confirmed_email) do
      post :create, params: { confirmed_email: { provider: 'telegram', uid: '123', email: 'user@example.com' } }
    end

    context 'when exists confirmed email' do
      let!(:confirmed_email) { create(:confirmed_email, provider: 'telegram', uid: '123', email: 'user@example.com') }

      it 'assigns a existing confirmed email to @confirmed_email' do
        create_confirmed_email
        expect(assigns(:confirmed_email)).to eq confirmed_email
      end
    end

    context 'when not exists confirmed email' do
      it 'create new ConfirmedEmail' do
        expect { create_confirmed_email }.to change { ConfirmedEmail.count }.by(1)
      end

      it 'assigns new confirmed email to @confirmed_email' do
        create_confirmed_email
        created_confirmed_email = ConfirmedEmail.last
        expect(created_confirmed_email).to_not eq nil
        expect(assigns(:confirmed_email)).to eq created_confirmed_email
      end
    end

    context 'when confirmed email saved' do
      let(:mail) { double('Mail') }
      let!(:confirmed_email) { create(:confirmed_email, provider: 'telegram', uid: '123', email: 'user@example.com') }

      it 'send confirmation on email' do
        expect(EmailConfirmationMailer).to receive(:email_confirmation).with(confirmed_email).and_return(mail)
        expect(mail).to receive(:deliver_now)
        create_confirmed_email
      end

      it 'redirect to new_user_session_path' do
        create_confirmed_email
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when confirmed email not saved' do
      subject(:create_invalid_confirmed_email) do
        post :create, params: { confirmed_email: { provider: 'telegram', uid: '123', email: nil } }
      end

      before do
        create_invalid_confirmed_email
      end

      it 'assigns a confirmed email provider to @provider' do
        expect(assigns(:provider)).to eq 'telegram'
      end

      it 'assigns a confirmed email uid to @uid' do
        expect(assigns(:uid)).to eq "123"
      end

      it 'rerenders new view' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #confirm' do
    subject(:get_confirm) { get :confirm, params: { confirmation_token: '111' } }

    context 'when confirmed email exist' do
      let!(:confirmed_email) { create(:confirmed_email, provider: 'telegram', uid: '1', email: 'user@example.com', confirmation_token: '111') }

      context 'when user exists' do
        let!(:user) { create(:user, email: 'user@example.com') }

        it 'create authorization for user' do
          expect { get_confirm }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          get_confirm
          authorization = user.authorizations.first

          expect(authorization.provider).to eq confirmed_email.provider
          expect(authorization.uid).to eq confirmed_email.uid
        end
      end

      context 'when user does not exist' do
        it 'create new user' do
          expect { get_confirm }.to change(User, :count).by(1)
        end

        it 'create authorization for new user with provider and uid' do
          get_confirm
          authorization = User.last.authorizations.first

          expect(authorization.provider).to eq confirmed_email.provider
          expect(authorization.uid).to eq confirmed_email.uid
        end
      end

      it 'destroy confirmed email' do
        expect { get_confirm }.to change(ConfirmedEmail, :count).by(-1)
      end

      it 'redirect to new_user_session_path (email is confirmed)' do
        get_confirm
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when confirmed email not exist' do
      let!(:confirmed_email) { create(:confirmed_email, confirmation_token: '222') }

      it 'redirect to new_user_session_path (invalid confirmation token)' do
        get_confirm
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
