class RoomsController < ApplicationController
  layout 'rooms'
  
  def index
    @rooms = Room.all
  end
end
