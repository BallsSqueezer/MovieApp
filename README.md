
As an iOS developer, it's just the matter of time before running into this situation when you spend tens of hours making you application pixel perfect. However, how can you ensure that your UI will still look perfect in different languages, locales, screen sizes, and orientations? You are probably thinking about
- Go the device Settings
- Change to the designed language
- Wait to the device to reboot 
- Install the app and wait for Xcode to compile
- Open the app and navigate to the screen where you want to test
- Repeat the process for other languages and devices

The entire process can be tedious and time-consuming. Even when you just make a one-line change in your code, you end up spending more time to wait then to code. Even harder when your project grows and the UI starts getting more complex, testing becomes a nightmare. That is when Playground comes comes in to play.

**MovieApp** is a demo project that demostrates Playground Driven Developemnt concept. The concept is inspired by [Kick Starter](https://github.com/kickstarter/ios-oss). In this project, I was able to completely replace storyboards with playgrounds. It allows the developer to quickly switch between different environments (mockups, locale, languages, screen sizes, orientations) to ensure the UI (the thing that users see) look perfect in all scenarios, without having to to recompile and re-run the application.

## Getting Started
- Clone the project
- Run `pod install` to instal dependencies.
- Refer to [The Movie Database API](https://developers.themoviedb.org/3/getting-started/introduction) for API documentations.

[![](/Screenshots/SwitchLanguage.gif?raw=true)](https://imgur.com/SbklcFY)

## Contributing

Suggestions, feedback, pull requests and bug report are welcomed

## TODO
- [x] Implement `Top Rated` tab
- [x] Localize the `Next` button in walkthrough screen
- [ ] Move the API key to Cocoa Pod keys
- [ ] Add documents
- [ ] Update UI in Movie Detail Screen
- [ ] Moving networking and user default into AppConfiguraion
- [ ] Screenshots
