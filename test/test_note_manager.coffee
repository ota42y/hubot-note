NoteManager = require('../src/scripts/note_manager.coffee').NoteManager

describe "note manager test", ->
  robot = undefined

  room_test_name = undefined
  room_list_test_name = undefined
  beforeEach (done) ->
    @clock = sinon.useFakeTimers(0, "setTimeout", "clearTimeout", "setInterval", "clearInterval", "Date")

    robot = sinon.stub()
    robot.brain = sinon.stub()
    robot.brain.on = sinon.stub()

    room_test_name = "test"
    room_list_test_name = "test_list"

    done()


  describe "createNote", ->
    manager = undefined

    beforeEach (done) ->
      manager = new NoteManager robot
      sinon.stub(manager, "saveNote").returns(true)
      done()

    it "success", (done) ->
      assert.equal true, manager.createNewNote(room_test_name, room_list_test_name)
      assert.notEqual null, manager.getNoteList(room_test_name, room_list_test_name)
      done()

  describe "getNoteList", ->
    manager = undefined

    beforeEach (done) ->
      manager = new NoteManager robot
      sinon.stub(manager, "saveNote").returns(true)
      done()

    it "no exist", (done) ->
      assert.equal manager.getNoteList('room', 'list'), null
      done()

    it "exist", (done) ->
      assert.equal null, manager.getNoteList(room_test_name, room_list_test_name)
      assert.equal true, manager.createNewNote(room_test_name, room_list_test_name)
      assert.notEqual null, manager.getNoteList(room_test_name, room_list_test_name)
      done()

