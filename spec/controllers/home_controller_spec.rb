require 'rails_helper'

RSpec.describe HomeController, type: :controller do

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
    it "sets the title to 'Dashboard'" do
      get :index
      expect(assigns(:title)).to eq('Dashboard')
    end
    it "returns a unique list of the 10 most recent actual sign in dates" do
      expect(SignInRecord).to receive(:unique_dates).with(10).and_return([])
      get :index
    end
    it "returns a count of children signed in" do
      expect(SignInRecord).to receive(:child_count).with(Date.today).and_return(10)
      expect(SignInRecord).to receive(:newcomer_count).with(Date.today).and_return(11)
      get :index
      expect(assigns(:child_count)).to eq(10)
      expect(assigns(:newcomer_count)).to eq(11)
    end
    it "returns a hash of room counts" do
      my_double = double
      expect(SignInRecord).to receive(:room_counts).with(Date.today).and_return(my_double)
      get :index
      expect(assigns(:room_counts)).to eq(my_double)
    end
    it "returns a hash of historic data" do
      my_double = double
      expect(SignInRecord).to receive(:historic_counts).and_return(my_double)
      get :index
      expect(assigns(:historic_counts)).to eq(my_double)
    end
    context "with no date parameter" do
      context "when there are sign in records" do
        it "uses the most recent sign in date" do
          allow(SignInRecord).to receive(:unique_dates).and_return([Date.new(2017,2,3)])
          get :index
          expect(assigns(:date)).to eq(Date.new(2017,2,3))
        end
      end
      context "when there are no sign in records" do
        it "uses today's date" do
          get :index
          expect(assigns(:date)).to eq(Date.today)
        end
      end
    end
    context "with a date parameter" do
      it "uses that date" do
        get :index, params: { date: '2017-03-04' }
        expect(assigns(:date)).to eq(Date.new(2017,3,4))
      end
    end
    context "with an invalid date parameter" do
      it "uses today's date" do
        get :index, params: { date: '2017-13-04' }
        expect(assigns(:date)).to eq(Date.today)
      end
    end
  end

end
