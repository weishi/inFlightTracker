## CS193P Project Proposal

### Overview

This app supports tracking flights that are currently en-route. It is different from other flight tracking apps in AppStore, such as FlightTrack, in that it can be used without GPS or Internet connectivity. The idea is to cache the history path of the same flight and use take-off time and currect time to predict where the flight is. Since the air time of the same flight doesn't change much, the prediction should be reasonably accurate. 

### Feature

+ A map view for tracking a en-route flight. This will show a world map with a curve showing the path of the flight and a drop pin showing the currect position.
+ A view for displaying flight info, e.g. arrival/departure time
+ A table view for selecting the flight to track. Multiple flights can be saved and removed.
+ A form for creating new flight to track. This includes airline, flight number, etc.

### Date source

The flight path history will be retrieved from flightAware. This includes scraping the website or querying API.

### iOS Framework

The following parts in iOS framework will be used to implement this app.

+ CoreMotion - Not covered in lecture
    * to get accelaration to predict take-off time
+ UITableView
    * to display a list of flights to track
+ UIView
    * to show a flight creating form
    * to show detail information of a single flight
+ Core data
    * to store flight path, e.g. latitude, longitude, altitude, timestamp
+ MapView
    * to display plane path and position on map
+ Universal app
    * split view for iPad; segue for iPhone 
