title: Marionette V3 -- The Plan
tags:
  - plans
  - v3
---

The V3 Release of Marionette plans to add the missing application layer pieces that are very much needed within Marionette.
Over the past few years there has been a community effort to establish patterns to allow people to build large applications in Marionette.
It is time to codify the concepts into the core. Below are the primary application focused goals we have outlined for the next release.

> (As with all of our releases we plan on providing a straight forward upgrade path for you and your app to reap the benifits)

The first piece that we are going to tackle will be the `Router`.

[@jmeas](https://github.com/jmeas/) has done some great work in this area via the creation of a library called [base-router](https://github.com/jmeas/backbone.base-router). We plan on extending this work to create a router that has two primary new concepts, state based routing, and named routes. There will most likely be more features, inspired both from the great ember router and angular ui router.

The next piece slated for revision is the `Application` layer of Marionette. Currently it does several things, but is quite generic and does not integrate automatically with the concepts that Marionette already has baked it. (just look at the amount of code needed to kick off a marionette app [demo](http://jsfiddle.net/samccone/F59qp/)). We are planning on more tightly coupling the router to the Applicaiton object as well as hardening the concept of an application having a life-cycle. The next next shift for the application will be adding the ability for Applications to contain "sub applications" which are just application objects that are started and stopped automatically depending on their parent app state. This concept should make it quite straightforward to allow you to add significant app complexity without having to engineer a bespoke way to manange application life cycle.

The final piece of this puzzle revolves around cross application communication. Marionette is heavily evented, and we want to encourage people to embrace this pattern by making it easy to hook into and use. For this reason we are replacing wreqr with [Radio](https://github.com/marionettejs/backbone.radio). This will allow for a better event backbone for the application components.

Thoughts, concerns? Want to help? Come join us! [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/marionettejs/backbone.marionette?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

-
[@samccone](http://github.com/samccone)
