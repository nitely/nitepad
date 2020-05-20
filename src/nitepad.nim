## Nitepad application

import nitepad/gtk

type
  Point = tuple
    x, y: float64
  Brush = object
    width, red, green, blue, alpha: float64
  CanvasCtx = ref object
    surface: Surface
    brush: Brush
    joinPoint: bool
    lastPoint: Point
    lastPressure: float64
    width, height: int32
  WindowCtx = ref object
    canvas: CanvasCtx

func brush(
  width, red, green, blue, alpha: float64
): Brush =
  Brush(
    width: width,
    red: red,
    green: green,
    blue: blue,
    alpha: alpha)

func newCanvasCtx(): CanvasCtx =
  new result
  result = CanvasCtx(
    brush: brush(10, 255, 255, 0, 1),
    joinPoint: false,
    lastPressure: 1,
    width: 800,
    height: 800)

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
  w.setEventCompression false
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
    ctx.joinPoint = false
    ctx.lastPressure = 1
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
  template x0: untyped = ctx.lastPoint.x
  template y0: untyped = ctx.lastPoint.y
  if buttonPressMask in ev.state:
    #debugEcho "move"
    if not ctx.joinPoint:
      ctx.joinPoint = true
      ctx.lastPoint = (x: ev.x, y: ev.y)
      return
    let brWidth = ctx.brush.width * ctx.lastPressure
    var scr = newCairo(ctx.surface)
    scr.setSourceRgba(
      ctx.brush.red,
      ctx.brush.green,
      ctx.brush.blue,
      ctx.brush.alpha)
    scr.setLineCap()
    scr.setLineJoin()
    scr.setLineWidth(brWidth)
    scr.moveTo(x0, y0)
    scr.lineTo(ev.x, ev.y)
    scr.stroke()
    w.queueDrawArea(x0, y0, ev.x, ev.y, brWidth)
    ctx.lastPoint = (x: ev.x, y: ev.y)

func onDraw(w: DrawingArea, cr: Cairo, ctx: var CanvasCtx): bool =
  cr.setSourceSurface(ctx.surface, 0, 0)
  cr.paint()

func canvasArea(ctx: var CanvasCtx): DrawingArea =
  result = newDrawingArea()
  result.setSizeRequest(ctx.width, ctx.height)
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

func canvas(ctx: var CanvasCtx): ScrolledWindow =
  var hBox = newBox(oriHorizontal)
  var vBox = newBox(oriVertical)
  var cv = canvasArea(ctx)
  hBox.pack_start(cv, fill = false)
  vBox.pack_start(hBox, fill = false)
  result = newScrolledWindow()
  result.add vBox

func onSaveAsImage(
  button: ToolButton,
  ctx: var CanvasCtx
): bool =
  var fc = button.window.newFileChooser(
    "Save Image", fcSave, "_Cancel", dgCancel, "_Save", dgAccept)
  fc.setDoOverwriteConfirmation(true)
  var response = fc.run()
  if response == dgAccept:
    discard saveAsSvg(
      ctx.surface, fc.filename, ctx.width, ctx.height)
  fc.destroy()

func toolBar(ctx: var CanvasCtx): ToolBar =
  result = newToolBar()
  result.setSize iconMedium
  var saveBtn = newToolButton(icnSave, "Save as image")
  result.add saveBtn
  saveBtn.signalConnect(evClicked, onSaveAsImage, ctx)

func mainWindow(app: App, ctx: var WindowCtx): bool =
  var w = app.newWindow()
  w.setTitle "nitepad"
  w.setDefaultSize(400, 400)
  var cv = canvas(ctx.canvas)
  var tb = toolBar(ctx.canvas)
  var container = newBox(oriVertical)
  container.pack_start(tb, expand = false, fill = false)
  container.pack_start(cv)
  w.add container
  w.showAll()

proc main() =
  var app = newApp "org.gtk.nitepad"
  var ctx = newWindowCtx()
  app.signalConnect(evActivate, mainWindow, ctx)
  app.run()

when isMainModule:
  main()
