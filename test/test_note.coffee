Note = require('../src/hubot_note_scripts/note.coffee').Note

describe "note test", ->
  date = undefined
  beforeEach (done) ->
    date = new Date()
    done()

  describe "note method", ->
    note = undefined
    beforeEach (done) ->
      note = new Note date
      done()

    it 'set date', (done)->
      assert.equal note.start_at, date
      done()

    it 'set title', (done) ->
      assert.equal note.title, date
      done()

    it 'add text', (done) ->
      text = "this is test"
      note.addLine(text)
      assert.equal note.getText(), text
      done()

    it 'isEnd()', (done) ->
      assert.equal note.isEnd(), false
      note.setEnd(new Date())
      assert.equal note.isEnd(), true
      done()

    describe "multi text", ->
      text_list = undefined

      beforeEach (done) ->
        text = "abc def ghi jkl mno"
        text_list = text.split(" ")
        for line in text_list
          note.addLine line
        done()

      it 'get all lines', (done) ->
        assert.equal note.getText(), text_list.join "\n"
        done()

      it 'get specific lines', (done) ->
        assert.equal note.getText(3), text_list.slice(2).join("\n")
        done()
