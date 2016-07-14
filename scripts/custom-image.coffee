# Description:
#   Fork (copy-pasta) of hubot-google-images.
#
# Configuration
#   HUBOT_GOOGLE_CSE_KEY - Your Google developer API key
#   HUBOT_GOOGLE_CSE_ID - The ID of your Custom Search Engine
#   HUBOT_MUSTACHIFY_URL - Optional. Allow you to use your own mustachify instance.
#   HUBOT_GOOGLE_IMAGES_HEAR - Optional. If set, bot will respond to any line that begins with "image me" or "animate me" without needing to address the bot directly
#   HUBOT_GOOGLE_SAFE_SEARCH - Optional. Search safety level.
#   HUBOT_GOOGLE_IMAGES_FALLBACK - The URL to use when API fails. `{q}` will be replaced with the query string.
#
# Commands:
#   hubot taxiderme <query> - Bad taxidermied animals

animals = [
  "alligator",
  "armadillo",
  "bear",
  "bobcat",
  "cat",
  "cheetah",
  "cougar",
  "cow",
  "deer",
  "dog",
  "dolphin",
  "dragonfly",
  "duck",
  "eagle",
  "elephant",
  "elk",
  "fish",
  "fox",
  "frog",
  "giraffe",
  "goat",
  "gorilla",
  "grandma",
  "grandpa",
  "hedgehog",
  "horse",
  "human",
  "leopard",
  "lion",
  "lizard",
  "monkey",
  "owl",
  "person",
  "pigeon"
  "raccoon",
  "shark",
  "weasel",
  "wolf",
  "yes",
  "zebra",
]

characters = [
  # Empty string to let inkbot decide...
  "",
  "captain america",
  "dc",
  "disney",
  "flash",
  "hulk",
  "ironman",
  "magneto",
  "marvel",
  "mystique",
  "ninja turtles",
  "pokemon",
  "professor x",
  "spiderman",
  "thor",
  "wolverine",
]

module.exports = (robot) ->
  robot.respond /taxiderme\s*(.+)?/i, (msg) ->
    animal = msg.match[1] or msg.random animals
    query = "bad taxidermy #{animal}"
    imageMe msg, query, (url) ->
      msg.send url
  robot.respond /cosplay\s*me\s*(.+)?/i, (msg) ->
    type = msg.match[1] or msg.random characters
    query = "bad cosplay #{type}"
    imageMe msg, query, (url) ->
      msg.send url

imageMe = (msg, query, animated, faces, cb) ->
  cb = animated if typeof animated == 'function'
  cb = faces if typeof faces == 'function'
  googleCseId = process.env.HUBOT_GOOGLE_CSE_ID
  if googleCseId
    # Using Google Custom Search API
    googleApiKey = process.env.HUBOT_GOOGLE_CSE_KEY
    if !googleApiKey
      msg.robot.logger.error "Missing environment variable HUBOT_GOOGLE_CSE_KEY"
      msg.send "Missing server environment variable HUBOT_GOOGLE_CSE_KEY."
      return
    q =
      q: query,
      searchType:'image',
      safe: 'off',
      fields:'items(link)',
      cx: googleCseId,
      key: googleApiKey
    if animated is true
      q.fileType = 'gif'
      q.hq = 'animated'
      q.tbs = 'itp:animated'
    if faces is true
      q.imgType = 'face'
    url = 'https://www.googleapis.com/customsearch/v1'
    msg.http(url)
      .query(q)
      .get() (err, res, body) ->
        if err
          if res.statusCode is 403
            msg.send "Daily image quota exceeded, using alternate source."
            deprecatedImage(msg, query, animated, faces, cb)
          else
            msg.send "Encountered an error :( #{err}"
          return
        if res.statusCode isnt 200
          msg.send "Bad HTTP response :( #{res.statusCode}"
          return
        response = JSON.parse(body)
        if response?.items
          image = msg.random response.items
          cb ensureResult(image.link, animated)
        else
          msg.send "Oops. I had trouble searching '#{query}'. Try later."
          ((error) ->
            msg.robot.logger.error error.message
            msg.robot.logger
              .error "(see #{error.extendedHelp})" if error.extendedHelp
          ) error for error in response.error.errors if response.error?.errors
  else
    msg.send "Google Image Search API is no longer available. " +
      "Please [setup up Custom Search Engine API](https://github.com/hubot-scripts/hubot-google-images#cse-setup-details)."
    deprecatedImage(msg, query, animated, faces, cb)

deprecatedImage = (msg, query, animated, faces, cb) ->
  # Show a fallback image
  imgUrl = process.env.HUBOT_GOOGLE_IMAGES_FALLBACK ||
    'http://i.imgur.com/CzFTOkI.png'
  imgUrl = imgUrl.replace(/\{q\}/, encodeURIComponent(query))
  cb ensureResult(imgUrl, animated)

# Forces giphy result to use animated version
ensureResult = (url, animated) ->
  if animated is true
    ensureImageExtension url.replace(
      /(giphy\.com\/.*)\/.+_s.gif$/,
      '$1/giphy.gif')
  else
    ensureImageExtension url

# Forces the URL look like an image URL by adding `#.png`
ensureImageExtension = (url) ->
  if /(png|jpe?g|gif)$/i.test(url)
    url
  else
    "#{url}#.png"