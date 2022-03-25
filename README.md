# 389 Directory Server Wiki

## Getting Started

You can test our your changes locally with:

`docker build -t 389wiki:latest .`
`docker run -p 4000:4000 389wiki:latest`

This will then listen and server http://localhost:4000

If you want to setup a more permanent editing environment:

1. `yum install python3-pygments`

1. Install [RVM](http://rvm.io). I know RVM can be a pain when you first start
   using it, but you will enjoy life more if you aren't dealing with conflicting
   gems all the time.  Note: do **NOT** install RVM as root.

   First you must configure your terminal emulator to act as a login shell.  In
   gnome-terminal, go to "Edit -> Profile Preferences -> Title and Command".
   Check the box reading "Run command as login shell."  In xfce4-terminal, go to
   "Edit -> Preferences" and check the "Run command as login shell" box.  See
   <https://rvm.io/integration/gnome-terminal>

   Start a new terminal and follow the
   [instructions](https://rvm.io/rvm/security) and then run

   ```
   $ rvm install ruby-2.7.1
   ```

   The documentation for RVM is extensive so don't be afraid to read it.
1. Go into your checkout directory and run `gem install bundler && bundle
   install`
1. Render the site with `jekyll serve --watch`.  (See Advanced Workflow section
   for tips on getting real time previews of your updates).
1. Make changes and save.  If you wish to create a news item, run `jekyll post
   "My Title"`.  That command calls out to a plugin that will create a file with
   the correct name and format and open your editor as defined by VISUAL or
   EDITOR.  You can use a different editor with the `--editor` option.
1. Jekyll will automatically render your changes.

## Advanced Workflow
1. *Optional*: Open port 4000 in your firewall so others can see your local site

    ```
    $ firewall-cmd --add-port=4000/tcp --permanent
    ```
2. If you wish to see real time previews of your updates (i.e. if you don't
   want to hit the refresh button all the time), then you can use
   `jekyll serve --livereload`.

3. **Extreme ProTip**: Unfortunately, Jekyll is a bit simplistic in how it
   regenerates sites.  It regenerates everything instead of just what it needs
   to.  The Jekyll team has recognized this deficiency and has added an
   experimental option `--incremental`/`-I` that attempts to only regenerate the
   pages that actually changed.  In my experience, it works well, so use it!

## Syntax Highlighting
Syntax highlighting is provided by [Pygments](http://pygments.org) (more
specifically by Pygments.rb -- a Ruby binding to Pygments).  Set the
highlighting on a code block by providing a lexer name after the three backticks
that indicate the beginning of a code block.

The list of lexers is available at <http://pygments.org/docs/lexers/>, but in
general they are named like you would expect.  The most common ones we use are

* java
* ruby
* python
* console (a Bash console session)
* json
* properties (Java Properties format)
* bash (a Bash script)
* sql
* ini (for Python conf files)
* yaml

A special note about the console lexer: if the line is a command, you must begin
with a "$", "#", or "%" otherwise the text will be treated as output.  E.g.

**Correct**

```console
$ ./subscription-manager
```

**INCORRECT**

```console
./subscription-manager
```

## Gotchas
* In Markdown, whitespace matters!  Specifically, when you're in a block (like a
  list element in a bulleted list) you need to make sure all sub-blocks have the
  same initial indentation.

**Correct**
<pre>
* Hello World looks like
  ```
  print "Hello World"
  ```
</pre>

**INCORRECT**
<pre>
* Hello World looks like
```
print "Hello World"
```
</pre>

* Be careful with internal links.  Preface them with {{ site.baseurl }} if they
  are in another directory.  See
  <http://jekyllrb.com/docs/github-pages/#project_page_url_structure>
* The URLs for all posts and pages contain a leading slash so there is no need
  to provide one.  E.g. Linking to a post would use {{ site.baseurl }}{{
  post.url }}

# Tips
* If you want to see an overview of an object in Liquid, filter it through the
  debug filter from `_plugins.` E.g. `{{ page | debug }}`
* To find code blocks missing a lexer, install pcre-tools and use the following
  `pcregrep -r -M -n '^$\n^```$' *`
* Vim associates '.md' files with Modula-2.  Add the following to your .vimrc to
  change the association:

  ```
  autocmd BufNewFile,BufReadPost *.md set filetype=markdown
  ```

# Openshift Setup
To interact with Openshift, you will need to install the command line client
`oc`.  It is available in DNF as a package named `origin-clients` but as a
fairly old version.  Instead I grabed it from the
[documenation](https://docs.openshift.com/enterprise/3.0/cli_reference/get_started_cli.html)
which has a download link that will require you to log in to the Red Hat portal.
Once you have the file, unzip it and place the `oc` file in a directory on your
path.  I have a directory `~/bin` that is on my path, so that was the most
convenient place for me.

Next you will need to authenticate.  Run `oc login` and follow the prompts.

Due to our use of PlantUML (which requires Java), we cannot use one of the stock
build images provided by Openshift since the stock containers just provide
one language stack each.  We have to build our own image which is defined in
`Dockerfile` and references other files under `.s2i`.  If you find yourself
needing to modify the build image, you will need to install both Docker and the
[`s2i` tool](https://github.com/openshift/source-to-image).  Like `oc`, `s2i` is
a statically linked binary, so you'll need to download the appropriate tarball
for your architecture and then place `s2i` in a directory on your path.

If you make changes to the Dockerfile, you should test them first.

* Build the image with `podman build -t 389ds/389ds-website-ruby-27 -f Dockerfile.openshift`
* Run `s2i build --exclude="" . 389ds/389ds-website-ruby-27
  --as-dockerfile websiteDockerfile`.
  That will generate a Dockerfile using custom scripts inserted into
  `389ds-website-ruby-27` from the `.s2i/bin` directory.
* Rebuild using the generated Dockerfile: `podman build -t website -f
  websiteDockerfile`.  This will run the `.s2i/bin/assemble` script and build a
  container with the site processed through Jekyll.
* Note that if you make changes to the `assemble` or `run` scripts, you need to
  commit those to git before running `s2i`.  Otherwise, the changes will not be
  picked up!
* `rm websiteDockerfile && rm -rf upload/`
* Test everything by starting a container using `podman run -p 8088:8080 --rm
  -ti website` and browsing the site at http://localhost:8088.  (Note, I
  surfaced the container's port 8080 as 8088 since Tomcat normally uses 8080 but
  you can use whatever port you like).
* Hit CTRL-C to stop the container (and the `--rm` argument will remove the
  container immediately).

If your changes work, you'll need to propagate them to the Openshift Dedicated
internal container registry.  Go to the [About page](https://console.rh-us-east-1.openshift.com/console/about)
for Openshift Dedicated and it has the details on the internal registry but I
will reproduce them here.

* `podman login registry.rh-us-east-1.openshift.com -u $(oc whoami) -p $(oc whoami -t)`
* `podman tag 389ds/389ds-website-ruby-27:latest registry.rh-us-east-1.openshift.com/389ds/389ds-website-ruby-27:latest`
* `podman push registry.rh-us-east-1.openshift.com/389ds/389ds-website-ruby-27:latest`

We also push the image to Quay.io so that GitHub Actions can use the image for
continuous integration builds.

* `podman login quay.io`
* `podman tag 389ds/389ds-website-ruby-27:latest quay.io/389ds/389ds-website-ruby-27:latest`
* `podman push quay.io/389ds/389ds-website-ruby-27:latest` 

Openshift should be configured to watch that image repository and rebuild
everything when it detects a change to the image.

# Environment Variables and Build and Run Processes
Any environment variables that we need to define (such as the BUNDLE_WITHOUT
variable to exclude gems from a group in the Gemfile) are defined in
`.s2i/environment`.  If you ever need to change that then you will need to
rebuild the build image as described above.

Any changes to the site building process (e.g. some pre-processing step needs to
be run before `jekyll build`) or run process (e.g. additional arguments given to
Puma) would be made in `.s2i/bin/assemble` and `.s2i/bin/run` respectively.
Again, you would need to rebuild the build image and push it to Docker Hub.

# Continuous Integration
The GitHub Actions CI workflow we use is based on a default Jekyll building
workflow defined
[here](https://github.com/actions/starter-workflows/blob/main/ci/jekyll.yml).
Ours is slightly different due to our use of s2i.  Our s2i's `assemble` script
expects the site source to be in `/tmp/src` so we bind mount the git checkout
into that directory.  The build is performed with the 389ds/website-ruby-27
container that we maintain and we do a shell trick with chmod to get the
permissions on the bind mount correct.  After that, we just invoke the
`assemble` script ourselves.

## References
* We use RVM to manage Ruby versions and gemsets.  See
  <https://rvm.io/#docindex>
* Jekyll is the engine used to create the site.  There is very good
  documentation at <http://jekyllrb.com/docs/home/>
* We are using Kramdown as our Markdown renderer. There is a quick reference at
  <http://kramdown.gettalong.org/quickref.html> and a more complete syntax guide
  at <http://kramdown.gettalong.org/syntax.html>
* The CSS is written using Sass <http://sass-lang.org>.
* The JS and theming are courtesy of Bootstrap <http://getbootstrap.com/>
  although I did strip out some of the JS that we probably would not use like
  the carousel and modal dialog functions.
