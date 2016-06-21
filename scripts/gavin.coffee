# Description:
#   Gavin graphics
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot gavin up
#   hubot gavin right
#   hubot gavin down
#   hubot gavin left
#   hubot gavin reset

STATE = {}

EMOJI = {
  BLANK: ':blank:'

  BODY: ':gavin_body:',

  HEAD: {
    UP: ':gavin_head:'
    RIGHT: ':gavin_head_right:'
    DOWN: ':gavin_head_down:'
    LEFT: ':gavin_head_left:'
  }

  NECK: {
    HORIZONTAL: ':gavin_neck_horizontal:'
    VERTICAL: ':gavin_neck_vertical:'
    LEFT: ':gavin_neck_left:'
    LEFT_2: ':gavin_neck_left2:'
    RIGHT: ':gavin_neck_right:'
    RIGHT_2: ':gavin_neck_right2:'
  }
}

createCanvas = () ->
  [[EMOJI.HEAD.UP], [EMOJI.BODY]]

findHead = () ->
  headRowIndex = 0
  headColIndex = 0

  STATE.CANVAS.some((row, rowIndex) ->
    return row.some((cell, colIndex) ->
      if /^:gavin_head/.test(cell)
        headColIndex = colIndex
        headRowIndex = rowIndex
        return true
    )
  )

  return {
    row: headRowIndex,
    col: headColIndex
  }

addRow = (atBeginning) ->
  newRow = STATE.CANVAS[0].map(() -> EMOJI.BLANK)
  STATE.CANVAS[if atBeginning then 'unshift' else 'push'](newRow)

addCol = (atBeginning) ->
  STATE.CANVAS.forEach((row) ->
    row[if atBeginning then 'unshift' else 'push'](EMOJI.BLANK))

updateCanvas = (action) ->
  successful = false

  switch action
    when "up" then successful = moveUp(findHead())
    when "right" then successful = moveRight(findHead())
    when "down" then successful = moveDown(findHead())
    when "left" then successful = moveLeft(findHead())
    when "reset"
      STATE.CANVAS = createCanvas()
      successful = true

  successful

moveUp = (head) ->
  # If the move would cause a conflict then return false.
  if head.row isnt 0 and STATE.CANVAS[head.row - 1][head.col] isnt EMOJI.BLANK
    return false

  switch STATE.CANVAS[head.row][head.col]
    when EMOJI.HEAD.UP
      STATE.CANVAS[head.row][head.col] = EMOJI.NECK.VERTICAL
    when EMOJI.HEAD.RIGHT
      STATE.CANVAS[head.row][head.col] = EMOJI.NECK.LEFT_2
    when EMOJI.HEAD.LEFT
      STATE.CANVAS[head.row][head.col] = EMOJI.NECK.RIGHT_2

  if head.row is 0
    addRow(true)
    STATE.CANVAS[head.row][head.col] = EMOJI.HEAD.UP
  else
    STATE.CANVAS[head.row - 1][head.col] = EMOJI.HEAD.UP

  return true

moveRight = (head) ->
  # If the move would cause a conflict then return false.
  if head.col isnt STATE.CANVAS[0].length - 1 and STATE.CANVAS[head.row][head.col + 1] isnt EMOJI.BLANK
    return false

  switch STATE.CANVAS[head.row][head.col]
    when EMOJI.HEAD.RIGHT
      STATE.CANVAS[head.row][head.col] = EMOJI.NECK.HORIZONTAL
    when EMOJI.HEAD.DOWN
      STATE.CANVAS[head.row][head.col] = EMOJI.NECK.RIGHT_2
    when EMOJI.HEAD.UP
      STATE.CANVAS[head.row][head.col] = EMOJI.NECK.RIGHT

  addCol() if head.col is STATE.CANVAS[0].length - 1

  STATE.CANVAS[head.row][head.col + 1] = EMOJI.HEAD.RIGHT

  return true

moveDown = (head) ->
  # If the move would cause a conflict then return false.
  if head.row isnt STATE.CANVAS.length - 1 and STATE.CANVAS[head.row + 1][head.col] isnt EMOJI.BLANK
    return false

  switch STATE.CANVAS[head.row][head.col]
    when EMOJI.HEAD.DOWN
      STATE.CANVAS[head.row][head.col] = EMOJI.NECK.VERTICAL
    when EMOJI.HEAD.RIGHT
      STATE.CANVAS[head.row][head.col] = EMOJI.NECK.LEFT
    when EMOJI.HEAD.LEFT
      STATE.CANVAS[head.row][head.col] = EMOJI.NECK.RIGHT

  addRow() if head.row is STATE.CANVAS.length - 1

  STATE.CANVAS[head.row + 1][head.col] = EMOJI.HEAD.DOWN

  return true

moveLeft = (head) ->
  # If the move would cause a conflict then return false.
  if head.col isnt 0 and STATE.CANVAS[head.row][head.col - 1] isnt EMOJI.BLANK
    return false

  switch STATE.CANVAS[head.row][head.col]
    when EMOJI.HEAD.LEFT
      STATE.CANVAS[head.row][head.col] = EMOJI.NECK.HORIZONTAL
    when EMOJI.HEAD.DOWN
      STATE.CANVAS[head.row][head.col] = EMOJI.NECK.LEFT_2
    when EMOJI.HEAD.UP
      STATE.CANVAS[head.row][head.col] = EMOJI.NECK.LEFT

  if head.col is 0
    addCol(true)
    STATE.CANVAS[head.row][head.col] = EMOJI.HEAD.LEFT
  else
    STATE.CANVAS[head.row][head.col - 1] = EMOJI.HEAD.LEFT

  return true

serializeCanvas = () ->
  EMOJI.BLANK + '\n' + STATE.CANVAS.map((row) ->
    row.join('').replace(/(:blank:)+$/g, '')
  ).join('\n')

STATE.CANVAS = createCanvas()

module.exports = (robot) ->
  # This regular expression will match strings like "gavin <command1> ... <commandN>".
  # We'll take care of filtering the commands in the response handler.
  robot.respond /gavin\s+((?:\w+\s*)+)/i, (msg) ->
    commands = []
    for command in msg.match[1].trim().replace(/\s+/g, ' ').split(' ')
      if (/(up|right|down|left|reset)/i).test(command)
        commands.push(command)

    if commands.length
      results = (updateCanvas(command) for command in commands)

      # As long as some of the commands are successful send out the result.
      if results.some((result) -> result)
        msg.send serializeCanvas()
      else
        # If none of the actions worked then notify the user that they done
        # messed up.
        msg.send "Gavin can't move in #{if matches.length == 1 then 'that direction' else 'those directions'}."
    else
      msg.send serializeCanvas()
