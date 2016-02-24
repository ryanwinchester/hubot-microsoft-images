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

IMAGE_SEARCH_URL = "https://api.datamarket.azure.com/Bing/Search/v1/Image"

Image = (client, auth, params) ->
  return (callback) ->
    getImg = (params, callback) ->
      client.http(IMAGE_SEARCH_URL)
        .query(params)
        .headers(Authorization: "Basic #{auth}")
        .get() (err, res, body) ->
          if err
            callback "Failed to search: " + err
            return
          try
            images = JSON.parse(body).d.results
            image = msg.random images
            callback image.MediaUrl
          catch error
            callback err, body

    getImg(params, callback)


module.exports = (robot) ->
  robot.respond /image (.*)/i, (msg) ->
    query = msg.match[1]?.trim()

    params =
      Query: "'#{query}'"
      Adult: "'#{ADULT}'"
      $format: "json"
      $top: 25

    auth = new Buffer(":#{ACCOUNT_KEY}").toString('base64')

    Image(msg, auth, params) (err, url) ->
      if err
        msg.send err
        robot.emit 'error', err
        return

      msg.send url
