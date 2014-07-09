title: Backbone.Radio
date: 2014-07-05 11:56:50
tags: news
---
![Backbone.Radio](backbone-radio.svg)


Introducing [BB.Radio](https://github.com/jmeas/backbone.radio)! It will replace [Backbone.Wreqr](https://github.com/marionettejs/backbone.wreqr) down the road in Marionette, so why not start playing with it?

### Benefits:
1. Cleaner API
2. More features and is still smaller than Wreqr
3. Embraces the fact that commands, requests, and events are supposed to be siblings, so the APIs of all 3 systems are basically identical in form 

### Differences:
The API is directly on globalChannel, so basically, `myChannel.vent`, `myChannel.reqres`, and `myChannel.commands` becomes `myChannel`.

### Events

BEFORE                 | AFTER
:--------------------- | :---------------- 
myChannel.vent.trigger | myChannel.trigger 
myChannel.vent.on      | myChannel.trigger 

### Requests

BEFORE                      | AFTER
:-------------------------- | :----------------
myChannel.reqres.request    | myChannel.request
myChannel.reqres.setHandler | myChannel.reply  

### Commands

BEFORE                        | AFTER
:---------------------------- | :----------------
myChannel.commands.execute    | myChannel.command
myChannel.commands.setHandler | myChannel.comply 

### Listening in on the Message Bus

BEFORE                                                  | AFTER
:------------------------------------------------------ | :-----------------------------------------------------
this.listenTo(globalCh.vent,  ‘some:event’, myCallback) | this.listenTo(globalChannel, ‘some:event’, myCallback)
