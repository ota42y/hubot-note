Note = require('./note.coffee').Note

class NoteManager
  constructor: (@robot) ->
    @all_note = {}
    @started_note_list = []

    @robot.brain.on 'loaded', ->
      if @robot.brain.data.all_note
        @all_note = @robot.brain.data.all_note

  saveNote: ->
    @robot.brain.data.all_note = @all_note

  executeStartNote: (room_name, note_title) ->
    # already started
    if @executeGetStartedNote(room_name, note_title)
      return false

    note = @getNote(room_name, note_title)
    if note == null
      note = @createNewNote(room_name, note_title)

    if note == null
      return false

    @started_note_list.push(note)
    return true

  createNewNote: (room_name, note_title) ->
    note_dict = @all_note[room_name]

    if !note_dict
      note_dict= {}
      @all_note[room_name] = note_dict

    note = note_dict[note_title]
    if !note
      note = new Note(note_title, new Date())
      note_dict[note_title] = note

    @saveNote()
    return note

  executeNoteStop: (room_name, note_list_name) ->
    note = @executeGetStartedNote(room_name, note_list_name)

    if note
      note.setEnd(new Date())
      @saveNote()
      i = @started_note_list.length - 1
      while i >= 0
        if @started_note_list[i].title == note_list_name
          @started_note_list.splice i, 1
        i--

      return true
    return false

  executeGetStartedNote: (room_name, note_title = null) ->
    return null if @started_note_list.length == 0

    if note_title == null
      return @started_note_list[@started_note_list.length - 1]

    for index in [0..@started_note_list.length-1]
      note = @started_note_list[index]
      if note.title == note_title
        return note
    return null

  executeNoteShow: (room_name, note_title, line_num) ->
    note = @getNote(room_name, note_title)
    if note
      return note.getText(line_num)
    return null

  getNote: (room_name, note_title) ->
    note_dict = @all_note[room_name]

    if note_dict
      note = note_dict[note_title]
      if note
        return note
    return null

  # write text to newest note
  writeTextToNewestNoteInRoom: (room_name, text) ->
    if text
      note = @executeGetStartedNote(room_name)
      if note
        note.addLine text
        @saveNote()

module.exports.NoteManager = NoteManager
