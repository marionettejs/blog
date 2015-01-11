title: Marionette Version 3 Discussions
tags:
  - plans
  - v3
date: 2015-01-12 17:51:57
---

This past friday the Marionette Team got together and did some v3 planning for the next release of Marionette.
The focus on of our conversation was on looking into adding the missing application layer pieces that are very much needed within Marionette.
Over the past few years there has been a community effort to establish patterns to allow people to build large applications in Marionette.
We are exploring ways that we can codify the concepts into the core.

[@jmeas](https://github.com/jmeas/) has done some great work in this area via the creation of a library called [base-router](https://github.com/jmeas/backbone.base-router). We want to take this work and build on top of it to create a router that has some new concepts such as state based routing, and named routes. There will most likely be more features, inspired both from the great ember router and angular ui router.

We then moved onto talking about the `Application` layer of Marionette. Currently it does several things, but is quite generic and does not integrate automatically with the concepts that Marionette already has baked it. (just look at the amount of code needed to kick off a marionette app [demo](http://jsfiddle.net/samccone/F59qp/)). We are planning on more tightly coupling the router to the Application object as well as hardening the concept of an application having a life-cycle.

There was talk of investigating the ability for an applications to contain "sub applications" which are just application objects that are started and stopped automatically depending on their parent app state. This concept should make it quite straightforward to allow you to add significant app complexity without having to engineer a bespoke way to manange application life cycle.

Thoughts, concerns? Want to come chat V3? Come join us!

[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/marionettejs/backbone.marionette?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

> Note that these are early discussions and the final result may be different than what is listed above.

-
[@samccone](http://github.com/samccone)
