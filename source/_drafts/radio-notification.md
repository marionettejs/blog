title: Using Radio to show Notifications
tags:
  - tutorials (intermediate)
  - by Scott Walton
date: 2016-12-28 17:00:00
---

This post is a simple tutorial showing how I implement a global notification
system (also called alerts) using Marionette's [`Radio`][radio] and [`Region`][region]
classes. For the notifications themselves, I will assume a Bootstrap-like styling.

Global notification systems are a helpful way to tell a user that some global
state has changed. A common case that always comes up is responding to a form
submission, success or error. We'll use this as our example implementation that
should also help you see how you can use Radio as a simple bus system.

## Defining the API

When working with the Radio, I like to provide a rough API definition that I use
to help my team (and myself later!) know how this is supposed to be used. For a
notification system, I like to use the Command pattern which, in Radio, is just
`request` without a response for `reply`.

| Channel  |    Message Name   |    Args   |
|----------|-------------------|-----------|
| `notify` |   `show:success`  | `message` |
| `notify` |    `show:error`   | `message` |
| `notify` |       `clear`     |           |

This simple definition lets us do:

```js
import Radio from 'backbone.radio';

const channel = Radio.channel('notify');
channel.request('show:success', 'The operation completed successfully');
channel.request('clear');
```

This should show a success notification with the above text included. The
`clear` call will remove the notification.

## Building the Notification System

For this system, we will manage the notifications from a custom `Region`. We use
`Region` here as it extends from `Object`, which is already directly integrated
into Radio and will set up your listeners for you.

```js
import {Region} from 'backbone.marionette';

import {NotificationModel} from './models';
import {NotificationView} from './views';


export const NotificationRegion = Region.extend({
  el: '#notify',
  channelName: 'notify',

  // Bind a model that will store the notification state.
  initialize() {
    this.model = new NotificationModel();
  },

  // Automatically bind our show/hide requests.
  radioRequests: {
    'show:error': 'showError',
    'show:success': 'showSuccess',
    'clear': 'clear'
  },

  // Show the error message.
  showError(message) {
    this.model.set({
      alertType: 'error',
      message: message
    });
    this.showView();
  },

  // Show a success message.
  showSuccess(message) {
    this.model.set({
      alertType: 'success',
      message: message
    });
    this.showView();
  },

  // Show the notification view.
  showView() {
    // No-op if a view is being shown already.
    if (this.hasView()) {
      return;
    }
    const notificationView = new NotificationView({model: this.model});
    this.show(notificationView);
  },

  // Remove the notification view and clear the underlying model.
  clear() {
    this.model.set({
      alertType: '',
      message: ''
    });
    this.empty();
  }
})
```

### View Code

The View code for this is fairly straightforward. I've included the template
directly in the view itself, though it's not strictly necessary.

```js
import {View} from 'backbone.marionette';
import {template} from 'underscore';


export const NotificationView = View.extend({
  className() {
    return `alert alert-${this.model.get('alertType')}`;
  },

  template: template('<%- message %>'),

  modelEvents: {
    change: 'render'
  }
});
```

### Model Code

The model is also trivial in this case - just some defaults. You can obviously
include more logic here if you feel it's necessary.


```js
import {Model} from 'backbone';


export const NotificationModel = Model.extend({
  defaults: {
    alertType: '',
    message: ''
  }
});
```

### Wiring It Up

With the notification code roughly in place, I now just need to make sure the
region is wired up and able to show notifications to the user. I'll quickly run
through my standard Marionette application setup and highlight the parts where
I've hooked the notifications in.

```js
// Driver
import {template} from 'underscore';
import {Application, View} from 'backbone.marionette';

import {NotificationRegion} from './notification/region';

// Primary Layout View.
const Layout = View.extend({
  template: template('<div id="notify"></div>'),  // Add hooks for rest of app.

  regions: {
    notification: NotificationRegion  // Include other regions here.
  }
});


const ExampleApp = Application.extend({
  region: '#application',

  onStart() {
    this.showView(new Layout());  // Initialize everything.
  }
});


// Start the application.
const application = new ExampleApp();
application.start();
```

I've skipped over the rest of the application. You'll need to include regions
for the rest of your application e.g. navbars, the main view for this to be
fully functional.


## Using Notifications

Now, to use this system, you can just access the Radio channel from anywhere in
your app and the `NotificationRegion` will show notifications based on your
input. Let's see a simple example to show a model save failed:

```js
import {template} from 'underscore';

import {View} from 'backbone.marionette';
import Radio from 'backbone.radio';


export const ExampleView = View.extend({
  tagName: 'form',

  template: template('<input name="username" id="id_username"><button>Save</button>'),

  ui: {
    username: '#id_username'
  },

  events: {
    submit: 'saveForm'
  },

  modelEvents: {
    sync: 'saveSuccessful',
    error: 'error'
  },

  saveForm() {
    this.model.save({
      username: this.getUI('username').val()
    });
  },

  saveSuccessful() {
    const channel = Radio.channel('notify');
    channel.request('show:success', 'User created successfully');
  },

  error() {
    const channel = Radio.channel('notify');
    channel.request('show:error', 'An error occurred creating the user');
  }
});
```

Now, whenever you save your form, the application will either show a success or
error message based on the server response. You could add an `invalid` hook as
well if your model includes client-side validation.

## Conclusion

You should now have a good grasp on how you can use the Radio as a global
message bus to show notifications in a totally unrelated part of your app. This
pattern isn't constrained to just notifications - anywhere you need to send/receive
information across your application is ripe for the Radio pattern.

### Future Improvements

Some potential improvements to try out yourself:

* Use a [`Behavior`][behavior] to make it easy for multiple views to respond to form saving
* Use a `Collection` and [`CollectionView`](collectionview) to show multiple notifications at once

## Get in Touch!

As always, if you have any questions, pop in on [Gitter][gitter] and we'll be
happy to help!

[behavior]: http://marionettejs.com/docs/v3.1.0/marionette.behavior.html
[collectionview]: http://marionettejs.com/docs/v3.1.0/marionette.collectionview.html
[radio]: http://marionettejs.com/docs/v3.1.0/backbone.radio.html
[region]: http://marionettejs.com/docs/v3.1.0/marionette.region.html
