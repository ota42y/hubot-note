strftime = require('strftime')

NoteManager = require('./note_manager.coffee').NoteManager

class HubotNote
  constructor: (robot) ->
    @note_manager = new NoteManager robot

  executeMessage: (room_name, text) ->
    message_words = text.split " "

    command_name = message_words[1]
    command_type = message_words[2]
    note_name = getOptionValue(message_words, "-n", strftime('%Y-%m-%d', new Date))

    if command_name == "note"
      switch command_type
        when "start"
          # hoge
          return executeNoteStart(room_name, note_name)
        when "isStart?"
          # isStart?
          return executeIsStart(room_name, note_name)
        when "end"
          # end
          return executeNoteEnd(room_name, note_name)
        when "show"
          # show (-l show_line_num)
          return executeNoteShow(room_name, note_name, getOptionValue(message_words, "-l", null))


    # not match command

    # write note
    @note_manager.writeTextToNewestNoteInRoom room_name, text
    return null

  getNoteName = (note_name) ->
    if note_name
      return note_name
    else
      return strftime('%Y-%m-%d', new Date)

  getOptionValue = (split_str, option_str, default_str) ->
    index = split_str.indexOf(option_str)
    if 0 < index and index+1 < split_str.length
      return split_str[index+1]
    else
      return default_str

  executeNoteStart = (room_name, note_name) ->
    if note_manager.executeStartNote room_name, note_name
      return "note \"" + note_name + "\" start"
    else
      return "note \"" + note_name + "\" alredy started"

  executeIsStart = (room_name, note_name) ->
    if note_manager.executeIsStartNote room_name, note_name
      return "note \"" + note_name + "\" already started"
    else
      return "note \"" + note_name + "\" not start"

  executeNoteEnd = (room_name, note_name) ->
    if note_manager.executeNoteEnd room_name, note_name
      return "note \"" + note_name + "\" stopped"
    else
      return "note \"" + note_name + "\" not start"

  executeNoteShow = (room_name, note_name, line_num) ->
    note_text = note_manager.executeNoteShow room_name, note_name, line_num
    if note_text
      return note_text
    else
      return "note \"" + note_name + "\" not exist"

module.exports.HubotNote = HubotNote
