title: Marionette.js v3. Getting started with new version 
date: 2016-08-10 21:19:00 
tags: 
- backbone
- marionette
- learning
- v3

---

Welcome to the party.

The main goal of Marionette v3 was to clean up and simplify the API.
The library was converted to ES6 and organized for easier contribution.
Marionette v3 is both smaller and faster than v2.x.

In future major releases we hope to improve the performance and simplify further.

Let's go through some of the changes in v3.

## View

Version 2.x had many different kinds of views: `View`, `ItemView`,
`LayoutView`, `CollectionView`, `CompositeView`.

In version 3 `ItemView`, and `LayoutView` were 'merged' into `View`,
and `CompositeView` was deprecated for removal in v4.
Now we have only `View` and `CollectionView`.

Here are some simple examples:

````js
import Mn from 'backbone.marionette';

const template = _.template('<h1>Marionette says hello!</h1>');
const MyView = Mn.View.extend({
  el: 'body',
  template: template
});
const myView = new MyView();

myView.render();
````

[Live example](https://jsfiddle.net/599dtsb7/24/)


#### How does `View` handle regions?
The same as `LayoutView` did however regions are no longer attached 
directly to the view.

````js
import Mn from 'backbone.marionette';

const template1 = _.template('<h1>Marionette says hello!</h1>');
const template2 = _.template('<h1>Marionette is awesome!</h1>');

const myView1 = new Mn.View({template: template1});
const myView2 = new Mn.View({template: template2});

const MyView = Mn.View.extend({
  el: '#container',
  template: false,
  regions: {
    region1: '#region1',
    region2: '#region2'
  },

  onRender() {
    // Since in v3 regions are no longer attached to the view
    // this.region1.show(myView1) will throw an error saying 
    // show is not a function on undefined (region1).
    this.getRegion('region1').show(myView1);
    this.showChildView('region2', myView2); // Preferred method for showing child views
  }
});
const myView = new MyView();

myView.render();
````

[Live example](https://jsfiddle.net/599dtsb7/26/)


#### How can I build table or tree without `CompositeView`?

If you build your table or tree using `CompositeView` just take a look [here](http://marionettejs.com/docs/v3.0.0/marionette.collectionview.html#rendering-tables)
to learn how to easily migrate to using `View` and `CollectionView`.


### View events

In version 3 the region events `show` and `before:show` are no longer triggered
on the view. You can use `render` and `before:render` events in most cases. If
you need to know that the view is in the DOM then you can use `attach` or `dom:refresh`
which is triggered after the attach event and every _subsequent_ `render` event.
Learn more about view lifecycle events [here](http://marionettejs.com/docs/v3.0.0/marionette.view.html#lifecycle-events).

````js
import Mn from 'backbone.marionette';

const template = _.template('<h1>Marionette says hello!</h1>');
const MyView = Mn.View.extend({
  el: 'body',
  template: template,

  onBeforeRender() {
    console.log('Before render')
  },

  onRender() {
    console.log('Render')
  },
});
const myView = new MyView();

myView.render();

````
[Live example](https://jsfiddle.net/599dtsb7/25/)


#### Child views events

The `childEvents` attribute was renamed to `childViewEvents`.

````js
import Mn from 'backbone.marionette';

const template1 = _.template('<h1>Marionette says hello!</h1>');
const template2 = _.template('<h1>Marionette is awesome!</h1>');

const myView1 = new Mn.View({template: template1});
const myView2 = new Mn.View({template: template2});

const MyView = Mn.View.extend({
  el: '#container',
  template: false,
  regions: {
    region1: '#region1',
    region2: '#region2'
  },
  childViewEvents: {
    'render': function() {
      //this will be called twice because there are 2 childView which trigger `render` event
      console.log('ChildView was rendered');
    }
  },


  onRender() {
    this.showChildView('region1', myView1);
    this.showChildView('region2', myView2);
  }
});
const myView = new MyView();

myView.render();
````

[Live example](https://jsfiddle.net/599dtsb7/27/)


#### Proxied events do not append `this` by default

In Marionette v2 all events that were proxied to the parent prepended the child view as the
1st argument of the event. In v3 this is no longer the case. All internally triggered events
will prepend the childView as the 1st argument, but custom triggered events won't by default.

````js
import Mn from 'backbone.marionette';

const template1 = _.template('<h1>Marionette says hello!</h1>');

const myView1 = new Mn.View({template: template1});

const MyView = Mn.View.extend({
  el: '#container',
  template: false,
  regions: {
    region1: '#region1'
  },
  onRender() {
    this.showChildView('region1', myView1);
    myView1.triggerMethod('foo', 'bar');
  }
  onChildViewFoo: function(childView, myArg) {
    // In Marionette v2 childView === myView1 and myArg === 'bar'
    // In Marionette v3 childView === 'bar' and myArg === undefined
  }
});
const myView = new MyView();

myView.render();
````

### Templates

`templateHelpers` property was renamed to `templateContext`.

## Controller

`Marionette.Controller` was removed. Use `Marionette.Object`

## Application

Application now only accepts a single region instead of acting more as a `LayoutView`.
Also initializers were removed. Use the `start` event to initialize other classes.
Last the global wreqr channels on `Application` were removed. Use `Backbone.Radio` channels.

## Module

`Marionette.Module` was removed. A modern module loader such as browserify or webpack is preferred.
However there is a shim for `Marionette.Module` available [here](https://github.com/marionettejs/marionette.module).


## RegionManager

`Marionette.RegionManager` was removed. This publicly exposed class was mostly used as a common
class used between `LayoutView` and `Application`.

## Backbone.Radio

`Backbone.Wreqr` was replaced with `Backbone.Radio`
[Read more](http://blog.marionettejs.com/2014/07/11/introducing-backbone-radio/index.html)
on why we decided to replace it.

````js
import Mn from 'backbone.marionette';
import Radio from 'backbone.radio';

const channel = Radio.channel('notify');

const Notification = Mn.Object.extend({
  initialize: function() {
    channel.reply('show:message', this.showMessage);
  },

  showMessage: function(msg) {
    alert(msg)
  }
});

const notify = new Notification();

const MyView = Mn.View.extend({
  template: false,

  onRender: function() {
    channel.request('show:message', 'View was rendered');
  }
});

const myView = new MyView();

myView.render();
````

[Live example](https://jsfiddle.net/599dtsb7/28/)


## Backbone.BabySitter

`Backbone.BabySitter` which was a fundament for managing child view,
became a core part of `Marionette.js`, and is no longer a dependency of Marionette.
Don't worry if you use it directly, it's still a supported library so you can use it
separately in your `Backbone.js` applications.

## Marionette's bundled build

Marionette now only has a single build and requires Radio as a dependency.

## Other changes

For additional information check out the [upgrade guide](https://github.com/marionettejs/backbone.marionette/blob/next/docs/upgrade.md).
The [Marionette v3 compat tool](https://github.com/marionettejs/marionette-v3-compat#available-patches) also details the breaking changes in its documentation.

We would strongly recommend looking at [Marionette guides](https://www.gitbook.com/book/marionette/marionette-guides/details),
[simple setups wth different build tools](https://github.com/marionettejs/marionette-integrations) and [additional resources](http://marionettejs.com/additional-resources/)
to build awesome stuff using Marionette.js v3.

Thank you everyone for your contributions and helping v3 out! Cheers!
