## High-level bindings for GTK 3

import ./gtkbindings

# XXX remove, make type safe
export
  GDK_BUTTON_PRIMARY,
  GDK_POINTER_MOTION_MASK,
  GDK_BUTTON_PRESS_MASK,
  GDK_BUTTON_RELEASE_MASK,
  GDK_BUTTON1_MOTION_MASK

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
  Cairo* = CairoPtr
  EventMotion* = GdkEventMotionPtr
  EventButton* = GdkEventButtonPtr

const
  hBox* = GTK_ORIENTATION_HORIZONTAL
  lineCapRound* = CAIRO_LINE_CAP_ROUND
  lineJoinRound* = CAIRO_LINE_JOIN_ROUND

func setEvents*(w: Widget, events: int32) =
  gtk_widget_set_events(cast[GtkWidgetPtr](w), events)

func getEvents*(w: Widget): int32 =
  gtk_widget_get_events(cast[GtkWidgetPtr](w))

func queueDraw*(w: Widget) =
  gtk_widget_queue_draw(cast[GtkWidgetPtr](w))

func newApp*(name: string): App =
  gtk_application_new(name, G_APPLICATION_FLAGS_NONE)

template signalConnect*[T, U, V](
  inst: T,
  ev: Event,
  callback: proc (inst: T, data: U, data2: var V): bool,
  data: var V
): untyped =
  bind g_signal_connect
  block:
    proc wrapper(inst2: pointer, data2: pointer, data3: pointer): bool =
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
    proc wrapper(inst2: pointer, data2: pointer): bool =
      callback(cast[T](inst2), cast[var U](data2))
    discard g_signal_connect(
      cast[pointer](inst), $ev, cast[GCallback](wrapper), addr data)

func run*(app: App) =
  discard g_application_run(
    cast[GApplicationPtr](app), 0, nil)
  # g_object_unref()

func newWindow*(app: App): Window =
  cast[Window](gtk_application_window_new(app))

func setTitle*(w: Window, title: string) =
  gtk_window_set_title(w, title)

func setDefaultSize*(w: Window, width, height: int32) =
  gtk_window_set_default_size(w, width, height)

func showAll*(w: Window) =
  gtk_widget_show_all(cast[GtkWidgetPtr](w))

func newBox*(orientation = hBox, spacing = 0'i32): Box =
  cast[Box](gtk_box_new(orientation, spacing))

func pack_start*(
  box: Box,
  child: Widget,
  expand = true,
  fill = true,
  padding = 0'u32
) =
  gtk_box_pack_start(
    box, cast[GtkWidgetPtr](child), expand, fill, padding)

func add*(c: Container, w: Widget) =
  gtk_container_add(
    cast[GtkContainerPtr](c),
    cast[GtkWidgetPtr](w))

func newDrawingArea*(): DrawingArea =
  cast[DrawingArea](gtk_drawing_area_new())

func setSourceRgba*(
  cr: Cairo,
  red, green, blue, alpha: float64
) =
  cairo_set_source_rgba(cr, red, green, blue, alpha)

func paint*(cr: Cairo) =
  cairo_paint(cr)

func setLineWidth*(cr: Cairo, width: float64) =
  cairo_set_line_width(cr, width)

func setLineCap*(cr: Cairo, lineCap = lineCapRound) =
  cairo_set_line_cap(cr, lineCap)

func setLineJoin*(cr: Cairo, lineJoin = lineJoinRound) =
  cairo_set_line_join(cr, lineJoin)

func newPath*(cr: Cairo) =
  cairo_new_path(cr)

func lineTo*(cr: Cairo, x, y: float64) =
  cairo_line_to(cr, x, y)

func stroke*(cr: Cairo) =
  cairo_stroke(cr)
