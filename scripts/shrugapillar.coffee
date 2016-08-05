# Description:
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

BASE_TAXONOMY =
  regnum: "mememalia"
  phylum: "arthropoda"
  classis: "insecta"
  ordo: "lepidoptera"
  familia: "nymphalidae"
  genus: "depulso"

PROGENITOR =
  species: "marcinekae"
  commonName: "Shrugapillar"
  antenna: "ᜒ    ᕙ  ᕗ",
  head: "¯\\_(ツ)_/¯"
  body: "¯\\_(    )_/¯"
  booty: "¯\\_( _ )_/¯"

MUTATIONS = [
    species: "inflatus"
    commonName: "Smugapillar"
    antenna: "ᜒ   ᕙ     ᕗ",
    head: "¯\\_(⌣̯̀⌣́)_/¯"
    body: "¯\\_(       )_/¯"
    booty: " ¯\_( __ )_/¯"
  ,
    species: "incertus"
    commonName: "Unsureapillar"
    antenna: "ᜒ   ᕙ    ᕗ",
    head: "¯\\_(º_o)_/¯"
    body: "¯\\_(     )_/¯"
    booty: "¯\\_(  _ )_/¯"
  ,
    species: "ignavia"
    commonName: "Apathetapillar"
    antenna: "ᜒ   ᕙ     ᕗ",
    head: "¯\\_(´-｀)_/¯"
    body: "¯\\_(       )_/¯"
    booty: "¯\\_(____)_/¯"
  ,
    species: "indignati"
    commonName: "Indignapillar"
    antenna: "ᜒ    ᕙ    ᕗ",
    head: "¯\\_(ಠ_ಠ)_/¯"
    body: "¯\\_(       )_/¯"
    booty: "¯\\_(____)_/¯"
  ,
    species: "contentus"
    commonName: "Contentapillar"
    antenna: "ᜒ     ᕙ      ᕗ",
    head: "¯\\_(◉‿◉)_/¯"
    body: "¯\\_(            )_/¯"
    booty: "¯\\_(_______)_/¯"
  ,
    species: "exasperentur"
    commonName: "Desuapillar"
    characteristics: ""
    antenna: "ᜒ    ᕙ       ᕗ",
    head: "¯\\_( ͡° ͜ʖ ͡°)_/¯"
    body: "¯\\_(          )_/¯"
    booty: "¯\\_( ____ )_/¯"
  ,
    species: "omnipotentem"
    commonName: "Illumipillar"
    antenna: "ᜒ   ᕙ      ᕗ",
    head: "¯\\_(👁)_/¯"
    body: "¯\\_(     )_/¯"
    booty: "¯\\_(___)_/¯"
    description: "Knows all. Sees all. Controls all."
  ,
    species: "lepidoptera"
    commonName: "Concealapillar"
    antenna: "     ᕙ       ᕗ",
    head: "¯\\_(ಥ﹏ಥ)_/¯"
    body: "¯\\_(          )_/¯"
    booty: "¯\\_( ____ )_/¯"
]

formatName = (def) =>
    "#{def.commonName} (_#{BASE_TAXONOMY.genus} #{def.species}_)"

# Given a shrugapillar definition, calculate the maximum allowed length so
# as to avoid rate limiting.
calculateMaxLength = (def) =>
  MAX_MSG_SIZE = process.env.MAX_MSG_SIZE || 4000;

  # A Guess at the size of the surrounding JSON.
  SAFETY_MARGIN = 50

  baseSize = SAFETY_MARGIN +
    def.antenna.length + 1 +
    def.head.length + 1 +
    def.booty.length + 1 +
    formatName(def)

  Math.floor((MAX_MSG_SIZE - baseSize) / def.body.length)

# Augment each shrugapillar to include the maximum allowed length.
for shrugapillar in [PROGENITOR, MUTATIONS...]
  shrugapillar.maxLength = calculateMaxLength(shrugapillar)


# Start the population out with 100 basic shrugapillars.
POPULATION = (PROGENITOR for [0...1])

# Then add one of each special shrugapillar.
POPULATION.push(MUTATIONS...)

makeShrugapillar = (def, length, verbose = false) =>
  if !length || length < 1
    length = Math.round(Math.random() * 9) + 1
  else if length > def.maxLength
    length = def.maxLength

  shrugapillar = (def.body for [0...length])
  shrugapillar.unshift def.antenna, def.head
  shrugapillar.push def.booty
  if verbose
    shrugapillar.push "*Name:* #{formatName(def)}"
    shrugapillar.push "*Kingdom:* #{def.regnum or BASE_TAXONOMY.regnum}"
    shrugapillar.push "*Phylum:* #{def.phylum or BASE_TAXONOMY.phylum}"
    shrugapillar.push "*Class:* #{def.classis or BASE_TAXONOMY.classis}"
    shrugapillar.push "*Order:* #{def.ordo or BASE_TAXONOMY.ordo}"
    shrugapillar.push "*Family:* #{def.familia or BASE_TAXONOMY.familia}"
    if def.description
      shrugapillar.push "*Description:* #{def.description}"
  shrugapillar.join('\n')

listShrugapillars = () =>
  list = [PROGENITOR, MUTATIONS...].map((def) =>
    "    #{formatName(def)}").join("\n")
  "These are the know shrugapillars:\n#{list}"

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

  # Look for verbose or describe flag to learn more about the shurgapillar.
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
      def = msg.random POPULATION

      # If the user specified a particular name then try to find one
      # that matches.
      if name
        found = false
        name = name.toLowerCase();

        for shrugapillar in [PROGENITOR, MUTATIONS...]
          commonName = shrugapillar.commonName.toLowerCase()
          species = shrugapillar.species.toLowerCase();
          if name is commonName or name is species
            def = shrugapillar
            found = true
            break
        if not found
          msg.send "Couldn't find shrugapillar \"#{name}\", so here's a " +
              "random one instead:"

      msg.send makeShrugapillar(def, length, verbose)
