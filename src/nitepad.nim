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

func onRealize(
  w: DrawingArea,
  ctx: var CanvasCtx
): bool =
  # Event compression will
  # merge motion events in queue
  # and produce non-smooth drawing
  # curves
  w.setEventCompression(false)
  ctx.surface = newSurface(w)

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
    scr.setLineWidth(brWidth)
    let x0 = lastBrush.points[^2].x
    let y0 = lastBrush.points[^2].y
    scr.moveTo(x0, y0)
    scr.lineTo(ev.x, ev.y)
    scr.stroke()
    w.queueDrawArea(x0, y0, ev.x, ev.y, brWidth)

func onDraw(w: DrawingArea, cr: Cairo, ctx: var CanvasCtx): bool =
  cr.setSourceSurface(ctx.surface, 0, 0)
  cr.paint()

func canvasArea(ctx: var CanvasCtx): DrawingArea =
  result = newDrawingArea()
  result.setSizeRequest(800, 800)
  var stylus = newStylus(result)
  stylus.signalConnect(evStylusMotion, onStylusMove, ctx)
  result.signalConnect(evDraw, onDraw, ctx)
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

func canvasContainer(ctx: var CanvasCtx): ScrolledWindow =
  var hBox = newBox(orientation = hBox)
  var vBox = newBox(orientation = vBox)
  var cv = canvasArea(ctx)
  hBox.pack_start(cv, fill = false)
  vBox.pack_start(hBox, fill = false)
  result = newScrolledWindow()
  result.add vBox

func mainWindow(app: App, ctx: var WindowCtx): bool =
  var w = app.newWindow()
  w.setTitle("nitepad")
  w.setDefaultSize(400, 400)
  var cvContainer = canvasContainer(ctx.canvas)
  w.add(cvContainer)
  w.showAll()

proc main() =
  var app = newApp("org.gtk.nitepad")
  var ctx = newWindowCtx()
  app.signalConnect(evActivate, mainWindow, ctx)
  app.run()

when isMainModule:
  main()
