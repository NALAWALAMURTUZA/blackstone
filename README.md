##Install docker for mac

`brew install docker-machine docker`

## Flutter sdk

[2.10.0](https://docs.flutter.dev/development/tools/sdk/releases?tab=windows) 

## Code Discription 
There are 3 module

* Core (which contten common class and helper)
* Client(Flutter web project)  
* Server(Service side code for storing data in mongo db)


## Database
Please install mongo in your local machin.

[Link](https://www.mongodb.com/docs/manual/installation/) 

## Run code using build.sh file

just click on run button in build.sh file after that execute below command in dist directory

`cd dist`

`dart ./lib/main.dart`

Kill port
lsof -i:3000
kill -9 [PID]


## Video



## ScreenShot
