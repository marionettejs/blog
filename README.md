# Marionette Blog
![screenshot](logo.png)

### This blog is built using [Hexo](http://hexo.io).

### Steps to get it running:

##### 1. Fork this repo
##### 2. `npm install`
##### 3. To create a new post in markdown: `hexo new draft <filename>`
##### 4. Edit the file with your file name in this directory: [\_drafts](https://github.com/marionettejs/blog/tree/master/source/_drafts)
##### 5. Edit your title at top of the file
##### 5. Add a category at the top of the file so that it can be filtered, choose from:
* `tags: news`
* `tags: releases`
* `tags: tutorials (beginner)`
* `tags: tutorials (intermediate)`
* `tags: tutorials (advanced)`
* `tags: meeting notes`
* `tags: behind the scenes`

*Note: Make sure you add a space after the colon*
##### 6. To edit a post that has been **published**, edit the file in this directory: [\_posts](https://github.com/marionettejs/blog/tree/master/source/_posts)
##### 7. Turn on the server: `hexo server` (if port 5000 is being used already, try `hexo server -p 4000`)
##### 8. Preview your post at: [localhost:5000](http://localhost:5000)
##### 9. Once you're satisfied with your changes, send a pull request
##### 10. To publish a post (moves post from [\_drafts](https://github.com/marionettejs/blog/tree/master/source/_drafts) to [\_posts](https://github.com/marionettejs/blog/tree/master/source/_posts) directory): `hexo publish <filename>`


### Adding Images
There's a matching folder with the same name as your post. Save you image(s) in that folder.

##### To link to the image:

    ![alt text](/path/to/img.png "Title")

### Code Highlighting


##### Backtick code block

    ``` [language]

        code snippet

    ```

##### More info on formatting: [http://hexo.io/docs/tag-plugins.html](http://hexo.io/docs/tag-plugins.html)

*Happy blogging!*


***************************
###### Got questions? Contact @jdaudier at [![Gitter chat](https://badges.gitter.im/marionettejs/backbone.marionette.png)](https://gitter.im/marionettejs/backbone.marionette)
