require 'rails_helper'

RSpec.describe UsersController, type: :request do
  include Warden::Test::Helpers

  before do
    @first_user = User.create!(name: 'sambeck', email: 'sambeck@outlook.com', password: 'todoterreno')
    login_as(@first_user, scope: :user)
  end

  describe 'GET #index' do
    before do
      get users_path
    end

    it 'returns a successful response' do
      expect(response).to be_successful
    end

    it 'displays the correct template and content' do
      expect(response).to render_template(:index)
    end

    it 'displays the correct title' do
      expect(response.body).to include('Users')
    end

    it 'displays the correct name' do
      expect(response.body).to include('sambeck')
    end
  end
end
