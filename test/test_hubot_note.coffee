strftime = require('strftime')

HubotNote = require('../src/hubot_note_scripts/hubot_note.coffee').HubotNote

describe "hubot note test", ->
  robot = undefined
  hubot_note = undefined

  room_name = undefined
  note_title = undefined
  beforeEach (done) ->
    robot = new Object()
    robot.brain = sinon.stub()
    robot.brain.on = sinon.stub()
    robot.brain.data = sinon.stub()
    robot.brain.data.all_note = sinon.stub()
    robot.name = "hubot"

    @clock = sinon.useFakeTimers(0, "setTimeout", "clearTimeout", "setInterval", "clearInterval", "Date")

    room_name = "test_room"
    note_title = strftime('%Y-%m-%d', new Date)
    done()

  describe "functions", ->
    describe "show note list", ->
      beforeEach (done) ->
        hubot_note = new HubotNote robot
        done()

      it "executeNoteShow", (done) ->
        spy = sinon.spy(hubot_note, "executeNoteShow")
        spy.withArgs(room_name, note_title, null)
        response = hubot_note.executeMessage(room_name, "hubot note show")
        assert.ok spy.withArgs(room_name, note_title, null).calledOnce
        done()

      it "show empty note", (done) ->
        response = hubot_note.executeMessage(room_name, "hubot note show")
        assert.equal response, "note \"#{note_title}\" not exist"
        done()

      it "show note", (done) ->
        response = hubot_note.executeMessage(room_name, "hubot note start")
        response = hubot_note.executeMessage(room_name, "line1")
        response = hubot_note.executeMessage(room_name, "line2")
        response = hubot_note.executeMessage(room_name, "hubot note show")
        assert.equal response, "line1\nline2"
        done()

      it "append text to note", (done) ->
        response = hubot_note.executeMessage(room_name, "hubot note start")
        response = hubot_note.executeMessage(room_name, "line1")
        response = hubot_note.executeMessage(room_name, "line2")
        response = hubot_note.executeMessage(room_name, "hubot note stop")
        response = hubot_note.executeMessage(room_name, "not_show_line")
        response = hubot_note.executeMessage(room_name, "hubot note start")
        response = hubot_note.executeMessage(room_name, "line3")
        response = hubot_note.executeMessage(room_name, "hubot note show")
        assert.equal response, "line1\nline2\nline3"
        done()


    describe "note start", ->
      beforeEach (done) ->
        hubot_note = new HubotNote robot
        done()

      describe "note start", ->
        it "start ", (done) ->
          response = hubot_note.executeMessage(room_name, "hubot note start")
          assert.equal response, "note \"#{note_title}\" start"
          done()

        it "start other name", (done) ->
          new_note_title = "test_note"
          response = hubot_note.executeMessage(room_name, "hubot note start -n #{new_note_title}")
          assert.equal response, "note \"#{new_note_title}\" start"
          done()

    describe "note end", ->
      beforeEach (done) ->
        hubot_note = new HubotNote robot
        done()

      describe "note stop", ->
        it "stop", (done) ->
          response = hubot_note.executeMessage(room_name, "hubot note start")
          response = hubot_note.executeMessage(room_name, "hubot note stop")
          assert.equal response, "note \"#{note_title}\" stopped"
          done()

        it "stop save text", (done) ->
          response = hubot_note.executeMessage(room_name, "hubot note start")
          response = hubot_note.executeMessage(room_name, "line1")
          response = hubot_note.executeMessage(room_name, "line2")
          response = hubot_note.executeMessage(room_name, "hubot note stop")
          response = hubot_note.executeMessage(room_name, "line3")
          response = hubot_note.executeMessage(room_name, "hubot note show -n #{note_title}")
          assert.equal response, "line1\nline2"
          done()

