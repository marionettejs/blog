title: Using Radio to show Notifications
tags:
  - tutorials (intermediate)
  - by Scott Walton
date: 2016-12-28 17:00:00
---

This post is a simple tutorial showing how I implement a global notification
system (also called alerts) using Marionette's `Radio` and `Region` classes. For
the notifications themselves, I will assume a Bootstrap-like styling.

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

## Using Notifications from Views
