module EventsHelper
  def periodically_refresh_room(room, limit = Event::MAX_OTHER_ROOM_EVENTS, interval = Event::REFRESH_TIME )
    js = <<-EOJS
      var refresh_room = function() {
        getEventsAndUpdateList("#{room.id}", "#{limit}" )
      };
      refresh_room();
      setInterval ( refresh_room, #{interval.to_i});
    EOJS
    jquery js
  end
end
