# hubot-microsoft-images

Allows Hubot to know many languages using Microsoft Translator

See [`src/microsoft-images.coffee`](src/microsoft-images.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-microsoft-images --save`

Then add **hubot-microsoft-images** to your `external-scripts.json`:

```json
[
  "hubot-microsoft-images"
]
```

set the environment variable:

```
HUBOT_BING_IMAGES_ACCOUNT_KEY=YOUR_ACCOUNT_KEY
HUBOT_BING_IMAGES_ADULT="Off", "Moderate", or "Strict"
```

## Sample Interaction

```
user> hubot image business cat
hubot> http://i.imgur.com/3cCagym.jpg
```
