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

CHANCE = 0.075;

module.exports = (robot) ->
  robot.hear /.*/i, (msg) ->
    if Math.random() < CHANCE
      msg.send msg.random REPLIES
