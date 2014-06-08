NoteManager = require('../src/scripts/note_manager.coffee').NoteManager

describe "note manager test", ->
  manager = undefined
  robot = undefined
  spy = undefined
  beforeEach (done) ->
    @clock = sinon.useFakeTimers(0, "setTimeout", "clearTimeout", "setInterval", "clearInterval", "Date")

    robot = sinon.stub()
    robot.brain = sinon.stub()
    robot.brain.on = sinon.stub()

    manager = new NoteManager robot
    sinon.stub(manager, "saveNote").returns(true)

    done()

  describe "getNoteList", ->
    beforeEach (done) ->
      done()

    it "no exist", (done) ->
      assert.equal manager.getNoteList('room', 'list'), null
      done()