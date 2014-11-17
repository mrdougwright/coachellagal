require 'spec_helper'

describe UserSessionsController do
  describe "#create" do
    context "when login fails" do
      it "should display a message with login failure and render the login template" do
        stub_redirect_to_welcome
        post :create, user_session: {:email => 'test@test.com'}
        response.should redirect_to login_url
      end
    end
  end

  describe "#destroy" do
    let(:user) { create(:user) }
    let(:user_session) { UserSession.create :email => user.email, :password => 'password' }

    before do
      subject.stubs(:current_user_session).returns(user)
      stub_redirect_to_welcome
    end

    it "should display a message with logout success and render the login template" do
      post :destroy
      flash[:notice].should == I18n.t('logout_successful')
      response.should redirect_to login_url
    end
  end
end
