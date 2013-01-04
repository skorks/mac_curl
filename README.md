= mac_curl

Generate this with
    mac_curl rdoc
After you have described your command line interface

TODO
in the request command we can have pretty printing options based on headers (if json pretty print, convert to hash etc.)
in the request command we can choose to respect the caching rules
should have an option to keep track of the history of execting the script
add the ability to have a set of steps run one after another as a command, this might replicate the phone script
add a readme description of how to use the script

pull out escort into a separate gem
  should have the ability to generate a skeleton command line app according to my conventions
  should be more config file aware but can live without it
  should be able to support command line apps without sub commands, just a plain vanilla command line app
  work out if it needs to be involved in better logging support
  should have better ability to create better help text
  should have deal better with exit codes and stuff (read the book section about it)
  maybe add some specs for it if needed
  maybe add some cukes for it if needed
  write a nice readme for it
  blog about what makes a good command line app (this and the one below are possibly one post)
  blog about how to use escort and why the other libraries fall short
  blog about how escort is constructed
  should have ability to ask for user input for some commands, using highline or something like that
  should have a clean structure convention of where code that executes the commands should live so that command line apps are easy
  use escort to build a command line version of my markov chains name generator from ages ago
  blog about using escort to build my name generator
  ability to have a default command when you didn't specify one??? (what would this mean for sub command and non sub command apps)
