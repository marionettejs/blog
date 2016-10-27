title: Easy start with javascript frameworks using Marionette.js
date: 2016-10-27 11:51:00
tags: 
- backbone
- marionette
- learning
- v3
---

This article is going to be helpful for people who just started learn javascript
frameworks. Some of you might be aware about [this](https://hackernoon.com/how-it-feels-to-learn-javascript-in-2016-d3a717dd577f#.tuxjtwlkb) and other articles which are describing how it's hard to dive into javascript world. We decided to write this article to make lives easier for people want join javascript community.

There are a lot of libraries, frameworks, tools and other stuff which might confuse javascript newcomer.
If you knew something about javascript and want to try some javascript framework then we propose [Marionette.js](http://marionettejs.com/).

In this article we will try to create start page creating `html` page and writing some javascript code using Marionette.js without any build tools or other stuff which can confuse you.

> Note: Marionette.js is build on top of [Backbone.js](backbonejs.org) and as Backbone.js can't work without [jQuery](https://jquery.com/), [Underscore.js](http://underscorejs.org/).

Lets write some code!
First of all you have to create `html` page with all needed dependancies.

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
  <title>First application with Marionette.js</title>
</head>
<body>
  <div id="app"></div>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.2.2/jquery.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.8.3/underscore-min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/backbone.js/1.3.3/backbone-min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/backbone.radio/2.0.0/backbone.radio.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/backbone.marionette/3.0.0/backbone.marionette.js"></script>
</body>
</html>
```

> Note: Scripts are loaded using [cdn](https://en.wikipedia.org/wiki/Content_delivery_network), instead of copying files locally.


`#app` is a main region where all content using Marionette.js will be rendered.

Now we need create some javascript file but before doing that we should look at the [documentation](http://marionettejs.com/docs/v3.1.0/marionette.application.html).

So we will extend `Marionette.Application` class to create our own. We use for this inheritance principle.

```javascript
var App = Marionette.Application.extend({
  region: '#app'
});
```

Now we want to show something in our region. We have to create view.
 > Note: [Here](http://marionettejs.com/docs/master/marionette.view.html) docs about views.

```javascript
var View = Mn.View.extend({
  template: '#template-layout'
});
```

Template for View will be placed in scope of body tag. In our small example is used [Underscore template engine](http://underscorejs.org/#template)

```
<script id="template-layout" type="x-template/underscore">
  <div id="content">
    <h1>&nbsp;</h1>
    <h2>Welcome!</h2>
    <ul>
      <li><a href="http://marionettejs.com/">Marionette.js homepage</a></li>
    </ul>
  </div>
</script>
```

To show View in main region lets use `showView` method when application starts.
Final code of Application Class will be:

```javascript
var App = Marionette.Application.extend({
  region: '#app',

  onStart: function() {
    this.showView(new View());
  }
});
```

Lets put all code together in some file, call it `app.js` and include it in `html`.

```javascript

(function() {

  var View = Mn.View.extend({
    template: '#template-layout'
  });

  var App = Mn.Application.extend({
    region: '#app',

    onStart: function() {
      this.showView(new View());
    }
  });

  var app = new App();

  app.start();

})();

```

> Note: All code is put in  [closure](https://developer.mozilla.org/en/docs/Web/JavaScript/Closures) to not let variables get in global scope.

Final working version you can find [here](https://github.com/marionettejs/marionette-integrations/tree/vanilla-example/vanilla).
> Note: It uses ES2015 features.
