namespace :announcer do
  task :import_pentabarf do |task|
    Event.transaction do
      year = ENV['YEAR'] || "2010"
      puts "Importing events for #{year}"
      Event.delete_all 
      Event.import_from_pentabarf_url("http://events.ccc.de/congress/#{year}/Fahrplan/schedule.en.xml")
    end
  end
end