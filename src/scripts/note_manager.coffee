Note = require('./note.coffee').Note

class NoteManager
  constructor: (@robot) ->
    @all_note = {}

    @robot.brain.on 'loaded', ->
      if @robot.brain.data.all_note
        @all_note = @robot.brain.data.all_note

  saveNote: ->
    @robot.brain.data.all_note = @all_note

  executeStartNote: (room_name, note_list_name) ->
    if @executeIsStartNote(room_name, note_list_name)
      return false

    return @createNewNote(room_name, note_list_name) != null

  createNewNote: (room_name, note_list_name) ->
    note_dict = @all_note[room_name]

    if !note_dict
      note_dict= {}
      @all_note[room_name] = note_dict

    note_list = note_dict[note_list_name]
    if !note_list
      note_list = []
      note_dict[note_list_name] = note_list

    note_list.push(new Note(new Date()))

    @saveNote()
    return true

  executeNoteEnd: (room_name, note_list_name) ->
    note = @getStartNoteInRoom(room_name, note_list_name)
    if note
      note.setEnd(new Date())
      @saveNote()
      return true
    return false

  executeIsStartNote: (room_name, note_list_name) ->
    note_list = @getNoteList(room_name, note_list_name)
    if note_list
      if 0 < note_list.length
        last_note = note_list[note_list.length-1]
        return !last_note.isEnd()
    return false

  executeNoteShow: (room_name, note_list_name, line_num) ->
    note_list = @getNoteList(room_name, note_list_name)
    if note_list
      if 0 < note_list.length
        last_note = note_list[note_list.length-1]
        return last_note.getText(line_num)
    return null

  getNoteList: (room_name, note_list_name) ->
    note_dict = @all_note[room_name]

    if note_dict
      note_list = note_dict[note_list_name]
      return note_list
    return null

  # get newest started note
  getStartNoteInRoom: (room_name) ->
    latest_note = @getLatestNoteInRoom(room_name)

    if latest_note
      if not latest_note.isEnd()
        return latest_note

    return null

  getLatestNoteInRoom: (room_name) ->
    note_dict = @all_note[room_name]

    if note_dict
      for key, note_list of note_dict
        if 0 < note_list.length
          return note_list[note_list.length-1]

    return null

  # write text to newest note
  writeTextToNewestNoteInRoom: (room_name, text) ->
    if text
      note = @getStartNoteInRoom(room_name)
      if note
        note.addLine text
        @saveNote()

module.exports.NoteManager = NoteManager
