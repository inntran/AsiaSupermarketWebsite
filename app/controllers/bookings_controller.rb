class BookingsController < ApplicationController
  def index
    @shuttles = Shuttle.all
  end

  def new
    stop = Stop.find(params[:stop])
    shuttle = stop.shuttle
    @booking = Booking.new(:stop => stop, :shuttle => shuttle)
  end

  def create
  end

  def show
    @booking = Booking.find_by_token(params[:token])
  end

  def destroy
    @booking = Booking.find_by_token(params[:token])
    if @booking.destroy
      redirect_to bookings_path, :notice => "You have cancelled your booking"
    else
      redirect_to booking_path
    end
  end
end
