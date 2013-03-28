class ParticipationGraph
  constructor: (b) ->

    @onSuccess = (b) =>
      return ParticipationGraph.prototype.onSuccess.apply(this,arguments)

    @el = $(b)
    @canvas = b.getContext("2d")
    e = window.devicePixelRatio || 1
    d = @canvas.webkitBackingStorePixelRatio || @canvas.mozBackingStorePixelRatio || @canvas.msBackingStorePixelRatio || @canvas.oBackingStorePixelRatio || @canvas.backingStorePixelRatio || 1
    h = e / d
    if h != 1
      i = b.width
      f = b.height
      b.width = i * h
      b.height = f * h
      b.style.width = i+"px"
      b.style.height = f+"px"
      @canvas.scale h,h

    c = @el.data("color-all")

    @colors.all = c if c != null

    @barMaxHeight = @el.height()
    @barWidth = (@el.width()-52)/52

    @refresh()

    return

  colors: 
    all:"#cacaca"
    owner: "#336699"

  getUrl: ->
    @el.data("source")

  setData: (@data) ->
    
    unless @data?.all?
      @data = null
    @scale = @getScale(@data)
    return

  getScale: (a) ->
    return if a==null
    b = a.all[0]
    f = a.all

    for c in f
      b = c if c>b
    
    return if b>= @barMaxHeight then (@barMaxHeight-0.1)/b else 1

  refresh: ->
    $.ajax
      url: @getUrl()
      dataType: "json"
      success: @onSuccess
    return

  onSuccess: (data) ->
    @setData(data)
    @draw()
    return

  draw: ->
    return if @data==null

    @drawCommits @data.all, @colors.all
    return

  drawCommits: (data,color) ->
    for c,e in data
      f = @barWidth
      d = c * @scale
      g = e * (@barWidth+1)
      h = @barMaxHeight - d
      @canvas.fillStyle = color
      @canvas.fillRect g, h, f, d
    return

$(document).ready ->
  $(".participation-graph").each ->
    new ParticipationGraph($(this).find("canvas")[0])
    return
  return
  