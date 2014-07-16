title: Meeting Notes (7.15.14)
tags: notes
---

The Marionette team meets privately every Tuesday at 5:30PM EST to discuss all things Marionette related.

## Attendees

[samccone](https://github.com/samccone), [thejameskyle](https://github.com/thejameskyle), [jfairbank](https://github.com/jfairbank), [cmaher](https://github.com/cmaher), [ahumphreys87](https://github.com/ahumphreys87), [jmeas](https://github.com/jmeas)

### Upcoming 2.1 Release

The next minor release of Marionette is scheduled to be in 2 weeks, so we discussed our plan to meet that release date. We decided that we won't be merging any new features into `v2.1` since it's already quite large. All outstanding new feature requests have been pushed to `v2.2`.

Next Tuesday we'll be releasing `v2.1-alpha` for the early adopters.

### Documentation

Our current priority is to update the website and documentation. We laid out our plan of attack for the next phase of the Marionette documentation. We'll be using [dox](https://github.com/visionmedia/dox) to generate the new API documentation, and we're tracking our progress of adding the inline documentation on [#1652](https://github.com/marionettejs/backbone.marionette/issues/1652).

### pickOption

We discussed a means to implement `pickOption` in a way that prepares us to move away from supporting `this.options`. The idea was proposed to have a private property, `_mergeOptions`, that is ultimately what is merged onto the Object. Then, objects on the prototypal chain would have access to methods to add, remove, and get values from that array.

The issue was brought up that it might not be possible to support this functionality while also supporting a declarative approach to the `mergeOptions` array on our Classes without modifying Backbone's extend method, which isn't something we're interested
in doing.
