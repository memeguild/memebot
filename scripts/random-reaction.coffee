# Description:
#   Randomly replies to messages sometimes.

REPLIES = [
  ':applause:',
  ':bg:',
  ':clap:',
  ':cooliopep:',
  ':coolpep:',
  ':disgust:',
  ':fieri:',
  ':gg:',
  ':grinning:',
  ':jesus:',
  ':kreygasm:',
  ':lmao:',
  ':mattdamon:',
  ':pep_nation:',
  ':prettygood:',
  ':spicy_meatball:',
  ':tipping_intensifies:',
  ':tipsfedora:',
  ':wellmemed:',
]

# Percentage chance that memebot will respond to messages.
CHANCE = 4 / 100

module.exports = (robot) ->
  robot.hear /.*/i, (msg) ->
    if Math.random() < CHANCE
      msg.send msg.random REPLIES
