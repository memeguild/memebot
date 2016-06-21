# Description:
#   make grids
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot grid [me] str MxN - get a MxN grid of str

# Based on https://api.slack.com/rtm#limits
MAX_MSG_BYTES = 16000
# A Guess at the size of the surrounding JSON.
# Based on https://api.slack.com/rtm#sending_messages
SAFETY_MARGIN = 100

# Pander to people who use compact style :(
PREFIX = ':blank:'

NUM_OVERHEAD_BYTES = Buffer.byteLength(PREFIX) + 2 + SAFETY_MARGIN

tooBig = (str, rows, cols) =>
  MAX_MSG_BYTES < NUM_OVERHEAD_BYTES + (cols * Buffer.byteLength(str) + 2) * rows

makeGrid = (str, rows, cols) =>
  if tooBig(str, rows, cols)
    "You're trying to get me rate-limited!"
  else
    row = Array(cols + 1).join(str)

    rows = ([0..rows - 1].map -> row)
    rows.unshift(PREFIX)

    rows.join("\n")

module.exports = (robot) ->
  robot.respond /grid\s+(?:me\s+)?(\S+)\s+(\d+)\s*x?\s*(\d+)/i, (msg) ->
    msg.send makeGrid(msg.match[1], +msg.match[2], +msg.match[3])
