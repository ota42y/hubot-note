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

    room_name = "test_room"
    note_name = strftime('%Y-%m-%d', new Date)
    done()

  describe "functions", ->
    describe "show note list", ->
      beforeEach (done) ->
        hubot_note = new HubotNote robot
        done()

      it "executeNoteShow", (done) ->
        spy = sinon.spy(hubot_note, "executeNoteShow")
        spy.withArgs(room_name, note_name, null)
        response = hubot_note.executeMessage(room_name, "note show")
        assert.ok spy.withArgs(room_name, note_name, null).calledOnce
        done()

      it.skip "show empty note", (done) ->
        response = hubot_note.executeMessage(room_name, "note show")
        assert.equal response, "note \"#{note_name}\" not exist"
        done()

      it.skip "show note", (done) ->
        response = hubot_note.executeMessage(room_name, "note start")
        response = hubot_note.executeMessage(room_name, "line1")
        response = hubot_note.executeMessage(room_name, "line2")
        response = hubot_note.executeMessage(room_name, "note show")
        assert.equal response, "line1\nline2"
        done()

    describe "note start", ->
      beforeEach (done) ->
        hubot_note = new HubotNote robot
        done()

      describe "note start", ->
        it.skip "start ", (done) ->
          response = hubot_note.executeMessage(room_name, "note start")
          assert.equal response, "note \"#{note_name}\" start"
          done()

        it.skip "start other name", (done) ->
          new_note_name = "test_note"
          response = hubot_note.executeMessage(room_name, "note start #{new_note_name}")
          assert.equal response, "note \"#{new_note_name}\" start"
          done()

    describe "note end", ->
      beforeEach (done) ->
        hubot_note = new HubotNote robot
        done()

      describe "note end", ->
        it.skip "end", (done) ->
          response = hubot_note.executeMessage(room_name, "note start")
          response = hubot_note.executeMessage(room_name, "note end")
          assert.equal response, "note \"#{note_name}\" end"
          done()

        it.skip "start other name", (done) ->
          response = hubot_note.executeMessage(room_name, "note start")
          response = hubot_note.executeMessage(room_name, "line1")
          response = hubot_note.executeMessage(room_name, "line2")
          response = hubot_note.executeMessage(room_name, "note end")
          response = hubot_note.executeMessage(room_name, "line3")
          response = hubot_note.executeMessage(room_name, "note show #{note_name}")
          assert.equal response, "line1\nline2"
          done()


# note start (note_name)
# note isStart? (note_name)
# note end (note_name)
#  end current started note in room
#   if you set note_name, end specific note
# note show (note_name) (note_number)
#  show specific latest note
#   if you set note_name, show note_name's latest text
