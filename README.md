# Movmania - UIKit(Programmatically) TMDB API
## 2024

* 1-Project Setup (Removing Storyboard-TabBar-HomeVC-SettingsVC)
* 2-Cells that contains 'CollectionView's for main 'TableView' added.
* 3-Created 'HeaderView' which contains poster, title and description for #1 rated title
* 4-Customized NavBar and added section titles for main 'TableView'.
* 5-Created a NetworkManager to fetch data from API(TMDB).
* 6-Created a custom cell called 'CollectionCell' for the posters that going to be presented in CollectionViews.
    - Added 'SDWebImage' package to the project for downloading and caching posters.
    - Added weekly trending movies and tv series.
    - HeaderTitleView got updated. Now it displays one of the today's popular content randomly.
    - Added popular TV Series section.
* 7-Created SearchVC which contains a 'TableView' and its custom cell called 'ContentCell'.
    - Fetched data(only movies for now) for search operations.
    - Added 'UISearchController' yet to be configured.
* 8-Search functionality is done for movies, yet to be configured for tv series.
* 9-Added 'youtube-ios-player-helper' pod to project to display embedded youtube videos.
    - Created a viewcontroller for presenting movie's trailers and details yet to be configured.
    - Configured YTView to display trailers for selected movie/tv series from CollectionView cells.
    - Small bug-fix & REMOVED 'youtube-ios-player-helper' pod from the project realized WebKit satisfies my needs.
    - Handled the tapping of HeaderTitleView now it directs to the details screen.
    - Realized that WKWebView bugs out with some videos(couldn't specify the reason) therefore reADDED the 'youtube-ios-player-helper' to the project.
    - Downgraded iOS Deployment Target to 14.7
* 10-Refactored codes, added MediaService to handle fetching data separately from the network manager.
    - Handled tapping in the SearchResultsViewControll now it directs to the DetailsViewController.
* 11-Changing project architecture to MVVM(Model-View-ViewModel) [In Progress]
    - Created ViewModels for HomeViewController and HomeTableCell.
    - Created ViewModels for SearchViewController and SearchResultsViewController.
    - Added Recommendations CollectionView to the MediaDetailsViewController.
    - Added Actors CollectionView to the MediaDetailsViewController.
    - Added scrolling functionality to the MediaDetailsViewController.
    - [Bugfix] When the actors count equals to 5 it causes to crash (it was a logical error which is not correctly defining the limits of a if statement). Now it displays 10 actors maximum.
* 12- Firebase entegration to handle authentication and storing favorite movies [In Progress]
    - Created Login,Register and ResetPassword scenes to the project
    - Added Firebase entegration to the project.
    - Handled the authentication with Firebase Authentication.
    - Handled saving users to Cloud Firestore when registering.
    - Created Favorites scene
    - Handled user based favorite media collection using Firestore
    - Created 'Add To Favorites' button for 'MediaDetailsViewController'.
    - Handled navigation from Favorites to MediaDetails.
    - Handled the 'Add To Favorites' button's image to adapt insert/delete operations.
* 13- Lottie-ios added to the project.
    - Search now works both on tv series and movies.
    - Enhanced Favorites UI.
    - Improved Details UI, added a header.
    - Added genres label to the details header.
    - Handled when there are no actors for a media.
    - Improved trailer view.
* 14- Added ViewModel to Favorites
    - Added ViewModel to MediaDetails
    - Added ViewModels for Login, Register and ForgotPass Controllers
    - Added Actors scene to the project
* 15- Enhanced Search View.
    - Added sorting feature in search scene.
    - Improved settings view.
    - [BUGFIX] favoriting a media wasn't working well when its come to the front end. Now it works perfectly fine.
    - REMOVED home screen's add to favorite button. Users can navigate to details to favorite media anyway.
    - Handled tapping: (ActorDetails' 'Known For' -> MediaDetails)  (MediaDetails' 'Recommended' -> MediaDetails.) 
    - Added clear cache option to the Settings.
    - Added read more button and its functionality for the media details view. 
