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

    return @createNewNote(room_name, note_list_name)

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
    note = getStartNoteInRoom(room_name, note_list_name)
    if note
      note.setEnd(ned Date())
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
    note_dict = @all_note[room_name]

    if note_dict
      for key, note_list of note_dict
        if 0 < note_list.length
          last_note = note_list[note_list.length-1]
          if not last_note.isEnd()
            return last_note

    return null

  # write text to newest note
  writeNote: (room_name, text) ->
    if text
      note = @getStartNoteInRoom(room_name)
      if note
        note.addLine text
        @saveNote()
        console.log "add message: " + msg.message.text

module.exports.NoteManager = NoteManager
