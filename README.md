# Bookmark

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Bookmark is a entertainment-based app focused on building a community through books. Users can review their favorite (or least favorite) books and create lists of books as well.

Link to App Demo and Walkthrough: https://clipchamp.com/watch/xDxGYFyaZdr

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Social/Entertainment
- **Mobile:** With a more social format of following users and authors you like, Bookmark benefits greatly from the more social and aesthetic nature of mobile app development.
- **Story:** Community formed around books and reading, used by people who like books
- **Market:** Currently, many people use GoodReads to track what books they read and what books they want to read. However, GoodReads is disliked by some of its users for its unappealing design, bad search feature, and more structures list format. By putting the mobile experience first, Book Stuff can solve these issues.
- **Habit:** Users can both follow other users, authors, and lists or create their own lists and reviews of books. With a popular books/lists page as the starting screen, users can be exposed to new content as soon as they open the app.
- **Scope:** It should be possible to create a minimum-viable product version of this app within the 5 weeks, given its more clear premise: a place to review and organize books. As long as I am clear about the distinction between required and optional user stories and prioritize the required stories, I should be able to finish this project in time.

## Product Spec

### App Walkthrough/Demo: https://drive.google.com/file/d/1ILk_97Xq-PRYKMX78Cly88r_jSdG-lFj/view?usp=sharing

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [X] User sees app icon in home screen and styled launch screen
- [X] User can sign in using proper login flow
- [X] New Account creation page
- [X] User can Logout

- [X] User can view all reviews and lists in their main feed 
- [X] User can load more posts once they reach the bottom of the feed using infinite loading
- [X] In the main feed, user can view review with the user profile picture, username, star ranking, review text, and timestamp.
- [X] In the main feed, user can view book list with the user profile picture, username, list title, picture of first book cover, and timestamp.
- [X] User can pull to refresh.
- [X] User can switch between popular page (if created), main feed, and personal profile view through a tab bar
- [X] User can view 10 popular books from popular content page

- [X] User can create a new review or list by tapping on the post button.
- [X] User should display the relative timestamp for each post "8m", "7h"
- [X] Review Details Page: User can tap on a review to view it, with controls to like.
- [X] List Details Page: User can tap on a list to view it, with pictures of all books included in a collection view and controls to like the list.
- [X] User can view their profile in a *profile tab*
  - [X] Contains the user header view: picture and username and bio
  - [X] Contains a section with the users basic stats: # review, # lists
- [X] Page for book that can be accessed by clicking on book cover picture in review/list
    - [X] Contains a section with the books basic stats: author, publication date, average star ranking
- [X] Utilizes a gesture to transition from model feed to detail cell page
- [X] Fading animation on table views

**Optional Nice-to-have Stories**

- [ ] User can follow other users and only view the reviews and lists of users they follow in their feed
- [X] User can tap the like button in the review cell or list cell to "like" the post.
- [X] User can unlike the review/list, decrementing the like count.
- [ ] Profile view includes that user's reviews and lists.
- [ ] User can tap the username in any post to see another user's profile
  - Contains the user header view: picture and tagline
  - Contains a section with the users basic stats: # review, # lists
- [ ] Option to post review/list privately with only personal access
- [ ] After creating a new review or list, a user should be able to view it in the feed immediately without refetching the timeline from the network.
- [ ] Link to amazon page to buy book
- [ ] User can comment on review with proper formatting on comment (profile picture and username 
    - [ ] User can delete comment.

### 2. Screen Archetypes
* Login Screen
    * User can login
* Registration Screen
    * User can create a new account
* Popular Page (if created)
    * User can view top 10 popular books
    * User can view top 10 popular lists
* Creation
    * User can post a new review or list to their feed
* Search
    * User can search for other users
    * User can search for books and authors
    * User can follow/unfollow another user
* Profile
    * User can see the stats of the account in question
    * User can see the reviews and lists the account has posted 

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Popular Page (if implemented)
* Main Feed
* Search View
* New Post Screen
* Personal Profile

**Flow Navigation** (Screen to Screen)

* Login Screen
    =>Home
* Registration Screen
    => Login
* Main Feed
    => Review Details
    => List Details
* Creation Screen
    => Home (after you finish posting the photo)
    => Potential internal screens to help find/edit?/post picture
* Search Screen
    => None

## Wireframes
 Here is a link to a PDF of the wireframing for Bookmark: https://fb-my.sharepoint.com/:b:/p/amruthasrik/EbuuE5L1zANIoKwffSbI0HsBIeMNqn7cO7DCEQtmTaEH_Q?e=81G8NS
 
 [Add picture of your hand sketched wireframes in this section]
 <img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
Review
| Property | Type | Description |
| objectId | String | unique id for user review |
| user | Pointer to user | review author |
| book | Pointer to book | book being reviewed |
| reviewText | String | book review by user |
| rating | Number | rating given to book by user|
| likesCount | Number | number of likes for review |
| createdAt | DateTime | date when post is created |
| updatedAt | DateTime | date when post updated |

List
| Property | Type | Description |
| objectId | String | unique id for user list |
| user | Pointer to user | list author |
| books | Array of pointers to books | books included in list |
| listTitle | String | list title |
| listSynopsis | String | list description by user |
| likesCount | Number | number of likes for review |
| createdAt | DateTime | date when post is created |
| updatedAt | DateTime | date when post updated |

Book (using book api, this might not be necessary)
| Property | Type | Description |
| objectId | String | unique id for user list |
| bookTitle | String | list author |
| author | String | author of book |
| publicationYear | Number | year book was published |
| bookCover | PFFileObject | cover of book |

### Networking
- Home Feed Screen
    - (Read/GET) Query all posts where user follows author of post
    - (Create/POST) Create new like on post (review/list)
    - (Delete) Delete existing like
    - (Create/POST) Create new comment on post (review/list) (*optional*)
    - (Delete) Delete existing comment (*optional*)
- New Post Screen
    - (Create/POST) Create new review object
    - (Create/POST) Create new list object
- Profile Screen
    - (Read/GET) Query logged in user object
    - (Update/PUT) Update user profile image
- Signup Screen
    - (Create/POST) Create new user
-Search Screen
    - (Read/GET) Query all posts related to search term

## Credits

List any 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [DateTools](https://github.com/MatthewYork/DateTools) - date formatting library
- [XLForm](https://github.com/xmartlabs/XLForm) - dynamic table-view form creating library
- [ChameleonFramework](https://github.com/BigZaphod/Chameleon) - UI coloring and polish library
- App Icon made by Freepik (https://www.freepik.com)


    


