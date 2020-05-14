## Nitepad application

import nitepad/gtk

type
  Coor = tuple
    x, y: float64
  Brush = object
    width: float64
    red, green, blue, alpha: float64
    coors: seq[Coor]
  CanvasCtx = ref object
    brushes: seq[Brush]
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
  result = CanvasCtx()

func newWindowCtx(): WindowCtx =
  new result
  result = WindowCtx(
    canvas: newCanvasCtx())

func drawMouseMove(
  w: DrawingArea,
  ev: EventMotion,
  ctx: var CanvasCtx
): bool =
  if (ev.state and GDK_BUTTON_PRESS_MASK.uint32) > 0:
    #debugEcho "move"
    doAssert ctx.brushes.len > 0
    ctx.brushes[^1].coors.add((x: ev.x, y: ev.y))
    w.queueDraw()

func drawMousePress(
  w: DrawingArea,
  ev: EventButton,
  ctx: var CanvasCtx
): bool =
  if ev.button == GDK_BUTTON_PRIMARY:
    debugEcho "press"
    var br = brush(12, 255, 255, 0, 1)
    br.coors.add((x: ev.x, y: ev.y))
    ctx.brushes.add(br)
    w.queueDraw()

func drawMouseRelease(
  w: DrawingArea,
  ev: EventButton,
  ctx: var CanvasCtx
): bool =
  w.queueDraw()

func draw(w: DrawingArea, cr: Cairo, ctx: var CanvasCtx): bool =
  debugEcho "draw"
  cr.setSourceRgba(0, 0, 0, 1)
  cr.paint()
  for br in ctx.brushes:
    #debugEcho br
    cr.setSourceRgba(br.red, br.green, br.blue, br.alpha)
    cr.setLineWidth(br.width)
    cr.setLineCap()
    cr.setLineJoin()
    cr.newPath()
    for c in br.coors:
      cr.lineTo(c.x, c.y)
    cr.stroke()

func canvas(ctx: var CanvasCtx): DrawingArea =
  result = newDrawingArea()
  result.signalConnect(evDraw, draw, ctx)
  result.signalConnect(evMotion, drawMouseMove, ctx)
  result.signalConnect(evButtonPress, drawMousePress, ctx)
  result.signalConnect(evButtonRelease, drawMouseRelease, ctx)
  result.setEvents(
    result.getEvents() or
    GDK_POINTER_MOTION_MASK or
    GDK_BUTTON_PRESS_MASK or
    GDK_BUTTON_RELEASE_MASK)

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
