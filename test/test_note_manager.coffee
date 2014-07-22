NoteManager = require('../src/hubot_note_scripts/note_manager.coffee').NoteManager


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

  describe "functions", ->
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


  describe "commands", ->

    describe "executeIsStartNote()", ->
      manager = undefined

      beforeEach (done) ->
        manager = new NoteManager robot
        sinon.stub(manager, "saveNote").returns(true)
        done()

      it "not started", (done) ->
        assert.equal false, manager.executeIsStartNote(room_test_name, room_list_test_name)
        done()

      it "started", (done) ->
        manager.executeStartNote(room_test_name, room_list_test_name)
        assert.equal true, manager.executeIsStartNote(room_test_name, room_list_test_name)
        done()


    describe "executeStartNote()", ->
      manager = undefined

      beforeEach (done) ->
        manager = new NoteManager robot
        sinon.stub(manager, "saveNote").returns(true)
        done()

      it "start note", (done) ->
        assert.equal true, manager.executeStartNote(room_test_name, room_list_test_name)
        done()

      it "already started", (done) ->
        manager.executeStartNote(room_test_name, room_list_test_name)
        assert.equal false, manager.executeStartNote(room_test_name, room_list_test_name)
        done()

    describe "executeNoteShow()", ->
      manager = undefined
      all_line = undefined

      beforeEach (done) ->
        manager = new NoteManager robot
        sinon.stub(manager, "saveNote").returns(true)

        all_line = []
        all_line.push "line_1"
        all_line.push "line_2"
        all_line.push "line_3"
        all_line.push "line_4"

        done()

      it "show all lines in note", (done) ->
        manager.executeStartNote(room_test_name, room_list_test_name)
        for line in all_line
          manager.writeTextToNewestNoteInRoom(room_test_name, line)
        assert.equal all_line.join("\n"), manager.executeNoteShow(room_test_name, room_list_test_name)
        done()

      it "show 3 lines in note", (done) ->
        manager.executeStartNote(room_test_name, room_list_test_name)
        for line in all_line
          manager.writeTextToNewestNoteInRoom(room_test_name, line)
        assert.equal all_line.slice(1).join("\n"), manager.executeNoteShow(room_test_name, room_list_test_name, 3)
        done()

      it 'nothing show note', (done) ->
        assert.equal null, manager.executeNoteShow(room_test_name, room_list_test_name)
        done()

      it 'when all note is end, but show note latest one', (done) ->
        for line in all_line
          manager.executeStartNote(room_test_name, room_list_test_name)
          manager.writeTextToNewestNoteInRoom(room_test_name, line)
          manager.executeNoteStop(room_test_name, room_list_test_name)

        assert.equal all_line[all_line.length-1], manager.executeNoteShow(room_test_name, room_list_test_name)
        done()



    describe "executeNoteEnd()", ->
      manager = undefined

      beforeEach (done) ->
        manager = new NoteManager robot
        sinon.stub(manager, "saveNote").returns(true)
        manager.executeStartNote(room_test_name, room_list_test_name)
        done()

      it 'end', (done) ->
        assert.equal true, manager.executeNoteStop(room_test_name, room_list_test_name)
        done()

      it 'set end date', (done) ->
        manager.executeNoteStop(room_test_name, room_list_test_name)
        latest_note = manager.getLatestNoteInRoom(room_test_name, room_list_test_name)
        assert.equal new Date().getTime(), latest_note.end_at.getTime()
        done()

      it 'already end', (done) ->
        manager.executeNoteStop(room_test_name, room_list_test_name)
        assert.equal false, manager.executeNoteStop(room_test_name, room_list_test_name)
        done()
