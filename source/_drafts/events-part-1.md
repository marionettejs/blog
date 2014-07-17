title: Events (Part 1): A Response to Maciej
tags:
  - by Jmeas
---

Recently, Maciej Kucharski wrote a [blog entry](http://naturaily.com/blog/post/marionette-plain-object-over-reqres-commands-above-all) in which he expresses his preference for using plain Objects over the event-based architecture that Backbone.Wreqr provides. There's nothing wrong with this opinion, and I don't believe that event-based architecture is for everyone. In fact, I'm certain that there are plenty of really well-written Marionette applications that don't use events at all. The thoughtfulness of Maciej's post suggests to me that he, too, is likely the author of such applications.

This post isn't meant to argue that Wreqr is required in all Marionette apps. Rather, it's meant to serve two points. First, it's intended to be a response to his arguments that I feel are either unsound, or otherwise present issues that are solvable. Secondly, it will try to provide good reasons in favor of choosing event-based architecture. These will be split up into two blog posts, one for each topic.

(note: these headers are paraphrases from Maciej's original post)

## "Wreqr has no way of scoping requests or creating hierarchy"

One argument I've been told is that Wreqr doesn't provide a way to scope the events in a robust way. These folks tend to only be using the instances of these Classes that are attached to the Application. I'll refer to this as using the 'global message bus.' The global message bus is a common pattern that I see in Marionette applications. The typical way that one introduces namespacing is using period- or colon-separated strings.

```js
// Namespace this as a notifications event
app.vent.trigger('notifications:show');

// And namespace this as a profile event
app.vent.trigger('profile:show');
```

As Marciej correctly points out in his post, this system involves fragile naming conventions. The problem, as he eloquently puts it, is that it can be difficult to debug when a developer makes a typo, which without question will happen at some point during development.

Debuggable or not, I've also heard that people feel that it just doesn't look nice when you have deeply namespaced strings – and I completely agree. I'd prefer to keep my namespacing outside of my event name as much as possible.

Because of these concerns, we implemented a new feature into Wreqr called Channels, which been a part of Marionette as of version 1.8.4. Channels are best thought of as an explicit way to namespace your code. You access a Channel through the aptly named `channel` method on `Wreqr.radio`. Let's look at an example to see how it works.

```js
var Wreqr = require('backbone.wreqr');

// Let's create a Channel called profile
var profileChannel = Wreqr.radio.channel('profile');

// The instances of EventAggregator, RequestResponse, and Commands are directly on our channel
profileChannel.vent;
profileChannel.reqres;
profileChannel.commands;
```

You can have as many Channels as you'd like. Additionally, the call to `channel` is idempotent. The first time you call it the Channel will be made for you, while subsequent calls return that same Channel. So you can use the Wreqr API to access any Channel from anywhere in your app.

I encourage treating the `channel` method in the same way that one uses `require`. I use it at the top of my files to get all of the Channels my given module needs. When it's used in this way, it seems reasonable to think that requiring knowledge of a Channel's name is not asking any more of you than requiring knowledge of the AMD or CJS module name.

```js
// Require in all of your AMD/CommonJS dependencies
var Wreqr = require('Wreqr');
var Marionette = require('marionette');
var MyChildView = require('./my-child-view');

// Require in your Channel dependencies
var noticesChannel = Wreqr.radio.channel('notices');
var authChannel = Wreqr.radio.channel('auth');
```

Folks who are of the opinion that string-based namespacing isn't very elegant might find this to be a lot nicer. I know that I do.

However, Maciej's original complaint wasn't really about the inelegance of using strings to namespace your events. He's more concerned with the debuggability of events. So do Channels make things any more debuggable? I admit that Channels alone don't help much much with that. But that's not the end of the story – we'll cover debugging momentarily. Before I move on, though, I'd like to discuss this 'global event bus' that he uses in his examples.

### The Global Event Bus

There are three problems I see with the global event bus pattern.

The first is that I dislike when an app's Objects have a dependency on the Application instance itself. I treat my Application instance as the parent of *everything* else in my app. Indeed, through the Application, one has direct access to every Region, Module, and View instance in your Application. It seems like an antipattern for a child to have direct access to this 'ultimate parent.'

This is actually a solvable problem in Marionette v2, as the message buses on the Application are from a Channel named `global`. Let's see how you can access the same channel without needing a reference to the Application at all.

```js
var globalChannel = Wreqr.radio.channel('global');
```

I prefer this because any Object is allowed to access Wreqr. Wreqr isn't the parent of any other Object; it's a separate object that is only meant to act as a means to access Channels. As a rule of thumb, we discourage the practice of requiring in an object for the sole purpose of accessing a Channel that it might have attached to it. Instead, we suggest that you do one of the three things to get a Channel:

1. Use the Wreqr API to get a hook of your Channel. This only works if it's reasonable for your Object to know the name of the Channel.
2. Pass the Channel down to children objects.
3. Create a separate module just for the Channel and require it in that way.

I've used all of these in the past, but I've moved away from the third option in lieu of simply using the first option. In a later post I'll describe when and why I make the distinction between using the first and second methods.

Although this particular problem is solvable, the other two aren't as easily solved.

The second problem I have is one I've mentioned before: it just doesn't read like very nice code when the namespacing becomes deeply nested. This anxiety is no doubt linked with the final problem I have with this pattern, which is that it's actually *more* error-prone than if you use Channels. You will quickly find yourself with long event prefixes and suffixes when you've only got one Channel, which can lead to some convoluted event names. There's no arguing that the more strings you're writing the more likely it is that you'll make a typo. Keeping strings that are used as identifiers short and sweet is very useful when writing evented architecture.

I'd like to pause to fully appreciate that last sentence. For those who choose not to write evented architecture I can understand how such a statement must sound exceptionally silly. If the problem is with strings, then surely the solution must be to get rid of strings altogether, and not just make them shorter! As Maciej pointed out, making a typo when calling a method on a normal Javascript Object yields an Error message, so why deal with the string problem at all? We will come back to this issue when we discuss debugging, which is coming up really soon. I promise!

## "The Wreqr syntax is unwieldy and convoluted"

Absolutely. This is just one of the problems that afflict the Wreqr library, and it's one of the main reasons that led to a complete rewrite of the library. The new library, which has an API that mirrors the simplicity of Backbone.Events, is called [Backbone.Radio](https://github.com/jmeas/backbone.radio) and is scheduled to replace Wreqr in the next major release of Marionette (which is likely many months away). For more on Radio I encourage you to read [my blog post that introduces the library](http://marionettejs.github.io/2014/07/11/introducing-backbone-radio/index.html).

It's my opinion that Radio successfully solves the problem of the downright ugly API of Wreqr. 

## "The Wreqr API looks like you're working with events, but it works differently from events, which is bad."

The problem with this argument is that it assumes that publish-subscribe is the *only* type of event pattern out there. The Wreqr API looks like you're working with events because, well, you are. And this is true whether you're using the EventAggregator, Commands, or RequestResponse.

There's no denying that pub-sub is the most popular message pattern – especially in Javascript – but commands and request-response are also event patterns. They're used in many other contexts, too. In fact, as web-developers we use request-response all the time, given the fact that HTTP is an implementation of request-response. Let's take a look.

```js
// Using jQuery's syntax
$.get('http://api.my-site.com/user-profile');
```

This is identical in form to the request-response implementation that Wreqr provides.

```js
myChannel.request('user-profile');
```

In both cases you use the string as an identifier to request a resource in a decoupled fashion.

As an aside, you might be wondering if POST is also request-response, as it might seem more like a Command. It actually is still using request-response because HTTP can *always* send a response, whereas Commands are forbidden from returning a response. It's best to think of POST and GET as extra data that you're tacking onto your request. To return to the world of Javascript, you could implement the same system by passing either 'POST' or 'GET' as an argument when you make your request.

If you're familiar with HTTP, then Wreqr shouldn't seem unusual to you. And if you believe that HTTP is useful when it comes to to decoupling the client and server, then maybe you'd be willing to consider that the same pattern might be useful within the client-side app itself. But for more on this topic you'll have to wait for the second part of this post!

## "Objects are easier to test than Events"

On this point, I disagree. Maciej's first point – requiring a dependency on the Application – is resolved when you no longer require in the Application to access the global Channel. As for his second point, testing an evented architecture is as easy as providing a mock endpoint for your tests. One of my favorite features of modern, client-heavy webapps is how easy it is to mock the server endpoints for testing. And by using evented architecture this same ease of testing carries over when testing my client code.

## "Wreqr is more difficult to debug than methods on Objects"

Maciej correctly states that Wreqr does not throw errors when you make typos, whereas plain old Javascript methods do. He also makes the claim that this can be useful, and I'm in complete agreement there as well. Using the [DEBUG mode](https://github.com/jmeas/backbone.radio#debug) of Radio allows you to have this same behavior. For this reason the use of strings doesn't bother me so much when it comes to Events; I can still get my Errors if I want them.

Looking to the future, Radio will soon give you even *more* power than you have when calling methods directly on Objects. In the upcoming v0.6.0 release, you will be able to set a method that handles unregistered events on any of your Channels. This allows you to throw an Error if you choose, or route to a different handler, or simply do nothing at all. The choice is up to the developer. This greater flexibility allows for the potential to do more with events than you can with simply calling methods.

The obvious response to this is, 'Could I see some examples?', but I admit that I can't give any right now. It's a feature I've never worked with, so I haven't thought up any particularly clever ways to use it. While it's entirely possible that there are no benefits, I figured it was still worth mentioning. If you can think of any use cases I'd love to hear about them in the comments below.

Ironically, while I included DEBUG mode into Radio I also removed the deferred behavior of Commands, which was the only thing Maciej praised about Wreqr. As ironic as this is, I do believe that removing this behavior was better for the library. This isn't because I think that it's an antipattern, or anything; rather, it's just inconsistent with both the EventAggregator and RequestResponse.

I can definitely see there being a separate library that implements asynchronous versions of all three patterns of Wreqr. [triggerThen](https://github.com/bookshelf/trigger-then) is an example of an asynchronous implementation of Backbone.Events, and [future-vars](https://github.com/Puppets/future-vars.js) is a silly library I wrote while playing around with asynchronous Requests (I don't recommend that anyone use future-vars). Asynchronous Commands would fit in much better if it came bundled with those libraries. Maybe some day...but for now, Radio will remain synchronous.

## Is that it?

At this point I feel like I've adequately responded to all of negative points that I've read about Wreqr. If you agree, however, then it still doesn't follow that you should go out and adopt evented architecture right now. There could still be other arguments against events, and I've yet to give a compelling case *for* adopting events. I've only argued that the reasons above aren't good reasons for *not* adopting Wreqr.

I have a lot to say on this point, but I feel like that's best left as a topic for another blog post. I'm working on this now – part 2 – and I'll be sure to post it once it's done.

In the meantime, if you agree, or disagree, or otherwise have anything to add to what I've said above I'd love to hear about it in the comments below.
