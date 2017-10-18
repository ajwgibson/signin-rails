require 'rails_helper'

RSpec.describe SignInRecordImportsController, type: :controller do

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
      expect(assigns(:title)).to eq('Sign in record imports')
    end
    it "populates an array of records" do
      record = FactoryGirl.create(:pending_sign_in_record_import)
      get :index
      expect(assigns(:sign_in_record_imports)).to include(record)
    end
    it "orders records with most recent first" do
      result = double("result")
      expect(SignInRecordImport).to receive(:order).with(created_at: :desc).and_return(result)
      allow(result).to receive(:order)
      allow(result).to receive(:page)
      get :index
    end
    it "pages the records" do
      result = double("result")
      allow(SignInRecordImport).to receive(:order).and_return(result)
      expect(result).to receive(:page).with('2')
      get :index, params: { page: 2 }
    end
  end


  describe "GET #show" do
    let(:record) { FactoryGirl.create(:pending_sign_in_record_import) }
    it "shows a record" do
      get(:show, params: { id: record.id })
      expect(response).to render_template :show
      expect(response).to have_http_status(:success)
      expect(assigns(:sign_in_record_import).id).to eq(record.id)
      expect(assigns(:title)).to eq('Sign in record import details')
    end
    it "raises an exception for a missing record" do
      assert_raises(ActiveRecord::RecordNotFound) do
        get(:show, params: { id: 99 })
      end
    end
  end


  describe "GET #new" do
    it "renders a blank form" do
      get :new
      expect(response).to render_template :new
      expect(response).to have_http_status(:success)
      expect(assigns(:sign_in_record_import).id).to be_nil
      expect(assigns(:title)).to eq('Import sign in records')
      expect(assigns(:cancel_path)).to eq(sign_in_record_imports_path)
    end
  end


end
