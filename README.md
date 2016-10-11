# BeaconSeekin

This sample app will notify you when you enter or leave the range of a beacon with
the following values. See `MainViewController` to change these values.

```
let uuid = UUID(uuidString: "ac00560e-9c98-4e7d-8da4-849e493269f7")!
let major = 99
let minor = 99
```

In order to receive notifications, tap `Start` on the main view. Scanning
will continue to run in the background and will publish a local notification
when the region is entered or exited.

## Notes

* If you are prompted with a request to use location services, click allow.


## TODO

### Must have

* Run on device.
* Awake from background.

### Nice to have
* `CLLocationManagerDelegate` : implement the required callbacks.
* Store `locationManager` in a singleton class somewhere?
* Icon
