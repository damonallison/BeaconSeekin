# BeaconSeekin

This sample app will notify you when you enter or leave the range of a beacon with
the following values. See `RegionMonitor.swift` to change these values.

```
let uuid = UUID(uuidString: "ac00560e-9c98-4e7d-8da4-849e493269f7")!
let major = 99
let minor = 99
```

In order to receive notifications, tap `Start` on the main view. When beacons are
found or lost, an event is added to the main table view.

Scanning will continue to run in the background and will publish a local notification
when the region is entered or exited while the app is in the background.

## Notes

* Even if monitoring is enabled, events are not instantaneous. In some cases, it may take 10-20 seconds to receive events.
* If you are prompted with a request to use location services, or send you notifications, click allow. Location services are used to monitor for beacons. Notifications are used to notify you of beacon changes while running in the background.
