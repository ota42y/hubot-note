strftime = require('strftime')

NoteManager = require('./note_manager.coffee').NoteManager

class HubotNote
  constructor: (robot) ->
    @note_manager = new NoteManager robot
    @name_match = new RegExp("^" + robot.name)

  executeMessage: (room_name, text) ->
    message_words = text.split " "

    user_name = message_words[0]

    if user_name.match @name_match
      command_name = message_words[1]
      command_type = message_words[2]
      note_title = @getOptionValue(message_words, "-n", strftime('%Y-%m-%d', new Date))

      if command_name == "note"
        switch command_type
          when "start"
            # hoge
            return @executeNoteStart(room_name, note_title)
          when "isStart?"
            # isStart?
            return @executeIsStart(room_name, note_title)
          when "stop"
            # end
            return @executeNoteStop(room_name, note_title)
          when "show"
            # show (-l show_line_num)
            return @executeNoteShow(room_name, note_title, @getOptionValue(message_words, "-l", null))


    # not match command

    # write note
    @note_manager.writeTextToNewestNoteInRoom room_name, text
    return null

  getNoteName: (note_title) ->
    if note_title
      return note_title
    else
      return strftime('%Y-%m-%d', new Date)

  getOptionValue: (split_str, option_str, default_str) ->
    index = split_str.indexOf(option_str)
    if 0 < index and index+1 < split_str.length
      return split_str[index+1]
    else
      return default_str

  executeNoteStart: (room_name, note_title) ->
    if @note_manager.executeStartNote room_name, note_title
      return "note \"" + note_title + "\" start"
    else
      return "note \"" + note_title + "\" alredy started"

  executeIsStart: (room_name, note_title) ->
    if @note_manager.executeIsStartNote room_name, note_title
      return "note \"" + note_title + "\" already started"
    else
      return "note \"" + note_title + "\" not start"

  executeNoteStop: (room_name, note_title) ->
    if @note_manager.executeNoteStop room_name, note_title
      return "note \"" + note_title + "\" stopped"
    else
      return "note \"" + note_title + "\" not start"

  executeNoteShow: (room_name, note_title, line_num) ->
    note_text = @note_manager.executeNoteShow room_name, note_title, line_num
    if note_text
      return note_text
    else
      return "note \"" + note_title + "\" not exist"

module.exports.HubotNote = HubotNote
