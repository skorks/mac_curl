# Mac CURL (mac_curl)

A CURL like script to do MAC signed requests to urls. It supports a subset of CURL command line parameters as well as a bunch of others.

## Modes of Operation

It has 3 modes:

```
mac_curl config
mac_curl credentials
mac_curl request
```

### mac_curl config

```
Read or create the currently active configuration file

  --read, --no-read, -r:   Show the currently active config file (default: true)
            --write, -w:   Write a default config file to a given path or home directory if no path is given
             --help, -h:   Show this message
```

Some examples might be:

```
mac_curl config -r  - figure out what the current config file would be and show its location and content

mac_curl config -w ./ - create a config file in the specified directory (./), will be populated with default values, will be called .mac_curl.conf
```

### mac_curl credentials

```
Fetch some MAC credentials given a url we want to hit with said credentials

        --api-key <s>:   The API key to use
     --api-secret <s>:   The API secret to use
             --direct:   Assume that the url given is that of a credentials server, so no need to discover it
  --add-to-config, -a:   If we get back some credentials, add them to our config file
           --help, -h:   Show this message
```

Some examples might be:

```
mac_curl credentials --api-key="com.playup.ios.live" --api-secret="QwFHK6n3WAqhDPiz" http://localhost:8080/v2/clients/live

mac_curl credentials --api-key="com.playup.ios.live" --api-secret="QwFHK6n3WAqhDPiz" --direct http://localhost:9090/credentials
```

### mac_curl request

```
Perform a mac signed request to the given url

                    --request, -X <s>:   The HTTP request method to use for request (GET, POST)
                     --header, -H <s>:   HTTP header to use for request as a colon separated key value pair (may be used multiple times)
  --api-signature, --no-api-signature:   Include the API sigature header 'X-PlayUp-Api-Key' (default: true)
  --mac-signature, --no-mac-signature:   Include MAC authentication (default: true)
                        --api-key <s>:   The API key to use
                     --api-secret <s>:   The API secret to use
                        --mac-key <s>:   The MAC key to use
                     --mac-secret <s>:   The MAC secret to use
                       --data, -d <s>:   The data to send as a body of a post request
                           --help, -h:   Show this message
```

Some examples might be:

```
mac_curl request -X HEAD -H "Content-Type: application/json","Accept-Language: zh-CN","Accept: application/json, application/vnd.playup.*, */*" http://localhost:8080/v2/clients/live

mac_curl request -H "Content-Type: application/json","Accept-Language: zh-CN","Accept: application/json, application/vnd.playup.*, */*" --no-api-signature --no-mac-signature http://localhost:8080/v2/clients/live

mac_curl request --api-key="abc" --api-secret="123" --mac-key="xxx" --mac-secret="yyy" http://localhost:8080/v2/clients/live

```

##Configuration

By default the first time the script is executed it will create a configuration file if it can't find an existing one. This configuration file will be named .mac_curl.conf and it will live in the user home directory. The file will be populated with some default values, but you may add more stuff to it manually. A config file is in JSON format and it might look like this:

```json
{
  "log_level": "DEBUG",
  "request_method": "POST",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json, application/vnd.playup.*, */*"
  },
  "api_key": "com.playup.ios.live",
  "api_secret": "QwFHK6n3WAqhDPiz",
  "mac_credentials": {
    "http://localhost:9090/credentials": {
      "id": "q4kxpS5k6J5BHyxFNh2HAKe41VVMgR7B",
      "secret": "08xI;YLF!mce1U_AMJPOl+ZhyyPmK>esgz^;bTYPh4JsoVt+@MYeOabSfySA_nkkC"
    }
  },
  "current_mac_key": "q4kxpS5k6J5BHyxFNh2HAKe41VVMgR7B",
  "current_mac_secret": "08xI;YLF!mce1U_AMJPOl+ZhyyPmK>esgz^;bTYPh4JsoVt+@MYeOabSfySA_nkkC",
  "request_body": {
    ":type": "application/vnd.playup.conversation.invitation.request+json",
    "to":{
      ":type":"application/vnd.playup.friend+json",
      ":uid":"friend-2017"
    }
  }
}
```

Every time you run the script it will attempt to find a config file. The script will look for a config file in the current working directory first and will use the one it finds there, if it can't find one it will start walking up the directory tree looking for a config file in every directory it hits until it hits the user home directory, if it can't find one there, it will automatically generate one with some default values.

The script will attempt to use the configured values on every request to save you typing, but you can override by passing in the equivalent command line option. So if you have `"request_method": "POST"` in the config file you can always do `mac_curl request -X GET` and the script will attempt to perform a GET request.

### The MAC credentials

Most of the keys in the config are pretty self explanatory the only one that is a bit tricky is `mac_credentials`. So every time we attempt to fetch mac credentials via `mac_curl credentials` we'll acquire a credential server url as well as a set of credentials from it. Now if we're inserting these credentials in the config file via `--add-to-config`, the following will happen:

- if there is no `mac_credentials` key one will be created with the value being a hash, inside this hash out credential server url will become a key with the value of it being the credentials hash
- if we already have the `mac_credentials` key with credentials server url key inside which is equivalent to the one we have, its value will be overwritten with the credentials hash we just fetched
- if we already have the `mac_credentials` key but it doesn't have a key equivalent to our credentials server url then, we'll insert a new key, so if we hit many credntial servers, there will be one entry per credentials server we hit in the `mac_credentials` hash

In all the above cases the last set of credentials fetched will also be used to populate the `current_mac_key` and `current_mac_secret` config parameters, so they can be used next time.

You can of course manually do all the above things.

If you have a set of mac credentials you can obviously pass those on the command line and it will override any in the config.




## Possible Extension (these are just rough thoughts)
- in the request command we can have pretty printing options based on headers (if json pretty print, convert to hash etc.)
- in the request command we can choose to respect the caching rules
- should have an option to keep track of the history of executing the script
- add the ability to have a set of steps run one after another as a command




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

