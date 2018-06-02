
**MovieApp** is a demo project that demostrates Playground Driven Developemnt concept. The concept is inspired by [Kick Starter](https://github.com/kickstarter/ios-oss). In this project, I was able to completely replace storyboards with playgrounds. It allows the developer to quickly switch between different environments (mockups, locale, languages, screen sizes, orientations) to ensure the UI (the thing that users see) looks perfect in all scenarios, without having to compile the code. Imagine the pain when we have to wait 3 minutes for the app to compile, test on 5 different languages, tap on 5 buttons to open a setting page, rotate the device, then finally realize that the title label is 5 pixels overlaped the button. With Playgound Driven Development, we can get rid of all those hassles. Although Playground is not rendering the UI immediately like React Native, but still it could save you a whole lot of time. Hopefully, Apple will improve Playground performance over the year

## Getting Started
- Clone the project
- Run `pod install` to instal dependencies.
- Refer to [The Movie Database API](https://developers.themoviedb.org/3/getting-started/introduction) for API documentations.

## Contributing

Suggestions, feedback, pull requests and bug report are welcomed

## TODO
- [ ] Implement `Top Rated` tab
- [ ] Move the API key to Cocoa Pod keys
- [ ] Add documents
- [ ] Update UI in Movie Detail Screen
- [ ] Moving networking and user default into AppConfiguraion
- [ ] Screenshots
