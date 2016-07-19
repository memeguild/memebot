# Description:
#   Randomly replies to messages sometimes.

REPLIES = [
  ':amazing:',
  ':applause:',
  ':bg:',
  ':clap:',
  ':cooliopep:',
  ':coolpep:',
  ':disgust:',
  ':ethan:',
  ':fieri:',
  ':gg:',
  ':grinning:',
  ':jesus:',
  ':kreygasm:',
  ':lmao:',
  ':mattdamon:',
  ':noice:',
  ':pep_nation:',
  ':prettygood:',
  ':spicy_meatball:',
  ':terrific_00::terrific_01::terrific_02:\n:terrific_10::terrific_11::terrific_12:',
  ':thumbswayup_1_6::thumbswayup_2_6::thumbswayup_3_6:\n:thumbswayup_4_6::thumbswayup_5_6::thumbswayup_6_6:',
  ':tipping_intensifies:',
  ':tipsfedora:',
  ':vitas_blblblbl:',
  ':wellmemed:',
  ':whoa:',
  ':whoa2:',
]

# Percentage chance that memebot will respond to messages.
CHANCE = 4 / 100

module.exports = (robot) ->
  robot.hear /.*/i, (msg) ->
    if Math.random() < CHANCE
      msg.send msg.random REPLIES
