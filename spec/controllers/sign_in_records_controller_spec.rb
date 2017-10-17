require 'rails_helper'

RSpec.describe SignInRecordsController, type: :controller do

  login_user


  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
    it "renders the :index view" do
      get :index
      expect(response).to render_template :index
    end
    it "sets the page title" do
      get :index
      expect(assigns(:title)).to eq('Sign in records')
    end
    it "populates an array of records" do
      record = FactoryGirl.create(:default_sign_in_record)
      get :index
      expect(assigns(:sign_in_records)).to include(record)
    end
  end


  describe "GET #show" do
    let(:record) { FactoryGirl.create(:default_sign_in_record) }
    it "shows a record" do
      get(:show, params: { id: record.id })
      expect(response).to render_template :show
      expect(response).to have_http_status(:success)
      expect(assigns(:sign_in_record).id).to eq(record.id)
      expect(assigns(:title)).to eq('Sign in record details')
    end
    it "raises an exception for a missing record" do
      assert_raises(ActiveRecord::RecordNotFound) do
        get(:show, params: { id: 99 })
      end
    end
  end


end
