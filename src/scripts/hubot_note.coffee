
Note = require('./note.coffee').Note


###
 * http://qiita.com/osakanafish/items/c64fe8a34e7221e811d0
 * 日付をフォーマットする
 * @param  {Date}   date     日付
 * @param  {String} [format] フォーマット
 * @return {String}          フォーマット済み日付
###
formatDate = (date, format = 'YYYY-MM-DD hh:mm:ss.SSS') ->
  format = format.replace /YYYY/g, date.getFullYear()
  format = format.replace /MM/g, ('0' + (date.getMonth() + 1)).slice(-2)
  format = format.replace /DD/g, ('0' + date.getDate()).slice(-2)
  format = format.replace /hh/g, ('0' + date.getHours()).slice(-2)
  format = format.replace /mm/g, ('0' + date.getMinutes()).slice(-2)
  format = format.replace /ss/g, ('0' + date.getSeconds()).slice(-2)
  if format.match /S/g
    milliSeconds = ('00' + date.getMilliseconds()).slice(-3)
    length = format.match(/S/g).length
    format.replace /S/, milliSeconds.substring(i, i + 1) for i in [0...length]
  return format


class RoomNoteManager
  constructor: (@robot) ->
    @all_Note = {}

    @robot.brain.on 'loaded', ->
      if @robot.brain.data.all_note
        @all_note = @robot.brain.data.all_note

  saveNote: ->
    @robot.brain.data.all_note = @all_note

  executeStartNote: (room_name, note_list_name) ->
    if @executeIsStartNote(room_name, note_list_name)
      return false

    console.log "room_name: " + room_name + "\nnote_list_name: " + note_list_name

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
        return last_note.isEnd()
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


# note start (note_name)
# note isStart? (note_name)
# note end (note_name)
#  end current started note in room
#   if you set note_name, end specific note
# note show (note_name) (note_number)
#  show specific latest note
#   if you set note_name, show note_name's latest text

module.exports = (robot) ->

  note_manager = new RoomNoteManager robot

  # note start (note_name)
  # if not set value, use default value
  # default:
  #  note start YY_MM_DD_note

  robot.respond /.*/, (msg) ->
    if msg.message.room
      room_name = msg.message.room
    else
      room_name = msg.message.user.name

    if executeNoteCommand(msg, room_name)
      return

    # write note
    note_manager.writeNote room_name, msg.message.text

  executeNoteCommand = (msg, room_name) ->
    message_words = msg.message.text.split " "

    command_name = message_words[1]
    command_type = message_words[2]
    note_name = getOptionValue(message_words, "-n", formatDate(new Date(), "YYYY_MM_DD_note"))

    if command_name == "note"
      switch command_type
        when "start"
          # hoge
          return executeNoteStart(msg, room_name, note_name)
        when "isStart?"
          # isStart?
          return executeIsStart(msg, room_name, note_name)
        when "end"
          # end
          return executeNoteEnd(msg, room_name, note_name)
        when "show"
          # show (-l show_line_num)
          return executeNoteShow(msg, room_name, note_name, getOptionValue(message_words, "-l", null))


    # not match command
    return false

  getNoteName = (note_name) ->
    if note_name
      return note_name
    else
      return formatDate(new Date(), "YYYY_MM_DD_note")

  getOptionValue = (split_str, option_str, default_str) ->
    index = split_str.indexOf(option_str)
    if 0 < index and index+1 < split_str.length
      return split_str[index+1]
    else
      return default_str

  executeNoteStart = (msg, room_name, note_name) ->
    if note_manager.executeStartNote room_name, note_name
      msg.send "note \"" + note_name + "\" start"
    else
      msg.send "note \"" + note_name + "\" alredy started"

    return true

  executeIsStart = (msg, room_name, note_name) ->
    if note_manager.executeIsStartNote room_name, note_name
      msg.send "note \"" + note_name + "\" already started"
    else
      msg.send "note \"" + note_name + "\" not start"
    return true

  executeNoteEnd = (msg, room_name, note_name) ->
    if note_manager.executeNoteEnd room_name, note_name
      msg.send "note \"" + note_name + "\" stopped"
    else
      msg.send "note \"" + note_name + "\" not start"
    return true

  executeNoteShow = (msg, room_name, note_name, line_num) ->
    note_text = note_manager.executeNoteShow room_name, note_name, line_num
    if note_text
      msg.send note_text
    else
      msg.send "note \"" + note_name + "\" not exist"
    return true
