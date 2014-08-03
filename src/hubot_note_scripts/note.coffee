

class Note
  constructor: (title, start_at) ->
    @start_at = start_at
    @end_at = null
    @text = []
    @title = title

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

  isEnd: ->
    return @end_at != null

module.exports.Note = Note
