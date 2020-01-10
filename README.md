# silicon_beach_admin

A Flutter app for Silicon Beach admins.

## Code gen for built_value 

After making changes to built_value classes run the builder to generate the new code:

```
flutter pub run build_runner build
```

## Running 

Run on port 5000, as localhost:5000 is whitelisted for Google authentication:

```Dart
flutter run -d web-server --web-port 5000
```

The Chrome developer version that VS Code launches can cause:

```
“Browser or app may not be secure. Try using a different browser.”
```

With Flutter Firebase Google Login, however opening the same URL (localhost:portnumber) in the normal chrome will work.

## Building 

``` 
flutter build web 
```

## Deploying 

### Setup 

First make sure you are signed in:

```
firebase login
```

From `build/web` run:

```
firebase init
```

- What do you want to use as your public directory? 
  - `.`
- Configure as a single-page app? 
  - `Yes` 
- File ./index.html already exists. Overwrite? 
  - `No`

Specify your site in firebase.json
- Add your site name to the firebase.json configuration file.

```Json
{
  "hosting": {
    "site": "silicon-beach-admin",
    "public": "public",
    ...
  }
}
```

### Deploy 

```Dart
firebase deploy --only hosting:silicon-beach-admin
```

After deploying, view at `https://silicon-beach-admin.web.app/`

## Redux RemoteDevTools (RDT) 

- find the IP address of the computer 
- use one of the strings in `utilities/mock.dart` or make a new one 
- edit `main.dart` to use the correct IP 
- run the remotedev server

```
remotedev --port 8000
```

- open a web page with url:

```
http://localhost:8000/
```

## Tests 

### Unit and Widget Tests 

```
flutter test
```

### Integration Tests 

```
flutter drive --target=test_driver/app.dart
```
