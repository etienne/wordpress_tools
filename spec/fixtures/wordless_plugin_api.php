O:8:"stdClass":19:{s:4:"name";s:8:"Wordless";s:4:"slug";s:8:"wordless";s:7:"version";s:3:"0.1";s:6:"author";s:41:"<a href="http://welaika.com/">weLaika</a>";s:14:"author_profile";s:37:"http://profiles.wordpress.org/welaika";s:12:"contributors";a:2:{s:7:"welaika";s:37:"http://profiles.wordpress.org/welaika";s:13:"stefano.verna";s:44:"http://profiles.wordpress.org/stefanoverna-1";}s:8:"requires";s:3:"3.0";s:6:"tested";s:5:"3.2.1";s:13:"compatibility";a:0:{}s:6:"rating";d:80;s:11:"num_ratings";i:1;s:10:"downloaded";i:246;s:12:"last_updated";s:10:"2011-12-13";s:5:"added";s:10:"2011-12-13";s:8:"homepage";s:35:"https://github.com/welaika/wordless";s:8:"sections";a:2:{s:11:"description";s:1119:"<p>Wordless is an opinionated WordPress plugin that dramatically speeds up and enhances your custom themes creation. Some of its features are:</p>

<ul>
<li>A structured, organized and clean <a href="https://github.com/welaika/wordless/tree/master/wordless/theme_builder/vanilla_theme">theme organization</a> (taken directly from Rails);</li>
<li>Ability to create a new theme skeleton directly within the WordPress backend interface;</li>
<li>Ability to write PHP code using the beautiful <a href="http://haml-lang.com/">Haml templating system</a>;</li>
<li>Ability to write CSS stylesheets using the awesome <a href="sass-lang.com">Sass syntax</a> and the <a href="http://compass-style.org/">Compass framework</a>;</li>
<li>Ability to write <a href="http://jashkenas.github.com/coffee-script/">Coffeescript</a> instead of the boring, oldish Javascript;</li>
<li>A growing set of handy and documented helper functions ready to be used within your views;</li>
</ul>

<p>You can always find the latest version of this plugin, as well as a
detailed README, on <a href="https://github.com/welaika/wordless">Github</a>.</p>";s:12:"installation";s:1756:"<ol>
<li>Your development machine needs a ruby environment, and the <a href="https://github.com/chriseppstein/compass">compass</a>, <a href="https://github.com/sstephenson/sprockets">sprockets</a> and <a href="https://github.com/josh/ruby-coffee-script">coffee-script</a> gem. See below to see how to setup WordPress on your machine using RVM;</li>
<li>The production machine doesn't need any extra-dependencies, as all the compiled assets automatically get statically backend by Wordless;</li>
<li><a href="https://github.com/welaika/wordless/zipball/master">Download the Wordless plugin</a>, drop it in the <code>wp-content/plugins</code> directory and enable it from the WP "Plugins" section;</li>
<li>Enable the use of nice permalinks from the WP "Settings &#62; Permalink" section. That is, we need the .htaccess file;</li>
<li>Create a brand new Wordless theme directly within the WP backend, from the WP "Appearance &#62; New Wordless Theme" section;</li>
<li>Specify the path of your ruby executables, you can do it within your theme's <code>config/initializers/wordless_preferences.php</code> config file.</li>
</ol>

<p><strong>RVM (recommended setup)</strong></p>

<p>It's recommended to use <a href="http://rvm.beginrescueend.com">RVM</a> to handle ruby gems. Type the following from your terminal:</p>

<pre><code>rvm use 1.8.7
rvm gemset create wordless
rvm use 1.8.7@wordless
gem install sprockets compass coffee-script
rvm wrapper 1.8.7@wordless wordless compass ruby
</code></pre>

<p>Now you should be able to know the location of your RVM-wrapped ruby executables using <code>which wordless_ruby</code> and <code>which wordless_compass</code>. Write them down into the <code>config/initializers/wordpress_preferences.php</code> file.</p>";}s:17:"short_description";s:121:"Wordless dramatically speeds up and enhances your custom themes
creation, thanks to Sass, Compass, Haml and Coffeescript.";s:13:"download_link";s:50:"http://downloads.wordpress.org/plugin/wordless.zip";s:4:"tags";a:4:{s:7:"compass";s:7:"compass";s:4:"haml";s:4:"haml";s:5:"rails";s:5:"rails";s:4:"sass";s:4:"sass";}}
