# Mobile YP. 行動延平

#UPDATE 20240922: I'm at a loss right now.

All points for this app's existence have been lost.
I tried to justify it over time, but the current status quo has failed me significantly.
Here are some reasons regarding this project's deprecation:
1. Since June of 2023, the school's website underwent a complete revamp. The new version features RWD (Responsive Web Design), which scales according to device type, and defeats the purpose of the main page function (Public CC).
2. Since September of 2024, the school's private bulletin board (Online CC) is outsourced and eventually becomes [eClass](https://eclass.tw/). This renders the Online CC function uselss since for one, the [old website](https://lds.yphs.tp.edu.tw/tea/tu2.aspx) is no longer maintained or updated. In a few years' time, no one will be able to login to this anymore. For another, I don't have access to eClass's API or it's website, so I'm unable to work on it. In fact, the school is slowly transitioning all of the internal functions to eClass, and that itself makes up for this whole project's purpose.
4. I have graduated from the school (Yes it has taken that long), and I will slowly lose access to many of the services available.
5. There's really no reason to continue working on this for me since I left, also knowing that even if in the future someone tries to adopt this idea, the benefits are extremely minimal.

I'm still leaving this repository public if anyone wants to work on it, and also a list of stuff I orginally planned to implement:
- Public CC: Tags (WIP)
- Public/Online CC: Star (WIP, use JSON)
- General: Fix issues on iOS (WIP)
- View: Implement Normal Light Mode for insufficient contrast
- View: Fix sharing mess
- ViewPrivate: Replace common HTML tags (gt/lt/amp, https://www.freeformatter.com/html-entities.html)
- Public CC: News Filtering (Date/Agency)
- Public/Online CC: News searching
- Public/Online CC: Swipe actions
- Upload/Online CC: Support Markdown (https://pub.dev/packages/flutter_markdown)
- Schedule: gr2 to Google Calendar API
- General: First time guide
- General: Migrate non-existent ASP.Net components
- General: Save randomised ASP.Net Cookie generated on first startup, as a result don't require login every time
- General: Swipe to refresh (RefreshIndicator, https://www.geeksforgeeks.org/flutter-implementing-pull-to-refresh/amp/)
- New: Links (should be easy)
- New: Announcement Images (Separate page, list view)
- New: Home page (like Google Keep Grid View)
- Note-taking: Grade Query
- New: Localisation
- Deprecated: Online Classes
- Deprecated: Migrate ASP shit into values.json (Values are collected on-demand)

# Preface

*"YanPing mobile app. Please make it good for fuck's sake"*  

That's the energy I gained when building this app, is to just mke it good. No unnecessary info included.

# Why I'm doing this

1. The website layout is GARBAGE
2. The website isn't very user friendly
3. The colour palette hurts my fucking eyes
4. School project hehe
5. A timely solution to reading information in an era when everybody has a phone (人手一機)

# Installation

1. Install the Flutter (Beta version is required)  ([Official documentation](https://docs.flutter.dev/get-started/install))
2. Run package get command
```console
$ flutter pub get
```
3. Install the Flutter and Dart Extension for your desired IDE
4. You're good to go! Your code should compile successfully right away

# Bug reporting

If you found my code unable to compile without modifications, submit a issue here on GitHub.
