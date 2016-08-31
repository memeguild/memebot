# Description:
#
#      ᕙ ᕗ
#   ¯\_(ツ)_/¯
#   ¯\_(  )_/¯
#   ¯\_(  )_/¯
#   ¯\_(  )_/¯
#   ¯\_(__)_/¯
#
#   A fine respite from the usual mass-produced fare we address here, the
#   shrugapillar is an interesting play on two themes. One one hand, we have
#   our cynic, the shrug man emoji, whose very expression is one of an
#   existential ennui. A meme which encapsulates the modern condition, one
#   in which we have abundance of things, but not of purpose. On the other
#   hand, we have the cuteness of the matter, the unicode character antenna,
#   and the round, jolly body. This reminds the viewer of more lighthearted
#   fare such as the lenny face and cutesy unicode cats. This is an
#   interesting finish, as if to say "life is suffering, but there is so
#   much goodness in the world to suffer for".
#
#                                               - Kevin Cox
#                                                 Senior Meme Analyst
#
# Dependencies:
#   None
#
# Configuration:
#    MAX_MSG_SIZE - The maximum message size (in characters). Defaults to 4000
#       based on https://api.slack.com/rtm#limits.
#
# Commands:
#   hubot shrugapillar - Receive a shrugapillar
#   hubot shrugapillar <species> - Receive a specific shrugapillar
#   hubot shrugapillar <N> - Get an N-length shrugapillar
#   hubot shrugapillar <species> <N> verbose - Get a particular N-length
#         species of shrugapillar and include any additional information about
#         the species.
#   hubot shrugapillar explain - Prints the artists motivation behind the
#         shrugapillar.
#   hubot shrugapillar list - Prints all know shrugapillars.

Shrugapillar = require "shrugapillar"

RESPONSE_MATCHER = ///
  # Match messages starting with shrugapillar.
  shrugapillar

  # Look for a name. This can also be a command, such as 'list', or 'explain'.
  (?:\s+
    ([a-z]+)
  )?

  # Look for a user specified length.
  (?:\s+
    (\d+)
  )?

  # Look for verbose or describe flag to learn more about the shrugapillar.
  (?:\s+
    ((?:verbose)|(?:describe))
  )?
///i

COMMAND_MATCHER = /(list)|(explain)/i

EXPLANATION = """
A note from the artist:

> My intent for this meme, is to be used in a scenario in which one believes a matter will eventually escalate to a problem but that issue will still not be their problem. Though one has not shrugged off the potential of the issue yet, it is known that the matter will cocoon and be reborn as a full blow problem that they will still not care about. The rebirth will lead to the ‘buttershrug’ or ‘shrugafly’. ​*WORK IN PROGRESS PATENT PENDING*​
>
> Kait Marcinek
> Meme Artist
"""

# A Guess at the size of the surrounding JSON.
MSG_SAFETY_MARGIN = 50

MAX_MSG_SIZE = (process.env.MAX_MSG_SIZE || 4000) - MSG_SAFETY_MARGIN;

formatName = (shrugapillar) =>
  def = shrugapillar.getDefinition()
  "#{def.commonName} (_#{def.genus} #{def.species}_)"

renderShrugapillar = (shrugapillar, length, verbose = false) =>
  info = []

  if verbose
    def = shrugapillar.getDefinition()
    info.push "*Name:* #{formatName(shrugapillar)}"
    info.push "*Kingdom:* #{def.regnum}"
    info.push "*Phylum:* #{def.phylum}"
    info.push "*Class:* #{def.classis}"
    info.push "*Order:* #{def.ordo}"
    info.push "*Family:* #{def.familia}"
    if def.description
      info.push "*Description:* #{def.description}"

  info = info.join('\n')

  result = shrugapillar.render({
    type: "slack"
    length: length
    maxNumCharacters: MAX_MSG_SIZE - info.length
  })

  if info.length
    [result, info].join('\n')
  else
    result

listShrugapillars = () =>
  Shrugapillar.getAll().map((shrugapillar) =>
    [
      "*#{formatName(shrugapillar)}:*"
      renderShrugapillar(shrugapillar, 1, false)
    ].join("\n")
  ).join("\n\n")

module.exports = (robot) ->
  robot.respond RESPONSE_MATCHER, (msg) ->
    name = msg.match[1]
    length = parseInt(msg.match[2], 10)
    verbose = !!msg.match[3]

    if /(?:verbose)|(?:describe)/i.test(name)
      name = null
      verbose = true

    if name && COMMAND_MATCHER.test(name)
      if name.toLowerCase() is "list"
        msg.send listShrugapillars()
      else if name.toLowerCase() is "explain"
        msg.send EXPLANATION
    else
      shrugapillar = msg.random Shrugapillar.getAll()

      # If the user specified a particular name then try to find one
      # that matches.
      if name
        if Shrugapillar.get(name)
          shrugapillar = Shrugapillar.get(name)
        else
          msg.send "Couldn't find a shrugapillar \"#{name}\", so here's a " +
              "random one instead:"

      msg.send renderShrugapillar(shrugapillar, length, verbose)
