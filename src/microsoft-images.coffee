# Description:
#   Allows Hubot to find relevant images
#
# Configuration:
#   HUBOT_BING_IMAGES_ACCOUNT_KEY
#   HUBOT_BING_IMAGES_ADULT "Off", "Moderate", "Strict"
#
# Commands:
#   hubot image <query> - Searches for an image from the query

ACCOUNT_KEY = process.env.HUBOT_BING_IMAGES_ACCOUNT_KEY
ADULT = process.env.HUBOT_BING_IMAGES_ADULT || "Strict"

IMAGE_SEARCH_URL = "https://api.cognitive.microsoft.com/bing/v5.0/images/search"

Image = (client, params) ->
  return (callback) ->
    getImg = (params, callback) ->
      client.http(IMAGE_SEARCH_URL)
        .query(params)
        .headers("Ocp-Apim-Subscription-Key": ACCOUNT_KEY)
        .get() (err, res, body) ->
          if err
            callback "Failed to search: " + err
            return
          try
            images = JSON.parse(body).value
            image = client.random images
            callback image.contentUrl
          catch error
            callback err, body

    getImg(params, callback)


module.exports = (robot) ->
  robot.respond /(?:image|img) (?:me )?(.*)/i, (msg) ->
    query = msg.match[1]?.trim()

    params =
      q: "'#{query}'"
      safeSearch: ADULT
      count: 25

    Image(msg, params) (err, url) ->
      if err
        msg.send err
        robot.emit 'error', err
        return

      msg.send url
