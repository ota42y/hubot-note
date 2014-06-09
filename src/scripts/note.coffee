

class Note
  constructor: (start_at) ->
    @start_at = start_at
    @end_at = null
    @text = []
    @setTitle(@start_at)

  addLine: (line) ->
    @text.push(line)

  getText: (line_num) ->
    if line_num
      start_pos = Math.max(0, @text.length - line_num)
      return @text.slice(start_pos).join("\n")
    else
      return @text.join("\n")

  setEnd: (end_at) ->
    @end_at = end_at

  setTitle: (text) ->
    @title = text

  isEnd: ->
    return @end_at != null

module.exports.Note = Note