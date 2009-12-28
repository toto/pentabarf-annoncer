module EventsHelper
  def periodically_refresh_room(room, interval = Event::REFRESH_TIME )
    js = <<-EOJS
      var refresh_room = function() {
        getEventsAndUpdateList("#{room.id}", "#{Event::MAX_OTHER_ROOM_EVENTS}" )
      };
      refresh_room();
      setInterval ( refresh_room, #{interval.to_i});
    EOJS
    jquery js
  end
end
