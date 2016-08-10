title: Marionette.js v3. Getting started with new version 
date: 2016-08-10 21:19:00 
tags: 
- backbone
- marionette
- learning
- v3

---

New version of `Marionette.js` framework was released.

Welcome to the party
for people who know this cool framework and
for someone who are not so much.
We will go through all new changes which v3 brought us.


## View

Version 2.x had a lot of different kind of views: `View`, `ItemView`,
`LayoutView`, `CollectionView`, `CompositeView`.

In version 3 `View`, `ItemView`, `LayoutView` were 'merged' into `View`,
`CompositeView` became deprecated, so this list of views was reduced and
now we have just `View` and `CollectionView`.

Here some simple examples:

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
The same how `LayoutView` did.

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
  	this.showChildView('region1', myView1);
    this.showChildView('region2', myView2)
  }
});
const myView = new MyView();

myView.render();
````

[Live example](https://jsfiddle.net/599dtsb7/26/)


#### How can I build table or tree without `CompositeView`?

If you build your table or tree using `CompositeView` just take a look [here](http://marionettejs.com/docs/v3.0.0-pre.5/marionette.collectionview.html#rendering-tables)
how easy migrate on using `View` and `CollectionView`.


### View events

Since `version 3` there are no `show`, `before:show` events on the view,
so you can use on `render`, `before:render` events.
You can see [here](http://marionettejs.com/docs/v3.0.0-pre.5/marionette.view.html#lifecycle-events)
all view lifecycle.

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

You can see [here](http://marionettejs.com/docs/v3.0.0-pre.5/marionette.view.html#lifecycle-events)
all view lifecycle.


#### Events of a child views

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


### Templates

`templateHelpers` property was renamed on `templateContext`.
So you just have to rename this if you used old one.


## Backbone.Radio

This awesome lib became part of Marionette.js instead of `Backbone.Wreqr`.
[Read more](http://blog.marionettejs.com/2014/07/11/introducing-backbone-radio/index.html)
why it was decided to be replaced.

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
became a core part of `Marionette.js`.
Don't worry it's still supported as library so you can use it separately in your
`Backbone.js` applications.


## API

API also got some changes;
Here list of deprecated methods:

* `proxyGetOption`
* `proxyBindEntityEvents`
* `proxyUnbindEntityEvents`
* `normalizeUIKeys`
* `normalizeUIValues`
* `actAsCollection`


New methods:

* `bindRequests`
* `unbindRequests`
* `deprecate`
* `isEnabled`
* `setEnabled`
* `monitorViewEvents`

Take a look at the [API doc](http://marionettejs.com/docs/v3.0.0-pre.5/marionette.functions.html)
to see purpose of use.

We would strongly recommend to look at [Marionette guide](https://www.gitbook.com/book/marionette/marionette-guides/details),
[simple setups wth different build tools](https://github.com/marionettejs/marionette-integrations) and [additional resources](http://marionettejs.com/additional-resources/)
to build awesome stuff using Marionette.js v3.

Thank you everyone for contribution and helping v3 out! Cheers!
