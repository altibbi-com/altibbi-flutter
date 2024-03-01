<img src="https://cdn.altibbi.com/theme/altibbi/icons/tbi-brand.svg" width="50%" height="50%">

# Altibbi Flutter SDK

This Flutter SDK provides integration for the Altibbi services, including video consultation, text consultation, push
notification, and many other features. This guide will walk you through the steps to integrate it into your Flutter
project.

## Usage

#### Initialize the Altibbi service with the user token and partner endpoint as follows:
Note: Be sure to replace placeholders `"USER_TOKEN"` and `"PARTNER_ENDPOINT"` with your actual values.

```dart
AltibbiService.init(
    token: "USER_TOKEN",
    baseUrl: "PARTNER_ENDPOINT",
    language: "Language", // 'ar' || 'en'
);
```

### After Initialize Altibbi Service You Can Use Altibbi API :
#### Using the API Service:
```dart
ApiService apiService = ApiService();
```

### User API

#### Create New User :

You Have To Pass User Object

```dart
User user =  User(name: "user_name");
var users = await apiService.createUser(user);
```

#### Get User Info By ID :

```dart
var user = await apiService.getUser(user_id);
```

#### Users List Related To Member :

you can pass page && perPage defaults 1 && 20

```dart
var users = await apiService.getUsers(perPage: 20, page: 1);
```

#### Update User Info :

```dart
var user = await apiService.updateUser(new_user_info , user_id);
```

#### Delete User :

```dart
var user = await apiService.deleteUser(user_id);
```

### Consultation API

#### Create Consultation :

```dart
var consultation = await apiService.createConsultation(
      question: "user_question",
      medium:  Medium.chat, // there are 4 type of medium (chat,voip,video,gsm)
      userID: 1, //Assigning consultation to User ID
      mediaIDs: media // image,pdf .. 
  );
```

#### Note That You Can Pass "followUpId" In Case Consultation Is FollowUpConsultation

#### Consultation List:

you can pass page && perPage defaults 1 && 20

```dart
var consultationList = await apiService.getConsultationList(page: 1, perPage: 30);
```

#### Consultation Info By ID :

```dart
var consultation = await apiService.getConsultationInfo(consultation_id);
```

#### Last Consultation Info :

```dart
var consultation = await apiService.getLastConsultation();
```

#### Delete Consultation :

```dart
var value = await apiService.deleteConsultation(consultation_id);
```

#### Cancel Consultation :

```dart
var cancelValue = await apiService.cancelConsultation(consultation_id);
```

### Prescription API

#### download the Prescription 
note : if the prescription for the consultation is generated it will return else it will be null 

```dart
var prescriptionPath = await apiService.getPrescription(consultation_id,path_to_save_the_file);
```

### Media API

#### Upload Media That Can Be Used In Consultation (Image , PDF)

```dart
var media = await apiService.uploadMedia(image);
```
### Use Pusher Service To Listen To Consultation Event

#### Initializing the Pusher Service:

```dart
Pusher().init(
  onEvent: onEvent, 
  channelName: "pusher_channel_name", // retrun from the consultation api
  apiKey: "pusher_api_key" // retrun from the consultation api
);
```

#### You Can Listen To Event Using Funtion "onEvent" Passed In Pusher().init :

```dart
void onEvent(event) async {
  print("event Name = " + event.eventName);
}
```

### Initializing the Video Service && Granted Permission :

```dart

 late VideoConfig _config;
 VideoController? _controller;
  
  
 Future<void> initPlatformState() async {
    _config = VideoConfig(
      apiKey: "apikey",// Get This From The Pusher Event
      sessionId: "sessionId",// Get This From The Pusher Event
      token: "token",// Get This From The Pusher Event
    );

    _controller = VideoController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.microphone,
      ].request();
      final isGranted =
          statuses[Permission.camera] == PermissionStatus.granted &&
              statuses[Permission.microphone] == PermissionStatus.granted;
      if (isGranted) {
     
        _controller?.initSession(_config);
        if(widget.voip){
          await Future.delayed(const Duration(seconds: 3), () {
            videoControl(true);
          });
        }
      } else {
        debugPrint(
            "Camera or Microphone permission or both denied by the user!");
      }
    });
  }
```

### Displaying Altibbi Video:
Use VideoView Widget
```dart
 VideoView(controller: _controller ?? VideoController()),
```



### Initializing Chat:
Use AltibbiChat Widget
```dart
 AltibbiChat().init(consultation: consultation);
```



### Chat listeners:
Assigning Chat listeners
```dart
 AltibbiChat().addChannelHandler('myChannelHandler', channelHandler);
```



### Sending Chat message:
Sending a text Chat
```dart
 GroupChannel groupChannels = await AltibbiChat().getGroupChannel(consultation);
 groupChannels.sendUserMessage(UserMessageCreateParams(message: message));
```


## Example

An example Flutter application using the Altibbi SDK can be found in the `example` directory.

Please see the `example` directory for a complete sample app using Altibbi Flutter SDK.
```dart
1- Creating a consultation page
2- Waiting room page
3- Chat page page
4- Video conference page
5- VOIP conference page
6- Crating user page
```



## Documentation

If you need support you can contact: [mobile@altibbi.com](mobile@altibbi.com). Please
ensure that you are referencing the latest version of our SDK to access all available features and improvements.

## License

The Altibbi Flutter SDK is licensed under the [Altibbi License](#https://altibbi.com/).
