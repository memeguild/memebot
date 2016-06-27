# Description:
#   Returns the requested multi-emoji.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot emoji <multi-emoji name> - Respond with the requested multi-emoji.
#   hubot emoji bomb <N> - Return N (at most 50) random multi-emoji.
#   hubot emoji list - List all the emoji I know.
#   hubot emoji show - Show all of the emoji I know.
#   hubot emoji random - Respond with a random emoji.

responses = {
  'bloop': [
    ':bloop_1_of_4::bloop_2_of_4:',
    ':bloop_3_of_4::bloop_4_of_4:'
  ].join('\n'),

  'excellent_choice': [
    ':excellent_choice_n00::excellent_choice_n01::excellent_choice_n02::excellent_choice_n03:',
    ':excellent_choice_n10::excellent_choice_n11::excellent_choice_n12::excellent_choice_n13:',
  ].join('\n'),

  'pep_nation': [
    ':pep_nation_1_4::pep_nation_2_4:',
    ':pep_nation_3_4::pep_nation_4_4:',
  ].join('\n'),

  'spagetti': ':meme3::meme4:',

  'terrific': [
    ':terrific_00::terrific_01::terrific_02:',
    ':terrific_10::terrific_11::terrific_12:',
  ].join('\n'),

  'thumbswayup': [
    ':thumbswayup_1_6::thumbswayup_2_6::thumbswayup_3_6:',
    ':thumbswayup_4_6::thumbswayup_5_6::thumbswayup_6_6:',
  ].join('\n'),

  'vitas': [
    ':vitas_topleft::vitas_topright:',
    ':vitas_bottomleft::vitas_bottomright:',
  ].join('\n'),

  'waaat': [
    ':waaat_1of9::waaat_2of9::waaat_3of9:',
    ':waaat_4of9::waaat_5of9::waaat_6of9:',
    ':waaat_7of9::waaat_8of9::waaat_9of9:',
  ].join('\n'),

  'happy': [
    ':happy_1_1::happy_1_2:',
    ':happy_2_1::happy_2_2:',
    ':happy_3_1::happy_3_2:',
  ].join('\n'),

  'conflicted': [
    ':conflicted_00::conflicted_01::conflicted_02:',
    ':conflicted_10::conflicted_11::conflicted_12:',
    ':conflicted_20::conflicted_21::conflicted_22:',
  ].join('\n'),

  'disguise': [
    ':disguise_00::disguise_01::disguise_02:',
    ':disguise_10::disguise_11::disguise_12:',
    ':disguise_20::disguise_21::disguise_22:',
  ].join('\n'),

  # НO0ОଠOOOOOОଠଠOoooᵒᵒᵒᵒᵒᵒᵒᵒᵒ
  'tipping_intensifies': [
    ':tipping_intensifies_00::tipping_intensifies_01::tipping_intensifies_02:',
    ':tipping_intensifies_10::tipping_intensifies_11::tipping_intensifies_12:',
    ':tipping_intensifies_20::tipping_intensifies_21::tipping_intensifies_22:',
  ].join('\n'),

  'mission_accomplished': [
    (":mission_accomplished_#{n}:" for n in [1..5]).join(''),
  ].join('\n'),

  'yes': [
    ':yes_00::yes_01::yes_02:',
    ':yes_10::yes_11::yes_12:',
    ':yes_20::yes_21::yes_22:',
  ].join('\n'),

  'bongos': [
    ':horse_bongos_1_6::horse_bongos_2_6::horse_bongos_3_6:',
    ':horse_bongos_4_6::horse_bongos_5_6::horse_bongos_6_6:',
  ].join('\n'),

  'whoa3': [
    ':whoa3_00::whoa3_01::whoa3_02:',
    ':whoa3_10::whoa3_11::whoa3_12:',
    ':whoa3_20::whoa3_21::whoa3_22:',
  ].join('\n'),

  'hiptobesquare': [
    ':hiptobesquare_00::hiptobesquare_01:',
    ':hiptobesquare_10::hiptobesquare_11:',
    ':hiptobesquare_20::hiptobesquare_21:',
  ].join('\n'),
}

emojis = Object.keys(responses).join('|')
regex = new RegExp('emoji\\s+(' + emojis + ')', 'i')

getRandomEmoji = (count) ->
  keys = Object.keys(responses)
  (responses[keys[Math.floor(Math.random() * keys.length)]] for i in [0...count])

module.exports = (robot) ->
  robot.respond regex, (msg) ->
    msg.send responses[msg.match[1]]

  robot.respond /emoji bomb(?:\s+(\d+))?/i, (msg) ->
    count = Math.min(parseInt(msg.match[1]) || 5, 50)
    msg.send getRandomEmoji(count).join('\n')

  robot.respond /(?:show emoji|emoji show)/i, (msg) ->
    keys = Object.keys(responses)

    (goAgain = () ->
      if keys.length
        key = keys.shift()

        # Output the name and emoji in separate messages so that the
        # multi-emoji are rendered in large mode.
        msg.send "#{key}:"
        msg.send responses[key]

        # Use a setTimout to avoid rate limiting.
        setTimeout(goAgain, 1100)
    )()

  robot.respond /(?:list emoji|emoji list)/i, (msg) ->
    keys = ("\"#{key}\"" for key in Object.keys(responses))
    msg.send "These are the emojis I know about: #{keys.join(', ')}"

  robot.respond /(?:random emoji|emoji random)/i, (msg) ->
    msg.send getRandomEmoji(1)[0]
