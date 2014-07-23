HubotNote = require('./hubot_note_scripts/hubot_note.coffee').HubotNote

# note start (note_name)
# note isStart? (note_name)
# note end (note_name)
#  end current started note in room
#   if you set note_name, end specific note
# note show (note_name) (note_number)
#  show specific latest note
#   if you set note_name, show note_name's latest text

module.exports = (robot) ->
  hubot_note = new HubotNote robot

  # note start (note_name)
  # if not set value, use default value
  # default:
  #  note start YY_MM_DD_note

  robot.hear /.*/, (msg) ->
    if msg.message.room
      room_name = msg.message.room
    else
      room_name = msg.message.user.name

    text = msg.message.text

    response = hubot_note.executeMessage(room_name, text)
    if response
      msg.send response
