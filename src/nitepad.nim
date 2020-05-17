## Nitepad application

import nitepad/gtk

type
  Point = tuple
    width, x, y: float64
  Brush = object
    red, green, blue, alpha: float64
    points: seq[Point]
  CanvasCtx = ref object
    surface: Surface
    brushes: seq[Brush]
    lastPressure: float64
  WindowCtx = ref object
    canvas: CanvasCtx

func brush(
  red, green, blue, alpha: float64
): Brush =
  Brush(
    red: red,
    green: green,
    blue: blue,
    alpha: alpha)

func newCanvasCtx(): CanvasCtx =
  new result
  result = CanvasCtx(lastPressure: 1)

func newWindowCtx(): WindowCtx =
  new result
  result = WindowCtx(
    canvas: newCanvasCtx())

func onConfig(
  w: DrawingArea,
  ev: EventConfig,
  ctx: var CanvasCtx
): bool =
  ctx.surface = newSurface(w)

func onRealize(
  w: DrawingArea,
  ctx: var CanvasCtx
): bool =
  # Event compression will
  # merge motion events in queue
  # and produce non-smooth drawing
  # curves
  w.setEventCompression(false)

# XXX use lastPressure avg for smoother
#     pressure transitions
func onStylusMove(
  s: Stylus,
  arg1, arg2: float64,
  ctx: var CanvasCtx
): bool =
  var pressure: float64
  if getAxis(s, axisPressure, pressure):
    ctx.lastPressure = pressure

func onMousePress(
  w: DrawingArea,
  ev: EventButton,
  ctx: var CanvasCtx
): bool =
  if ev.button == buttonPrimary:
    #debugEcho "press"
    var br = brush(255, 255, 0, 1)
    #br.points.add((width: 12.0, x: ev.x, y: ev.y))
    ctx.brushes.add(br)
    w.queueDraw()

func onMouseRelease(
  w: DrawingArea,
  ev: EventButton,
  ctx: var CanvasCtx
): bool =
  w.queueDraw()

# Xorg takes 20% CPU
when true:
  func onMouseMove(
    w: DrawingArea,
    ev: EventMotion,
    ctx: var CanvasCtx
  ): bool =
    template lastBrush: untyped = ctx.brushes[^1]
    if buttonPressMask in ev.state:
      #debugEcho "move"
      doAssert ctx.brushes.len > 0
      let brWidth = 10.0 * ctx.lastPressure
      lastBrush.points.add (width: brWidth, x: ev.x, y: ev.y)
      if lastBrush.points.len == 1: return
      var scr = newCairo(ctx.surface)
      scr.setSourceRgba(
        lastBrush.red,
        lastBrush.green,
        lastBrush.blue,
        lastBrush.alpha)
      scr.setLineCap()
      scr.setLineJoin()
      scr.newPath()
      scr.setLineWidth(brWidth)
      let x0 = lastBrush.points[^2].x
      let y0 = lastBrush.points[^2].y
      scr.moveTo(x0, y0)
      scr.lineTo(ev.x, ev.y)
      scr.stroke()
      w.queueDrawCoors(x0, y0, ev.x, ev.y, brWidth)

  func onDraw(w: DrawingArea, cr: Cairo, ctx: var CanvasCtx): bool =
    cr.setSourceSurface(ctx.surface, 0, 0)
    cr.paint()

# Xorg uses too much CPU doing this.
# and the drawing is laggy
when false:
  func onMouseMove(
    w: DrawingArea,
    ev: EventMotion,
    ctx: var CanvasCtx
  ): bool =
    if buttonPressMask in ev.state:
      #debugEcho "move"
      doAssert ctx.brushes.len > 0
      ctx.brushes[^1].points.add((
        width: 10.0 * ctx.lastPressure,
        x: ev.x,
        y: ev.y))
      w.queueDraw()

  func onDraw(w: DrawingArea, cr: Cairo, ctx: var CanvasCtx): bool =
    template prev: untyped = br.points[i-1]
    template curr: untyped = br.points[i]
    #debugEcho "draw"
    var scr = newCairo(ctx.surface)
    scr.setSourceRgba(0, 0, 0, 1)
    scr.paint()
    for br in ctx.brushes:
      #debugEcho br
      scr.setSourceRgba(br.red, br.green, br.blue, br.alpha)
      scr.setLineCap()
      scr.setLineJoin()
      scr.newPath()
      for i in 1 .. br.points.len-1:
        scr.setLineWidth(curr.width)
        scr.moveTo(prev.x, prev.y)
        scr.lineTo(curr.x, curr.y)
        scr.stroke()
    cr.setSourceSurface(ctx.surface, 0, 0)
    cr.paint()

func canvas(ctx: var CanvasCtx): DrawingArea =
  result = newDrawingArea()
  var stylus = newStylus(result)
  stylus.signalConnect(evStylusMotion, onStylusMove, ctx)
  result.signalConnect(evDraw, onDraw, ctx)
  result.signalConnect(evConfig, onConfig, ctx)
  result.signalConnect(evMotion, onMouseMove, ctx)
  result.signalConnect(evButtonPress, onMousePress, ctx)
  result.signalConnect(evButtonRelease, onMouseRelease, ctx)
  result.signalConnect(evRealize, onRealize, ctx)
  result.setEvents(
    result.getEvents() +
    pointerMotionMask +
    buttonPressMask +
    buttonReleaseMask +
    touchMask)

func mainWindow(app: App, ctx: var WindowCtx): bool =
  var w = app.newWindow()
  w.setTitle("nitepad")
  w.setDefaultSize(400, 400)
  var box = newBox(spacing = 5)
  w.add(box)
  var cv = canvas(ctx.canvas)
  box.pack_start(cv)
  w.showAll()

proc main() =
  var app = newApp("org.gtk.nitepad")
  var ctx = newWindowCtx()
  app.signalConnect(evActivate, mainWindow, ctx)
  app.run()

when isMainModule:
  main()
