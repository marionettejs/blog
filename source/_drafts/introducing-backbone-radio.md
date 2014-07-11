title: 'Introducing Backbone.Radio'
tags:
- news
- by Jmeas
---

Marionette comes bundled with a library called [Backbone.Wreqr](https://github.com/marionettejs/backbone.wreqr), and in the coming months we will replace it with a new library by the name of [Backbone.Radio](https://github.com/jmeas/backbone.radio). Radio is heavily inspired by Wreqr, but it was rewritten from the ground up.

I wouldn't be surprised if you're unacquainted with Wreqr. In fact, I would wager it's one of the lesser-used pieces of Marionette. I blame this on the fact that it lives in a separate repository and is only mentioned in the Marionette documentation in passing (shameless plug: brand new Marionette docs are on the way!).

This post will outline our decision to rewrite and replace Wreqr. But first, because of the relative obscurity of the library, I feel the need to give a brief introduction to what it is and the problem that it intends to solve.

### What is Backbone.Wreqr?

Backbone.Wreqr is a collection of three messaging patterns. Large applications with many pieces need to solve the problem of how those pieces interact. Wreqr can be used to structure those interactions. An application that leans heavily on Wreqr would be considered an event-driven application.

There's much interesting discussion about the pros and cons of event-driven architecture, but it's beyond the scope of this post to get into those things. For those interested, Google has a plethora of information on the subject. I encourage you to run some searches to read more about it.

### Why rewrite Wreqr?

The decision to rewrite a library is a risky one, and it's not an option I would normally consider for a library as popular as Marionette. The primary concern, of course, is that we might fragment the community by making changes that prevent developers from ever updating their applications.

We think that the risk of fragmentation with this rewrite is low. Firstly, the fact that so few people use Wreqr is advantageous. Secondly, and more importantly, updating from Wreqr to Radio should be pretty straightforward. All of the old functionality is being transferred over*, and the changes to the API are essentially renamed methods. In fact, the [Marionette.Upgrade tool](https://github.com/marionettejs/Marionette.Upgrade) should be able to handle this upgrade automatically for you once it's time to do it.

Also, because of the brand new API and the desire to give the library a different name, we decided that creating a separate project was a better choice than making this an update to Wreqr.

\* *One bit of undocumented, inconsistent functionality from Commands has been removed. Specifically, Commands handlers that are added after you've made the call to that command will no longer be executed. You can only order commands that already exist.*

### The benefits of Radio

There are a large number of benefits to Radio, and I won't get into all of them here. But I will cover a few of the bigger ones.

One benefit of Radio is that it's a lot smaller than Wreqr. In fact, at feature parity with Wreqr, it was 40% the size. But we went even further by adding a handful of new features to it – and it still came out smaller! So we're really happy that Marionette will become smaller *and* have more functionality when we make the swap.

The biggest new feature is a [collection of properties and methods](https://github.com/jmeas/backbone.radio#debug) that should help you debug your application during development.

The `DEBUG` property will send a warning to the console when a section of your code calls an unhandled command or request, and also when you try to unregister a command or request that was never registered. This will help ensure that your event names are typed correctly, which is a common problem people have when working with event-driven architecture.

Another benefit, and maybe the most noticeable, is the cleaner API. One poor design decision of Wreqr is that the API for Commands and RequestResponse are identical. This prevented one from merging instances of the two messaging systems onto the same Object. The consequences of this were the ugly instance names that you might be familiar with: `vent`, `commands`, and `reqres`.

```js
var profileChannel = Backbone.Wreqr.radio.channel('profile');

// Because the APIs conflict, we need to store our
// instances as properties. If only we could attach the
// API directly on the channel...
profileChannel.vent;
profileChannel.reqres;
profileChannel.commands;
```

With Radio, there are no API conflicts, so we've done away with the instance names altogether.

```js
var profileChannel = Backbone.radio.channel('profile');

// The API is directly on the channel.
// So, for instance, there's no more profileChannel.vent!
profileChannel.listenTo(...);

```

You'll need to learn the new API for Commands and Requests, but I think developers will find it even easier to remember than before. Let's take a look at registering a handler for Commands.

```js
// Before:
profileChannel.commands.setHandler('update:profile', updateProfile);

// Now:
profileChannel.comply('update:profile', updateProfile);
```

Ordering the Command later:

```js
// Before:
profileChannel.commands.execute('update:profile', newSettings);

// Now:
profileChannel.command('update:profile', newSettings);
```

In general you'll find that the API is far less verbose than it was before. Let's look at one last example, listening in on a channel:

```js
// Before:
myView.listenTo(profileChannel.vent, 'update:profile', onUpdateProfile);

// Now:
myView.listenTo(profileChannel, 'update:profile', onUpdateProfile);
```

We think this cleaner API will make your code clearer and less cluttered, while also being more pleasant to work with.

### Should I use Radio now?

Unfortunately, it's not that easy to switch to Radio in Marionette v2.0. However, a change in the upcoming v2.1 (with a release date of 7/29/14) will make it much easier to make the swap if you choose.

So what about when v2.1 is available? We definitely encourage you to give it a try! The API is stable, and it's being used in production applications just fine. Do note that you'll need to update your build system to pull in Radio instead of Wreqr. To do this, you'll need to use the 'core' build of Marionette, which doesn't include Wreqr or Babysitter, and then manually pull in Radio and Babysitter.

If you don't have the time to refactor just yet, don't worry. As I mentioned before, we will do all that we can to make the update process as simple as can be.

So that concludes this introduction to Backbone.Radio. I hope you're as excited for this new library as we are.

Are you using Backbone.Wreqr in your Applications? Let us know about it in the comments below.
