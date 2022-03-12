# Huzz - Manage and grow your business with Huzz

The easy and modern way to record transactions, manage customers, recover debts, issue invoices, receive payments and generate insights for your business
## Getting Started

### Architecture
For the huzz app, we are using the Model–view–viewModel (MVVM) architecture. All feature sub folders will be separated using this pattern.
Using provider for state management
Using get_it for our services locator (dependency injection)

### Folder Structure
This folder structure explains what goes into where, and help a new developer/testers easily navigate the project

#### lib/assets
The assets folder has 3 sub-directories Fonts, Images, SVGs, and the each asset will be in it's respective folder.

#### lib/app
The app folder houses each feature of the app and her respective folder that makes the feature function as expected.
Each feature is split into three (3) layers:
Note: Each layer naming convention is singular and their sub-folders are plural

1. ##### Data layer
   Pure Dart classes
   ###### Data sources
   The data source communicates directly with remote or local datasource i.e RestAPI, GraphQl, Firebase and Local storage.

   ###### Models
   Model are dart objects that mimics json response from the API, In most case they also have 2 methods [fromJson] & [toJson].
   Here goes json serialization and deserialization too.

   ###### Repositories
   The repository class in the [Data layer] are implementation of the repository class in the [Domain Layer].
   Also trying and catching will be done here.

2. ##### Domain layer
   Pure Dart class
   The Business logic to solve the business rule for this feature. It attends to our use cases and gets data from the datasource (network or local)
   ###### Repositories
   Repositories in the domain layer are abstract classes of the functions represented in the repository implementation folder from the data layer.

3. ##### Presentation layer
   The application user interface, screens and widgets. Presentation logic is here also if required. On this layer you can decide to use whatever state management pattern.
   ###### **UI**
    - screens
    - widgets - Widgets are components but particular to just a certain feature

   ###### **Logic**
   Presentation logic to format the data or failure retrived by the repository and prepare it as required by the UI and user device settings. State managment comes into play here i.e BLOC, flutter bloc, Provider, Riverpod e.t.c
    - Viewmodel "For Provider SM" - Each screen should have it's own view model, and user or automated actions (use cases) will be injected into the view model, view model classes are responsible for checking state and notifying the UI for state changes.
    - Notifiers
    - Helpers - Helpers are small functions that does specific task on the presentation layer, specific to this feature.

#### lib/core
The core folder houses the main classes and services that are universally used within the app.
Such as the network, storage, analytics, etc.

### Building the feature folder
``` mkdir data data/models data/repositories data/services domain domain/abstract_repo presentation presentation/ui presentation/viewmodel presentation/ui/screens presentation/ui/widgets ``` builds the default folder structure for each feature


### Deploying to the stores
1. You need to be invited to the stores
2. You need the keystore and local.properties file where the alias and password
3. You need xcode and android studio for appstore and playstore respectively


