require 'rails_helper'

RSpec.describe SignInRecordsController, type: :controller do

  login_user


  describe "GET #index" do
    let(:records) { double("records") }
    before do
      allow(records).to receive(:order).and_return(records)
      allow(records).to receive(:page)
    end
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
    it "populates an array of room names" do
      expect(SignInRecord).to receive(:room_list).and_return(['a','b'])
      get :index
      expect(assigns(:rooms)).to eq(['a','b'])
    end
    it "populates an array of records" do
      record = FactoryGirl.create(:default_sign_in_record)
      get :index
      expect(assigns(:sign_in_records)).to include(record)
    end
    it "applies the 'order_by' parameter" do
      a  = FactoryGirl.create(:default_sign_in_record, room: 'a')
      b  = FactoryGirl.create(:default_sign_in_record, room: 'b')
      get :index, params: { order_by: 'room desc' }
      expect(assigns(:sign_in_records)).to eq([b,a])
    end
    it "stores filters to the session" do
      get :index, params: { order_by: 'sign_in_time desc' }
      expect(session[:filter_sign_in_records]).to eq({'order_by' => 'sign_in_time desc'})
    end
    it "removes blank filter values" do
      get :index, params: { order_by: nil }
      expect(assigns(:filter)).to eq({})
    end
    it "retrieves filters from the session if none have been supplied" do
      a  = FactoryGirl.create(:default_sign_in_record, room: 'a')
      b  = FactoryGirl.create(:default_sign_in_record, room: 'b')
      get :index, params: { }, session: { :filter_sign_in_records => {'order_by' => 'room asc'} }
      expect(assigns(:sign_in_records)).to eq([a,b])
    end
    it "applies the 'with_first_name' filter" do
      expect(SignInRecord).to receive(:with_first_name).with('a').and_return(records)
      get :index, params: { with_first_name: 'a' }
    end
    it "applies the 'with_last_name' filter" do
      expect(SignInRecord).to receive(:with_last_name).with('a').and_return(records)
      get :index, params: { with_last_name: 'a' }
    end
    it "applies the 'in_room' filter" do
      expect(SignInRecord).to receive(:in_room).with('a').and_return(records)
      get :index, params: { in_room: 'a' }
    end
    it "applies the 'is_newcomer' filter" do
      expect(SignInRecord).to receive(:is_newcomer).with('true').and_return(records)
      get :index, params: { is_newcomer: true }
    end
    it "applies the 'for_today' filter" do
      expect(SignInRecord).to receive(:for_today).and_return(records)
      get :index, params: { for_today: true }
    end
    it "applies the 'on_or_after' filter" do
      expect(SignInRecord).to receive(:on_or_after).with(Date.new(2017,2,1)).and_return(records)
      get :index, params: { on_or_after: '01/02/2017' }
    end
    it "applies the 'on_or_before' filter" do
      expect(SignInRecord).to receive(:on_or_before).with(Date.new(2017,2,1)).and_return(records)
      get :index, params: { on_or_before: '01/02/2017' }
    end
    context "when the default page size is set to 30" do
      context "with no explicit page value" do
        it "returns the first page of records" do
          31.times { |i| FactoryGirl.create(:default_sign_in_record) }
          get :index
          expect(assigns(:sign_in_records).count).to eq(30)
        end
      end
      context "with an explicit page value" do
        it "returns the requested page of records" do
          31.times { |i| FactoryGirl.create(:default_sign_in_record) }
          get :index, params: { page: 2 }
          expect(assigns(:sign_in_records).count).to eq(1)
        end
      end
    end
  end


  describe "GET #clear_filter" do
    it "redirects to #index" do
      get :clear_filter
      expect(response).to redirect_to(:sign_in_records)
    end
    it "clears the session entry" do
      session[:filter_sign_in_records] = {'order_by' => 'room desc'}
      get :clear_filter
      expect(session.key?(:filter_sign_in_records)).to be false
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
