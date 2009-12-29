An live-announcer system for Pentabarf
====

[Pentabarf](http://pentabarf.org) is a web-based conference planning system. This software parses the XML-Schedules of Pentabarf conferences and displays the current and the upcoming events on a webpage that is supposed to be displayed in a fullscreen browser between talks.

So far is is a bit specific to the [26C3](http://events.ccc.de/congress/2009) but it is supposed to be usable for all Pentabarf planned events.

All events are imported into a local SQLite3 DB to be independent from the network. If you have ever been at a hacker's conference you know why.

Display System
-------
At 26C3 [Debian](http://debian.org) laptops with GDM-autologin and the [Arora](http://arora-browser.org) Browser in fullscreen started via .Xsession. The only problem is that Arora does not save the fullscreen state (yet)