require 'spec_helper'

describe BookingsController do

  describe "GET 'index'" do
    it "populates a table of shuttle lines and their associated stops" do
      shuttle = FactoryGirl.create(:shuttle)
      get :index
      assigns(:shuttles).should include(shuttle)
    end

    it "renders the :index view" do
      get :index
      response.should render_template :index
    end
  end

  describe "GET 'new'" do
    before(:each) do
      @stop = FactoryGirl.create(:stop)
    end

    it "assigns a new Booking to @booking" do
      get :new, :stop => @stop.id
      assigns(:booking).stop.should eq (@stop)
      assigns(:booking).shuttle.should eq(@stop.shuttle)
    end

    it "renders the :new template" do
      get :new, :stop => @stop.id
      response.should render_template :new
    end
  end

  describe "POST 'create'" do
    context "with valid attributes" do
      before(:each) do
        @stop = FactoryGirl.create(:stop)
        @shuttle = @stop.shuttle
      end

      it "saves the new booking in the database" do
        expect {
          post :create, :booking => FactoryGirl.attributes_for(:booking, :stop_id => @stop.id, :shuttle_id => @shuttle.id)
          }.to change(Booking, :count).by(1)
      end

      it "redirects to the confirmation page" do
        post :create, :booking => FactoryGirl.attributes_for(:booking, :stop_id => @stop.id, :shuttle_id => @shuttle.id)
        response.should redirect_to booking_url(assigns(:booking))
      end
    end

    context "with invalid attributes" do
      before(:each) do
        @stop = FactoryGirl.create(:stop)
        @shuttle = @stop.shuttle
      end

      it "does not save the new booking in the database" do
        expect {
          post :create, :booking => FactoryGirl.attributes_for(:booking, :stop_id => @stop.id, :shuttle_id => @shuttle.id, :customer => nil)
          }.to_not change(Booking, :count)
      end

      it "re-renders the :new template" do
        post :create, :booking => FactoryGirl.attributes_for(:booking, :stop_id => @stop.id, :shuttle_id => @shuttle.id, :customer => nil)
        response.should render_template :new
        flash[:error].should =~ /Invalid data input/i
      end
    end

    context "1/1 shuttle full" do
      before(:each) do
        @shuttle = FactoryGirl.create(:shuttle, :capacity => 5)
        @stop = FactoryGirl.create(:stop, :shuttle => @shuttle)
        5.times { FactoryGirl.create(:booking, :stop => @stop, :shuttle => @shuttle)}
      end

      it "does not save the new booking in the database" do
        expect {
          post :create, :booking => FactoryGirl.attributes_for(:booking, :stop_id => @stop.id, :shuttle_id => @shuttle.id)
          }.to_not change(Booking, :count)
      end

      it "redirects to shuttles index with a notice" do
        post :create, :booking => FactoryGirl.attributes_for(:booking, :stop_id => @stop.id, :shuttle_id => @shuttle.id)
        response.should redirect_to bookings_url
        flash[:notice].should =~ /The line you selected has only 1 shuttle, it is full/i
      end
    end

    context "2/2 shuttles full" do
      before(:each) do
        @shuttle = FactoryGirl.create(:shuttle, :second_dayofweek => "Sat", :second_timeofday => "9:30AM", :capacity => 5)
        @stop = FactoryGirl.create(:stop, :shuttle => @shuttle)
        10.times { FactoryGirl.create(:booking, :stop => @stop, :shuttle => @shuttle)}
      end

      it "does not save the new booking in the database" do
        expect {
          post :create, :booking => FactoryGirl.attributes_for(:booking, :stop_id => @stop.id, :shuttle_id => @shuttle.id)
          }.to_not change(Booking, :count)
      end

      it "redirects to shuttles index with a notice" do
        post :create, :booking => FactoryGirl.attributes_for(:booking, :stop_id => @stop.id, :shuttle_id => @shuttle.id)
        response.should redirect_to bookings_url
        flash[:notice].should =~ /The line you selected has 2 shuttles, they are full/i
      end
    end
  end

  describe "GET 'show'" do
    it "assigns the requested booking to @booking" do
      booking = FactoryGirl.create(:booking)
      get :show, :token => booking.token
      assigns(:booking).should eq(booking)
    end

    it "assigns nil to @booking if can not find that booking by token" do
      get :show, :token => "112233bbccaadd44"
      assigns(:booking).should be_nil
    end

    it "renders the :show template" do
      get :show, :token => FactoryGirl.create(:booking).token
      response.should render_template :show
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @booking = FactoryGirl.create(:booking)
    end

    it "deletes the requested booking" do
      delete :destroy, :token => @booking.token
      bookings = Booking.all
      bookings.should_not include(@booking)
    end

    it "redirects to shuttles index with a notice" do
      delete :destroy, :token => @booking.token
      response.should redirect_to bookings_url
      flash[:notice].should =~ /You have cancelled your booking/i
    end
  end

end
