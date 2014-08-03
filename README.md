# hubot-note
[![Build Status](https://secure.travis-ci.org/ota42y/hubot-note.png?branch=master)](http://travis-ci.org/ota42y/hubot-note)
[![NPM](https://nodei.co/npm/hubot-note.png)](https://nodei.co/npm/hubot-note/)

==========

This script save and show chat log on chat.


# Usage

```
user1: Hi
user2: Hi!
user1: hubot note start // chat log save start
hubot: "1997-01-12" start

user1: Hi Hi Hi!
user2: They can be demolished
user1: Hi Hi Hi!
user2: They can be toppled

user1: hubot note stop // chat log save stop
hubot: "1997-01-12" is stopped

user1: hubot note show // show saved last 3 chat log
hubot: user2: They can be demolished
hubot: user1: Hi Hi Hi!
hubot: user2: They can be toppled


```

# TODO
- output note to file
