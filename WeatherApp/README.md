#  WeatherApp
## Features
* Search by location name, zipcode anywhere in the world
* Auto-search based on your GPS location
* View current weather conditions
* Scroll to view hourly and daily forecasts for the next 5 days
* Beautiful background images that are contextual to the current weather conditions and time of day for the location you searched for
* Support for metric vs. imperial units for all weather information based on device's locale
* Forecasts are presented in local time relative to the location you searched for

## Screenshots
### Current Conditions
![Current Conditions Screenshot](https://github.com/coreysprague/weather/blob/master/Screenshots/gps_top.png)

### Forecast & Details
![Forecast & Details Screenshot](https://github.com/coreysprague/weather/blob/master/Screenshots/gps_bottom.png)

### Metric unit support
![Metric Screenshot](https://github.com/coreysprague/weather/blob/master/Screenshots/localization.png)

### Contextual Images
![Broken Clouds Afternoon](https://github.com/coreysprague/weather/blob/master/Screenshots/brokenclouds_afternoon.png)
![Broken Clouds Morning](https://github.com/coreysprague/weather/blob/master/Screenshots/brokenclouds_morning.png)
![Morning Mist](https://github.com/coreysprague/weather/blob/master/Screenshots/mist_morning.png)
![Scattered Clouds Morning](https://github.com/coreysprague/weather/blob/master/Screenshots/scatteredclouds_morning.png)
![Night Thunder](https://github.com/coreysprague/weather/blob/master/Screenshots/thunder_night.png)
![Cloudy Evening](https://github.com/coreysprague/weather/blob/master/Screenshots/clouds.png)
![Fog Nighttime](https://github.com/coreysprague/weather/blob/master/Screenshots/fog.png)
![Few Clouds Morning](https://github.com/coreysprague/weather/blob/master/Screenshots/fewclouds_morning.png)

## Backlog
*Small item backlog*
* Finish fleshing out test coverage
* show network indicator during network requests
* shorter network timeouts & better UX when internet is unavailable
* pull to refresh
* allow user to re-engage GPS (currently done automatically on load)
* more contextual images: extreme weather conditions, more options for common conditions (clear sky, clouds, rain, etc)

*Feature Backlog*
* Location history
* * save search history
* * view past searches and allow for select
* * display current temperature for each location on the history screen (using bulk API)
* * allow for deletion of previous search results
