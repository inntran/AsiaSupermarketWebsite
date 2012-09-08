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
    @booking = Booking.new(params[:booking])
    if @booking.save
      redirect_to booking_path(@booking), :success => "You have successfully booked a shuttle, here's the details"
    elsif @booking.shuttle.available.nil?
      if @booking.shuttle.shuttle_count == 1
        redirect_to bookings_path, :notice => "The line you selected has only 1 shuttle, it is full"
      elsif
        redirect_to bookings_path, :notice => "The line you selected has 2 shuttles, they are full"
      end
    else
      flash.now[:error] = "Invalid data input"
      render :new
    end
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
