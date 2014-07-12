strftime = require('strftime')

HubotNote = require('../src/scripts/hubot_note.coffee').HubotNote

describe "hubot note test", ->
  robot = undefined
  hubot_note = undefined

  room_name = undefined
  note_name = undefined
  beforeEach (done) ->
    robot = sinon.stub()
    robot.brain = sinon.stub()
    robot.brain.on = sinon.stub()
    @clock = sinon.useFakeTimers(0, "setTimeout", "clearTimeout", "setInterval", "clearInterval", "Date")

    room_name = "test room"
    note_name = strftime('%Y-%m-%d', new Date)
    done()

  describe "functions", ->
    describe "show note list", ->
      beforeEach (done) ->
        hubot_note = new HubotNote robot
        done()

      it "show empty note"
      ###
      it "show empty note", (done) ->
        response = hubot_note.executeMessage(room_name, "note show")
        done()
      ###

      it "show note"
      ###
      it "show note", (done) ->
        response = hubot_note.executeMessage(room_name, "note start")
        response = hubot_note.executeMessage(room_name, "line1")
        response = hubot_note.executeMessage(room_name, "line2")
        response = hubot_note.executeMessage(room_name, "note show")
        assert.equal response, "line1\nline2"
        done()
      ###


# note start (note_name)
# note isStart? (note_name)
# note end (note_name)
#  end current started note in room
#   if you set note_name, end specific note
# note show (note_name) (note_number)
#  show specific latest note
#   if you set note_name, show note_name's latest text
