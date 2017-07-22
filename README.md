# weather

Please write an iOS app to provide weather information.

High-level criteria:
The following list of functional requirements is prioritized. Implement as many of these points as you can given the time you have. Do only as much as your time allows. We favor *quality over quantity*.

1. Search by city name or zip code
Implement a search to allow the user to enter a city name or zip code. The results of the search is to display the current weather information for the searched location.

2. Search by GPS
On the same search screen, also allow user to use GPS location instead to get current weather information.

3. Most recent search location loads automatically
When you come back to the app after closing it, the weather for the most recent search is displayed.

4. Recent Searches
Implement a screen that lists recently searched locations. You can tap on a recent search location and see the current weather location.

5. Delete recent searches
Provide the ability to delete one or more recently searched locations.

6. Multi-market
Implement the app in such a way that it can be shipped to two different countries with a different app name in each country.
Australia: "My Aussie Weather"
Canada: "My Eh Weather"
If possible, use a different color scheme for each market.

Hard Requirements:
- Use the OpenWeatherMap API: http://openweathermap.org/api. You may use any of json, xml, or other payload.
- You may create your own API key or use this one: 95d190a434083879a6398aafd54d9e73
- Feel free to use any libraries that make the development of your app faster and more elegant. The exception to this is mapping: please *do not* use the map solution provided by openweathermap.org
- Unit test your code.

When you are done:
Provide a link to a github repo.
Please be prepared to speak about the choices you make across the board, from code design, to choice of libraries, test coverage, use of UI paradigms, etc.
