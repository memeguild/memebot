# Description:
#   longcat is the most important thing in your life
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot longcat me - Receive a longcat
#   hubot longcat N - get an N-length longcat

LONGCAT_START = ":blank:\n:longcat1:"
LONGCAT_MID = ":longcat2:"
LONGCAT_END = ":longcat3:"

# Based on https://api.slack.com/rtm#limits (although this is all ascii so
# we could probably go 4x bigger).
MAX_MSG_SIZE = 4000
# A Guess at the size of the surrounding JSON.
SAFETY_MARGIN = 50
BASE_SIZE = SAFETY_MARGIN + LONGCAT_START.length + 1 + LONGCAT_END.length + 1

MAX_COUNT = Math.floor((MAX_MSG_SIZE - BASE_SIZE) / (LONGCAT_MID.length + 1))

safeCount = (count) =>
  if !count || count < 1
    1
  else if count > MAX_COUNT
    MAX_COUNT
  else
    count

makeCat = (count) =>
  count = safeCount(count)

  CAT = (LONGCAT_MID for num in [0...count])
  CAT.unshift LONGCAT_START
  CAT.push LONGCAT_END
  CAT.join('\n')

module.exports = (robot) ->
  robot.respond /longcat( (\d+))?/i, (msg) ->
    msg.send makeCat(msg.match[2])
