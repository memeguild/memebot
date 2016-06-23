# Description:
#   Anonymously post to another channel...
#
# Commands:
#   hubot anon <#channel> <message>

module.exports = (robot) ->
  robot.respond /anon (#[a-z1-9_]+)\s+(.*)/i, (msg) ->
    msg.envelope.room = msg.match[1]
    msg.send "Anon says \"#{msg.match[2]}\""
