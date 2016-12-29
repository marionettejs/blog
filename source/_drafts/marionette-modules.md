title: A Treatise on Marionette Modules
tags:
---

Marionette Modules have been the topic of much discussion lately. If you've been hanging around [Gitter](https://gitter.im/marionettejs/backbone.marionette) you might have heard rumors that they're being deprecated, or if you've been keeping up with the blogs you might have read [Derick's formal apology](http://derickbailey.com/2014/06/10/browserify-my-new-choice-for-modules-in-a-browser-backbone-app/) for having added them to Marionette in the first place.

I think Derick is selling himself a bit short in that post when he calls them 'the clunkiest module system ever written.' Instead, I think there just needs to be a bit of clarity around the Class. I'm frequently told by folks that they don't feel confident about how they use Modules, and I don't blame them. I recognize that our documentation simply doesn't do a good job at explaining patterns for working with Marionette Modules.

We're hard at work on new documentation for all of Marionette, including Modules, but I felt the need to provide the community with something in the interim, which is what this post is for.

Derick introduced Modules with two use cases in mind, which you might have inferred from the post I linked above. The first is namespacing code, and the second is using them as sub applications.

### Modules as Namespaces

The first use case for Modules, and perhaps the most popular, is namespacing. They were intended to solve a problem that must be dealt with whenever you write Javascript in the browser: where should you place your Objects? It's well-known that there a number of issues with attaching everything to the `window`, so that won't do. The answer that Marionette Modules provide is to treat everything as a Module, and to hang them from the Application instance.

Before I continue, let me first say that it is the opinion of the Marionette core that there are much better solutions for namespacing than Marionette Modules, namely AMD and CommonJS. We will get to that, but first let's take a look at namespacing without, and then with, Marionette Modules.

```js
// Namespacing without Marionette Modules

// First, let's make our root namespace
var app = {};

// We're building an inbox component, so let's start by making an Inbox namespace
app.Inbox = {};

// Specifically, we're buiding the Emails section of the Inbox, so let's make another namespace
app.Inbox.Emails = {};

// Now let's add a view to that Inbox
app.Inbox.Emails.EmailView = View.extend({});

// And a model
app.Index.Emails.EmailModel = Model.extend({});
```

For simple applications the above code is a fine solution, and this is often the approach taken by small Javascript libraries. Marionette Modules provide a bit of convenience for working with this on a larger scale. Let's see how we do that same code with Marionette:

```js
// Namespacing with Marionette Modules

// First, let's make a Marionette Application
var app = new Marionette.Application();

// Now let's make our Inbox Module, and attach things to it
app.module('Inbox.Emails', function() {

  // Create our EmailView
  this.EmailView = Marionette.View.extend();
 
  // And our EmailModel
  this.EmailModel = Backbone.Model.extend();
});

// We can now access things in the same way as without Marionette Modules
app.Inbox.Emails.EmailView;
app.Inbox.Emails.EmailModel;
```

This simple example does a good job at showing the basics of the Module API. It might be self-explanatory, but to clarify you pass a string as the name, which is the namespace of your Module.

You can pass period-separated names to create deep nesting on the fly, which is a big improvement over the previous example.

The second argument is an anonymous function that acts as the 'constructor' for that Module. The value of `this` within the constructor is the Module itself.

As an Applications grow large it's common to separate Object definitions into individual files. Marionette Modules provide some convenience for doing this, too, and it's the following usage that is the most common.

```js
// inbox/email-view.js

app.module('Inbox.EmailView', function() {
  var EmailView = Marionette.ItemView.extend({
    // My view definition
  });
  
  return EmailView;
});
```

```js
// inbox/email-model.js

app.module('Inbox.EmailModel', function() {
  var EmailModel = Backbone.Model.extend({
    // My model definition
  });
  
  return EmailModel;
});
```

For those of you who are familiar with David Sulc's book or Brian Mann's tutorials, the above code might be familiar. Both of those developers choose to use this pattern to organize their code in their examples.

Marionette Modules are one of the simplest ways to solve the namespacing problem, and I contend that it's a major improvement over the examples where we weren't using them.

With that said, I'll repeat that the official stance of the Marionette team is that **you should not use Marionette Modules to namespace your code**. Once again, the reason is that there are far better options available to you: AMD or CommonJS. These options not only solve the issue of namespacing, but they also resolve your dependencies for you, which is a huge plus for large applications. In a world without AMD or CommonJS, Marionette Modules do provide some utility. But we believe that they're essentially made obselete by these alternative module systems.

The one downside is that the switch to AMD or CommonJS doesn't come for free. For production environments you will need to add an extra step to your build system, which can sometimes take a bit of work. Marionette Modules, on the other hand, don't require a build system at all. You can simply concatenate your files and serve them up, and they're ready to go. Because of this, the barrier of entry for Marionette Modules is a great deal smaller than AMD or CommonJS, which may be why some developers still choose to use them (and likely the reason why Brian Mann and David Sulc use them in their guides).

Nevertheless, the Marionette core – Brian Mann included – encourage you to pursue adopting AMD or CommonJS in your applications in lieu of Marionette Modules as namespace objects. But we do understand that there might be circumstances that prevent you from making the switch. Perhaps your app is simply too large to transition in a reasonable amount of time, or maybe you don't have the time to learn AMD or CommonJS. We're sympathetic to these possibilities, so we won't be dropping support for the feature in the foreseeable future.

Instead, we're calling this feature 'Separately Supported.' Separately Supported features are things that are being removed from the core library, but will be maintained in a separate, standalone repository. These Separately Supported libraries will be compatible with every foreseeable release of Marionette, and will also be maintained by the Marionette core team.

This separate library isn't available now, but it will be well before we remove this functionality from Marionette. An exact timeframe for a release is difficult for me to give, but the earliest it will appear is 3 months from now, and as long as 9 months from now.

In summary, we suggest that you move away from this pattern, but there's nothing to fear if you're unable to make the switch.

### Modules as Sub-Applications

I think that Modules as namespaces was more than enough for a single Class, but Derick went on to add a separate set of functionality to them on top of namespacing. That functionality is the lifecycle, or start and stop states, which allows your modules to act as little mini Applications, or sub-apps.

Before I continue, let's talk about the Router and application state for a moment. The Router is a [state machine](http://en.wikipedia.org/wiki/Finite-state_machine) that represents the state of your web application. If you're unfamiliar with state machines, don't worry. State machines are things with any number of states (URLs, in our case), that are in a single one of those states at a given time (the current URL, in our case). State machines can transition between states when things happen, such as when the user clicks a link.

Returning to modules: giving modules a lifecycle allows you to tie them into your overall application state. When the user navigates to a particular route you can start up a module, and when they navigate away you can stop the module. Your modules become sub applications that live within your main application.

Starting and stopping a module is as simple as calling the corresponding method on it.

```js
// Create our module (it will start automatically)
var profileModule = app.module('profile');

// Stop it
profileModule.stop();

// Start it again
profileModule.start();
```

By default, modules start with their parent. This is important behavior because it allows the separation of modules as namespace objects and Modules as subapps. When you're using Modules as namespaces you want them to start right when the Application starts. But when used as subapps you tend to set `startWithParent` to false so that you can synchronize their lifecycle with the router.

Let's take a look at an example of how one might use a Module as a subapp. In this example, we're going to make a simple Gmail subapp that will be started when the user navigates to `/gmail` and stopped when they navigate away.

*Note that the code here is simply to illustrate the concepts behind Modules as lifecycle objects. It isn't meant to serve as recommended Marionette application code.*

```js
// Get our dependencies
var Gchat = require('gchat');
var InboxView = require('inbox-view');
var mainRegion = require('main-region');
var sidebarRegion = require('sidebar-region');

// Define the ModuleClass itself
var Gmail = Marionette.Module.extend({

  // Start is called when we transition into the gmail state
  onStart: function() {
    // Create instances of the pieces of this module
    this.gchat = new Gchat(gchatOptions);
    this.inboxView = new InboxView(inboxViewOptions);
    
    // Show the views in the designated Regions
    mainRegion.show(this.inboxView);
    sidebarRegion.show(this.gchat);
  },
  
  // Stop is called when we transfer out of the gmail state
  onStop: function() {
    // Call destroy on our dependencies. This clears them up and readies them for garbage collection
    this.gchat.destroy();
    this.inboxView.destroy();
    
    // Delete the references so that they can be garbage collected
    delete this.gchat;
    delete this.inboxvView;
  }
});

// Export our Gmail Module
return Gmail;
```

We can attach this module to our Application using the object literal definition syntax:

```js
// Require in the Class we just defined
var Gmail = require('gmail');

// Instantiate it
var gmail = app.module('gmail', {
  moduleClass: Gmail
  startWithParent: false
});
```

By setting `startWithParent` to be false we've made it so Gmail won't start when the application starts. We can add some event handlers or route callbacks to configure when to call start and stop on Gmail, when, presumably, would relate to the `/gmail` route.

Marionette Modules as subapps makes a lot of sense to the Marionette core. Even if you're not using Modules as subapps, it's likely that you've adopted your own subapp system in your Marionette application. For this reason we will be expanding on the subapp functionality of Modules in Marionette.

Given the similarity of Modules and Applications when used in this way, we've considered merge the two Classes into one. But we're still months away from this update, so we're still in the early prototyping stage, and nothing is really too certain about the direction we will head in.

So what does this mean if you're using the Application and Module now? Should you stop, or will it be impossible for you to upgrade? I would say that the answer is no. You don't need to stop, and I think we will be able to continue supporting you.

The reason behind this is because the Module and Application Classes are surprisingly lightweight right now. If you're tying these objects into the Router you've likely written a great deal of your own code to do so. I would guess most applications these days just need an object that can be started and stopped, which will be easy to provide for you.

### Other Uses of Modules

My subapp example above showed just one pattern for working with Marionette Modules. There are a number of other patterns I've seen in the wild. One noteworthy alternative is treating each component as a subapp. So, for instance, `gchat` would itself be a Module that we attach to our `gmail` module. I choose to use the initialization and destroy pattern to manage the state of my individual components, rather than treat them as modules. It's just a matter of taste which you prefer; I don't strongly believe that one is more correct than the other.

### Using Modules with AMD/CommonJS

A common question we're asked is whether or not Marionette Modules make sense with AMD or CommonJS. The above hints at the answer, but to be explicit: yes and no. Modules as namespace is really a stand-in for AMD and CommonJS, and the feature sets overlap. So if you choose to use Modules as namespace then I don't see AMD or CommonJS as a good fit for your Application. On the other hand, Modules as lifecycle objects **does** make a lot of sense when used in conjunction with AMD or CommonJS.

### In Closing

I hope this post was successful in clearing up some of the questions you may have had about Marionette Modules. We're curious to know how you're using Modules in your Application? What would you like us to see for the future of Marionette Modules? Let us know in the comments below!
