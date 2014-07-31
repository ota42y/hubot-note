NoteManager = require('../src/hubot_note_scripts/note_manager.coffee').NoteManager


describe "note manager test", ->
  robot = undefined

  room_test_name = undefined
  note_test_title = undefined
  beforeEach (done) ->
    @clock = sinon.useFakeTimers(0, "setTimeout", "clearTimeout", "setInterval", "clearInterval", "Date")

    robot = sinon.stub()
    robot.brain = sinon.stub()
    robot.brain.on = sinon.stub()

    room_test_name = "test"
    note_test_title = "test_note"

    done()

  describe "functions", ->
    describe "createNote", ->
      manager = undefined

      beforeEach (done) ->
        manager = new NoteManager robot
        sinon.stub(manager, "saveNote").returns(true)
        done()

      it "success", (done) ->
        assert.equal note_test_title, manager.createNewNote(room_test_name, note_test_title).title
        assert.notEqual null, manager.getNote(room_test_name, note_test_title)
        done()

    describe "getNote", ->
      manager = undefined

      beforeEach (done) ->
        manager = new NoteManager robot
        sinon.stub(manager, "saveNote").returns(true)
        done()

      it "no exist", (done) ->
        assert.equal manager.getNote('room', 'note'), null
        done()

      it "exist", (done) ->
        assert.equal null, manager.getNote(room_test_name, note_test_title)
        assert.equal note_test_title, manager.createNewNote(room_test_name, note_test_title).title
        assert.equal note_test_title, manager.getNote(room_test_name, note_test_title).title
        done()


  describe "commands", ->

    describe "executeGetStartedNote", ->
      manager = undefined

      beforeEach (done) ->
        manager = new NoteManager robot
        sinon.stub(manager, "saveNote").returns(true)
        done()

      it "not started", (done) ->
        assert.equal null, manager.executeGetStartedNote(room_test_name, note_test_title)
        done()

      it "started", (done) ->
        manager.executeStartNote(room_test_name, note_test_title)
        assert.equal note_test_title, manager.executeGetStartedNote(room_test_name, note_test_title).title
        done()

      it "started any note", (done) ->
        manager.executeStartNote(room_test_name, note_test_title)
        assert.equal note_test_title, manager.executeGetStartedNote(room_test_name).title
        done()

    describe "executeStartNote()", ->
      manager = undefined

      beforeEach (done) ->
        manager = new NoteManager robot
        sinon.stub(manager, "saveNote").returns(true)
        done()

      it "start note", (done) ->
        assert.equal true, manager.executeStartNote(room_test_name, note_test_title)
        done()

      it "already started", (done) ->
        manager.executeStartNote(room_test_name, note_test_title)
        assert.equal false, manager.executeStartNote(room_test_name, note_test_title)
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
        manager.executeStartNote(room_test_name, note_test_title)
        for line in all_line
          manager.writeTextToNewestNoteInRoom(room_test_name, line)
        assert.equal all_line.join("\n"), manager.executeNoteShow(room_test_name, note_test_title)
        done()

      it "show 3 lines in note", (done) ->
        manager.executeStartNote(room_test_name, note_test_title)
        for line in all_line
          manager.writeTextToNewestNoteInRoom(room_test_name, line)
        assert.equal all_line.slice(1).join("\n"), manager.executeNoteShow(room_test_name, note_test_title, 3)
        done()

      it 'nothing show note', (done) ->
        assert.equal null, manager.executeNoteShow(room_test_name, note_test_title)
        done()

      it 'when all note is end, show no exist message', (done) ->
        for line in all_line
          manager.executeStartNote(room_test_name, note_test_title + line)
          manager.writeTextToNewestNoteInRoom(room_test_name, line)
          manager.executeNoteStop(room_test_name, note_test_title + line)

        assert.equal all_line[all_line.length-1], manager.executeNoteShow(room_test_name)
        done()



    describe "executeNoteEnd()", ->
      manager = undefined

      beforeEach (done) ->
        manager = new NoteManager robot
        sinon.stub(manager, "saveNote").returns(true)
        manager.executeStartNote(room_test_name, note_test_title)
        done()

      it 'end', (done) ->
        assert.equal true, manager.executeNoteStop(room_test_name, note_test_title)
        done()

      it "don't exist started note", (done) ->
        manager.executeNoteStop(room_test_name, note_test_title)
        note = manager.executeGetStartedNote(room_test_name, note_test_title)
        assert.equal note, null
        done()

      it 'already end', (done) ->
        manager.executeNoteStop(room_test_name, note_test_title)
        assert.equal false, manager.executeNoteStop(room_test_name, note_test_title)
        done()

