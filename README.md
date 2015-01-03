# Marionette Blog
![screenshot](logo.png)

### This blog is built using [Hexo](http://hexo.io).

### Topic suggestions
Please create a new [GitHub issue](https://github.com/marionettejs/blog/issues/new) for topic ideas that you would like us to write about

### Steps to get it running:

##### 1. Fork this repo

##### 2. `npm install`

##### 3. To create a new post in markdown: `hexo new draft <filename>`

##### 4. Edit the file with your file name in this directory: [\_drafts](https://github.com/marionettejs/blog/tree/master/source/_drafts)

##### 5. Edit your title at top of the file

##### 6. Add a tag at the top of the file so that it can be filtered, choose from:
* `tags: news`
* `tags: notes`
* `tags: releases`
* `tags: tutorials (beginner)`
* `tags: tutorials (intermediate)`
* `tags: tutorials (advanced)`
* `tags: behind the scenes`

*Note: Make sure you add a space after the colon*

##### To add multiple tags:

    tags:
    - news
    - releases

##### 7. Add your name as the last tag (after the word `by`):
    tags:
    - news
    - by Uncle Bob


*Note: Make sure you write your name the same way for all posts so it filters correctly (so no Uncle Bob one week and Uncle Bobby the next)*


##### 8. To edit a post that has been **published**, edit the file in this directory: [\_posts](https://github.com/marionettejs/blog/tree/master/source/_posts)

##### 9. Turn on the server: `hexo s` (if port 5000 is being used already, try `hexo s -p 4000`)

##### 10. Preview your post at: [localhost:5000](http://localhost:5000)

##### 11. Once you're satisfied with your changes, send a pull request

----

### Steps to go live:

#### One Time Setup

`cd public`

`git init`

`git remote add live git@github.com:marionettejs/marionettejs.github.io.git`

`git commit -m "initial"`

`git reset --hard live/master`


##### 12. To publish a post (moves a post from [\_drafts](https://github.com/marionettejs/blog/tree/master/source/_drafts) to [\_posts](https://github.com/marionettejs/blog/tree/master/source/_posts) directory): `hexo p <filename>`

##### 13. To generate static files: `hexo generate`

##### 14. cd into public, `git commit -m 'publish <TITLE>' && git push live/mater`

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

### Disqus Syntax Highlighting
If you're responding to a comment on Disqus and want syntax highlighting, place your code inside `<pre><code>` tags. For example:

    <pre><code>
    var foo = 'bar';
    alert('foo');
    </code></pre>



*Happy blogging!*

***************************
###### Got questions? Contact @jdaudier at [![Gitter chat](https://badges.gitter.im/marionettejs/backbone.marionette.png)](https://gitter.im/marionettejs/backbone.marionette)
