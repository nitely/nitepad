## Nitepad application

import nitepad/gtk

type
  Point = tuple
    x, y: float64
  Brush = object
    width, red, green, blue, alpha: float64
  CanvasCtx = ref object
    dwa: DrawingArea
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
  # A recording surface allows to
  # create a vetorized SVG, instead
  # of an SVG with an embedded PNG.
  # It uses too much CPU, though
  ctx.surface = newRecordingSurface(w)
  var scr = newCairo(ctx.surface)
  scr.setSourceRgb(0, 0, 0)
  scr.paint()

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
  ctx.dwa = newDrawingArea()
  result = ctx.dwa
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

func onNewImage(
  button: ToolButton,
  ctx: var CanvasCtx
): bool =
  const msg =
    "You are about to close the current note and create a new one. " &
    "All unsaved changes will be lost, do you want to proceed?"
  var dg = button.window.newDialog(msg, kind = msgQuestion)
  var response = dg.run()
  if response == dgOk:
    ctx.surface = newRecordingSurface(ctx.width, ctx.height)
    var scr = newCairo(ctx.surface)
    scr.setSourceRgb(0, 0, 0)
    scr.paint()
    ctx.dwa.queueDraw()
  dg.destroy()

func onOpenImage(
  button: ToolButton,
  ctx: var CanvasCtx
): bool =
  var fc = button.window.newFileChooser(
    "Open Image", fcOpen, "_Cancel", dgCancel, "_Open", dgAccept)
  var response = fc.run()
  if response == dgAccept:
    # Reset recording
    ctx.surface = newRecordingSurface(ctx.width, ctx.height)
    discard loadSvg(ctx.surface, fc.filename)
    ctx.dwa.queueDraw()
  fc.destroy()

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
  var openBtn = newToolButton(icnOpen, "Open image")
  result.add openBtn
  openBtn.signalConnect(evClicked, onOpenImage, ctx)
  var newBtn = newToolButton(icnNew, "New image")
  result.add newBtn
  newBtn.signalConnect(evClicked, onNewImage, ctx)

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
