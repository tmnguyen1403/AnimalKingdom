## User Stories - Week2

The following **required** functionality is completed:

- [ x] Implemented add new animal screen.
- [ x] Implemented lock screen.
- [ x] Updated user's pets after finishing hatching.

## User Stories - Week1

The following **required** functionality is completed:

- [ x] Implemented lock-screen mechanism when user add new pet.
- [ x] Designed the Zoo screen.

### Demo Lockscreen functionality
![Lockscreen Demo](./Gif/demo_1.gif)

### Animal Kingdom
- *Purpose*:
    - 
    - App like Forest app on the market; instead of planting trees, users can raise animals and connect with other users
    - To prevent distraction, when users choose to raise an animal like a dog or a cat, users cannot leave the app and use their phone during hatching and raising time(10,20,30 minutes). If users choose to leave the app, the animal will die.
    - A successful born animal can be raised and level up like Pokemon with the same time mechanic.
- *Story*:
    - Users can choose which animals to incubate
    - Users cannot leave the app or their phone while incubating
    - Users can cancel the incubation process which will bring death to the selected animal
    - Users can connect and share their zoos with other users
    - Users can help their friends raising their animals in case they have to use phone for emergency
    - Users can level up(or feed) their animal

Original App Design Project - README Template
===

# Animal Kingdom

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Heps users to stay focus on their work, less distraction from using their mobile devices by raising animal. Similar concept like Forest app.

### App Evaluation
- **Category:** Personal / Meditation / Social Networking  
- **Mobile:** mobile first experience.  
- **Story:**  Reducing users' screen time by allowing them raising animals(pets) while locking their phones. Users can also connect to other users to share their achievements.
- **Market:**  
Anyone who wants to reduce screen time on their phones can use this app  
- **Habit:** This app should be used while users are working/studying
- **Scope:** First, we would start with allowing users to raise common pets like dogs and cats in a certain time like(30mins, 60mins). Then, we can expand the animal options and let users share their progresses with other users.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**
* Users logs in to access their zoo
* Users choose the time limit((30mins, 60mins) that they want to stay focus
* Users choose the pets they want to raise with the time limit
* The countdown will start and prevent users from leaving the app to use other apps
* If users in case need to use other apps, their progress will be cancelled

**Optional Nice-to-have Stories**
* Users can befriend with other users
* Users can share their achievements(pets)

### 2. Screen Archetypes

* Login
* Register - User signs up or logs into their account
* Zoo screen
  * After login, user can see their pets and options to raise new pets
* Pet selection screen
  * User chooses which pets to raise based on time imit
* Incubation screen
  * Locking user from using other apps while raising their pet
* Social screen
  * User makes friends with other users
* Profile screen
  * User updates name, profile image
* Settings Screen
  * User can change language, and app notification settings

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Pet selection
* Friend selection
* Settings

**Flow Navigation** (Screen to Screen)

* Forced Log-in -> Account creation if no log in is available
* Zoo screen -> Pet selection screen
* Pet selection screen -> Incubation Screen
* Incubation screen (time limit expired) -> Zoo screen (update with new pet)
* Settings -> Display settings

## Wireframes
<img src="https://i.imgur.com/EFPAk7D.jpg" width=800><br>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 

### Models

-----------------------------------------
#### Users  

| Property | Type | Description|
| ------------- | ------------- |------------- |
| userID | String  | unique id for user  |
| username | String  | unique username  |
| password  | String  | User password |
| image | File  | profile picture of user |
| pets | Array String | array of animal's ids|
| friends | Array String | array of friends' id|

| CRUD | HTTP Verb | Example |
| ------------- | ------------- |------------- |
| Create  | userPost | Creates new user |
| Read  | userGet  | Gets information of user/friends |
| Update | userPut  | Updates user info |
-------------------------------------------------------------
#### Pets   
| Property | Type | Description|
| ------------- | ------------- |------------- |
| objectId | String  | unique id for pet  |
| animalId | String  | petname + level  |
| name | String  | pet's name|
| level | Int  | pet's level|
| imageURL | String  | pet image's URL |
| duration  | Int   | Incubation time |


| CRUD | HTTP Verb | Example |
| ------------- | ------------- |------------- |
| Read  | petGet  | Gets all the pets |

-------------------------------------------------------

### Networking
#### List of network request by screen
* Login Screen  
    * (Read/GET) Validate user  
    ```
        let query = PFQuery(className:"User")
        query.whereKey("username", equalTo: currentUser)
        query.findObjectsInBackground { (user: PFObject, error: Error?) in
           if let error = error { 
              print(error.localizedDescription)
           } else if let user = user {
              print("Successfully retrieved user.")
              //check input password & user password
           }
        }
    ```
* Signup Screen  
    * (Create/POST) Create new user
* Zoo Screen  
    * (Read/GET) Get pets' information
* Lock Screen  
    * (Create/POST) Update new pet for user
- [OPTIONAL: List endpoints if using existing API such as Yelp]
