# Description:
#   Memebot must say "gg" otherwise he is not mannered.
#
# Commands:
#   hubot gg

GG = ":gg:"

module.exports = (robot) ->
  robot.respond /:gg:/i, (msg) ->
    msg.send GG

  robot.hear /\s*:gg:\s*@memebot/i, (msg) ->
    msg.send GG
