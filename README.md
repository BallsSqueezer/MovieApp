# Project 1 - *MovieApp*

**MovieApp** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **~24** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can view a list of movies currently playing in theaters. Poster images load asynchronously.
- [x] User can view movie details by tapping on a cell.
- [x] User sees loading state while waiting for the API.
- [x] User sees an error message when there is a network error.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [x] Add a tab bar for **Now Playing** and **Top Rated** movies.
- [x] Implement segmented control to switch between list view and grid view.
- [x] Add a search bar.
- [x] All images fade in.
- [x] For the large poster, load the low-res image first, switch to high-res when complete.
- [x] Customize the highlight and selection effect of the cell.
- [x] Customize the navigation bar.

The following **additional** features are implemented:

- [x] Add the walkthrough screen for the first time user uses tha app
- [x] Not to make poeple get bored while looking at the loading indicator keeps scrolling, I add the splash animation after loading the app (this animation does not present when user use app for the first time). You can still see the loading screen if you comment out the splash animation
- [x] Use NSDefault to remember which view (tableView or collectionView) that user uses last time, so that the app will present the same view the next time user starts the app

## Video Walkthrough

Here's a walkthrough of implemented user stories:

![Video Walkthrough](https://github.com/BallsSqueezer/MovieApp/blob/master/MovieApp2.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/)

Custom buttons and icons downloaded from [Icons8](https://icons8.com)

## Notes
- This only work well on iPhone 5/5s

## Here are the few things that need to be fixed
- There is a weird transition when I tap on a cell while search bar and keyboard are still active
- You still can scroll while the splash animation occurs
- Sometimes the navigation bar on the Top Rated tab is replace with white blank view and I can't do anything to get it back. I don't know how to reproduce thie either, I just keep switching between tabs and keep scrolling up and down
- The hide navigation bar on swipe option only works with Top Rated tab
- Should spend more time working on how the app should respond when suddenly lost connection, AND when the url provide is no valid
- I don't know why the collection view keeps showing while you load the app for the first time authough I intentionally set the bool value so that the table view shows up first when user starts the app for the first time

Describe any challenges encountered while building the app.

## License

    Copyright [2016] [Hien Tran]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
