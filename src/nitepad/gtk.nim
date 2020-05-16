## High-level bindings for GTK 3

# XXX auto destroy all "new" objects

import ./gtkbindings

type
  App* = GtkApplicationPtr
  DrawingArea* = GtkDrawingAreaPtr
  Box* = GtkBoxPtr
  Window* = GtkWindowPtr
  Container* = Window | Box
  Widget* = Container | DrawingArea
  Event* = enum
    evActivate = "activate"
    evDraw = "draw"
    evMotion = "motion-notify-event"
    evButtonPress = "button-press-event"
    evButtonRelease = "button-release-event"
    evStylusMotion = "motion"
  Cairo* = CairoPtr
  Stylus* = GtkGestureStylusPtr
  EventMotion* = GdkEventMotionPtr
  EventButton* = GdkEventButtonPtr
  EventMask* = distinct uint
  MouseButton* = distinct uint
  AxisUse* = GdkAxisUse

const
  hBox* = GTK_ORIENTATION_HORIZONTAL
  lineCapRound* = CAIRO_LINE_CAP_ROUND
  lineJoinRound* = CAIRO_LINE_JOIN_ROUND
  buttonPrimary* = GDK_BUTTON_PRIMARY.MouseButton
  axisPressure* = GDK_AXIS_PRESSURE

const
  pointerMotionMask* = GDK_POINTER_MOTION_MASK.EventMask
  buttonPressMask* = GDK_BUTTON_PRESS_MASK.EventMask
  buttonReleaseMask* = GDK_BUTTON_RELEASE_MASK.EventMask
  button1MotionMask* = GDK_BUTTON1_MOTION_MASK.EventMask
  touchMask* = GDK_TOUCH_MASK.EventMask

func `==`*(a: uint, b: MouseButton): bool {.inline.} =
  a == b.uint
func `==`*(a: MouseButton, b: uint): bool {.inline.} =
  a.uint == b

func contains*(state: uint, mask: EventMask): bool {.inline.} =
  (state and mask.uint) > 0
func `+`*(a: int32, b: EventMask): EventMask {.inline.} =
  (a.uint or b.uint).EventMask
func `+`*(a: EventMask, b: int32): EventMask {.inline.} =
  (a.uint or b.uint).EventMask
func `+`*(a, b: EventMask): EventMask {.inline.} =
  (a.uint or b.uint).EventMask

func setEvents*(w: Widget, events: EventMask) {.inline.} =
  gtk_widget_set_events(cast[GtkWidgetPtr](w), events.int32)

func getEvents*(w: Widget): int32 {.inline.} =
  gtk_widget_get_events(cast[GtkWidgetPtr](w))

func queueDraw*(w: Widget) {.inline.} =
  gtk_widget_queue_draw(cast[GtkWidgetPtr](w))

func newStylus*(parent: Widget): Stylus {.inline.} =
  gtk_gesture_stylus_new(cast[GtkWidgetPtr](parent))

func getAxis*(s: Stylus, axis: AxisUse, value: var float64): bool {.inline.} =
  gtk_gesture_stylus_get_axis(s, axis, addr value)

func newApp*(name: string): App {.inline.} =
  gtk_application_new(name, G_APPLICATION_FLAGS_NONE)

template signalConnect*[T, U, V](
  inst: T,
  ev: Event,
  callback: proc (inst: T, data: U, data2: var V): bool,
  data: var V
): untyped =
  bind g_signal_connect
  block:
    proc wrapper(inst2, data2, data3: pointer): bool {.inline.} =
      callback(cast[T](inst2), cast[U](data2), cast[var V](data3))
    discard g_signal_connect(
      cast[pointer](inst), $ev, cast[GCallback](wrapper), addr data)

template signalConnect*[T, U](
  inst: T,
  ev: Event,
  callback: proc (inst: T, data: var U): bool,
  data: var U
): untyped =
  bind g_signal_connect
  block:
    proc wrapper(inst2, data2: pointer): bool {.inline.} =
      callback(cast[T](inst2), cast[var U](data2))
    discard g_signal_connect(
      cast[pointer](inst), $ev, cast[GCallback](wrapper), addr data)

# Gestures
template signalConnect*[T, U, V](
  inst: T,
  ev: Event,
  callback: proc (inst: T, arg1, arg2: U, data2: var V): bool,
  data: var V
): untyped =
  bind g_signal_connect
  block:
    proc wrapper(inst2: pointer, arg1, arg2: U, data3: pointer): bool {.inline.} =
      callback(cast[T](inst2), arg1, arg2, cast[var V](data3))
    discard g_signal_connect(
      cast[pointer](inst), $ev, cast[GCallback](wrapper), addr data)

func run*(app: App) {.inline.} =
  discard g_application_run(
    cast[GApplicationPtr](app), 0, nil)
  # g_object_unref()

func newWindow*(app: App): Window {.inline.} =
  cast[Window](gtk_application_window_new(app))

func setTitle*(w: Window, title: string) {.inline.} =
  gtk_window_set_title(w, title)

func setDefaultSize*(w: Window, width, height: int32) {.inline.} =
  gtk_window_set_default_size(w, width, height)

func showAll*(w: Window) {.inline.} =
  gtk_widget_show_all(cast[GtkWidgetPtr](w))

func newBox*(orientation = hBox, spacing = 0'i32): Box {.inline.} =
  cast[Box](gtk_box_new(orientation, spacing))

func pack_start*(
  box: Box,
  child: Widget,
  expand = true,
  fill = true,
  padding = 0'u32
) {.inline.} =
  gtk_box_pack_start(
    box, cast[GtkWidgetPtr](child), expand, fill, padding)

func add*(c: Container, w: Widget) {.inline.} =
  gtk_container_add(
    cast[GtkContainerPtr](c),
    cast[GtkWidgetPtr](w))

func newDrawingArea*(): DrawingArea {.inline.} =
  cast[DrawingArea](gtk_drawing_area_new())

func setSourceRgba*(
  cr: Cairo,
  red, green, blue, alpha: float64
) {.inline.} =
  cairo_set_source_rgba(cr, red, green, blue, alpha)

func paint*(cr: Cairo) {.inline.} =
  cairo_paint(cr)

func setLineWidth*(cr: Cairo, width: float64) {.inline.} =
  cairo_set_line_width(cr, width)

func setLineCap*(cr: Cairo, lineCap = lineCapRound) {.inline.} =
  cairo_set_line_cap(cr, lineCap)

func setLineJoin*(cr: Cairo, lineJoin = lineJoinRound) {.inline.} =
  cairo_set_line_join(cr, lineJoin)

func newPath*(cr: Cairo) {.inline.} =
  cairo_new_path(cr)

func lineTo*(cr: Cairo, x, y: float64) {.inline.} =
  cairo_line_to(cr, x, y)

func moveTo*(cr: Cairo, x, y: float64) {.inline.} =
  cairo_move_to(cr, x, y)

func curveTo*(cr: Cairo, x1, y1, x2, y2, x3, y3: float64) {.inline.} =
  cairo_curve_to(cr, x1, y1, x2, y2, x3, y3)

func stroke*(cr: Cairo) {.inline.} =
  cairo_stroke(cr)
