## Nitepad application

import nitepad/gtk

type
  Point = tuple
    width, x, y: float64
  Brush = object
    red, green, blue, alpha: float64
    points: seq[Point]
  CanvasCtx = ref object
    brushes: seq[Brush]
    lastWidth: float64
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
  result = CanvasCtx()

func newWindowCtx(): WindowCtx =
  new result
  result = WindowCtx(
    canvas: newCanvasCtx())

# XXX use lastWidth for smoother
#     pressure transitions
func drawStylusMotion(
  s: Stylus,
  arg1, arg2: float64,
  ctx: var CanvasCtx
): bool =
  var pressure: float64
  if getAxis(s, axisPressure, pressure):
    doAssert ctx.brushes.len > 0
    ctx.brushes[^1].points[^1].width *= pressure

func drawMouseMove(
  w: DrawingArea,
  ev: EventMotion,
  ctx: var CanvasCtx
): bool =
  if buttonPressMask in ev.state:
    #debugEcho "move"
    doAssert ctx.brushes.len > 0
    ctx.brushes[^1].points.add((width: 10.0, x: ev.x, y: ev.y))
    w.queueDraw()

func drawMousePress(
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

func drawMouseRelease(
  w: DrawingArea,
  ev: EventButton,
  ctx: var CanvasCtx
): bool =
  w.queueDraw()

# XXX use surface double buffering
#     instead of painting/stroke a lot
func draw(w: DrawingArea, cr: Cairo, ctx: var CanvasCtx): bool =
  template prev: untyped = br.points[i-1]
  template curr: untyped = br.points[i]
  #debugEcho "draw"
  cr.setSourceRgba(0, 0, 0, 1)
  cr.paint()
  for br in ctx.brushes:
    #debugEcho br
    cr.setSourceRgba(br.red, br.green, br.blue, br.alpha)
    cr.setLineCap()
    cr.setLineJoin()
    cr.newPath()
    for i in 1 .. br.points.len-1:
      cr.setLineWidth(curr.width)
      cr.moveTo(prev.x, prev.y)
      cr.lineTo(curr.x, curr.y)
      cr.stroke()

func canvas(ctx: var CanvasCtx): DrawingArea =
  result = newDrawingArea()
  var stylus = newStylus(result)
  stylus.signalConnect(evStylusMotion, drawStylusMotion, ctx)
  result.signalConnect(evDraw, draw, ctx)
  result.signalConnect(evMotion, drawMouseMove, ctx)
  result.signalConnect(evButtonPress, drawMousePress, ctx)
  result.signalConnect(evButtonRelease, drawMouseRelease, ctx)
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
