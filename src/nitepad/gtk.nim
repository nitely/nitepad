## High-level bindings for GTK 3

# XXX auto destroy all "new" objects

import ./gtkbindings

type
  App* = GtkApplicationPtr
  DrawingArea* = GtkDrawingAreaPtr
  Box* = GtkBoxPtr
  ToolBar* = GtkToolbarPtr
  ToolButton* = GtkToolButtonPtr
  ToolItem* = ToolButton  # | ToolSeparator
  FileChooserDialog* = GtkFileChooserDialogPtr
  FileChooser* = FileChooserDialog  # | FileChooserWidget
  Dialog* = GtkDialogPtr
  Window* = GtkWindowPtr
  ScrolledWindow* = GtkScrolledWindowPtr
  SomeDialog* = Dialog | FileChooserDialog
  Container* =
    Window | Box | ScrolledWindow | 
    ToolBar | ToolItem | SomeDialog
  Widget* = Container | DrawingArea
  Event* = enum
    evActivate = "activate"
    evDraw = "draw"
    evMotion = "motion-notify-event"
    evButtonPress = "button-press-event"
    evButtonRelease = "button-release-event"
    evStylusMotion = "motion"
    evConfig = "configure-event"
    evRealize = "realize"
    evClicked = "clicked"
  Cairo* = CairoPtr
  Surface* = CairoSurfacePtr  # Canvas buffer
  SvgSurface* = CairoSurfacePtr
  Stylus* = GtkGestureStylusPtr
  EventMotion* = GdkEventMotionPtr
  EventButton* = GdkEventButtonPtr
  EventConfig* = GdkEventConfigurePtr
  EventMask* = distinct uint
  MouseButton* = distinct uint
  AxisUse* = GdkAxisUse
  IconSize* = GtkIconSize
  IconName* = enum
    icnSave = "document-save"
  FileChooserAction* = GtkFileChooserAction
  DialogResponseType* = GtkResponseType

const
  oriVertical* = GTK_ORIENTATION_VERTICAL
  oriHorizontal* = GTK_ORIENTATION_HORIZONTAL
  lineCapRound* = CAIRO_LINE_CAP_ROUND
  lineJoinRound* = CAIRO_LINE_JOIN_ROUND
  buttonPrimary* = GDK_BUTTON_PRIMARY.MouseButton
  axisPressure* = GDK_AXIS_PRESSURE
  policyAutomatic* = GTK_POLICY_AUTOMATIC
  iconSmall* = GTK_ICON_SIZE_SMALL_TOOLBAR
  iconMedium* = GTK_ICON_SIZE_LARGE_TOOLBAR
  iconLarge* = GTK_ICON_SIZE_DND
  fcSave* = GTK_FILE_CHOOSER_ACTION_SAVE
  dgAccept* = GTK_RESPONSE_ACCEPT
  dgCancel* = GTK_RESPONSE_CANCEL

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

func run*(dg: SomeDialog): DialogResponseType {.inline.} =
  gtk_dialog_run(cast[GtkDialogPtr](dg)).DialogResponseType

# remove this crap?
func isWindow(w: GtkWidgetPtr): bool {.inline.} =
  g_type_check_instance_is_a(cast[GTypeInstancePtr](w), gtk_window_get_type())

func window*(w: Widget): Window {.inline.} =
  var widget = gtk_widget_get_toplevel(cast[GtkWidgetPtr](w))
  doAssert widget != nil
  doAssert widget.isWindow()
  result = cast[Window](widget)

func setSizeRequest*(w: Widget, width, height: int32) {.inline.} =
  gtk_widget_set_size_request(cast[GtkWidgetPtr](w), width, height)

func setEvents*(w: Widget, events: EventMask) {.inline.} =
  gtk_widget_set_events(cast[GtkWidgetPtr](w), events.int32)

func getEvents*(w: Widget): int32 {.inline.} =
  gtk_widget_get_events(cast[GtkWidgetPtr](w))

func queueDraw*(w: Widget) {.inline.} =
  gtk_widget_queue_draw(cast[GtkWidgetPtr](w))

func queueDrawArea(w: Widget, x, y, width, height: int32) {.inline.} =
  gtk_widget_queue_draw_area(cast[GtkWidgetPtr](w), x, y, width, height)

func queueDrawArea*(
  w: Widget,
  x1, y1, x2, y2: float64,
  offset: float64
) {.inline.} =
  let
    ox1 = min(x1, x2)-offset
    oy1 = min(y1, y2)-offset
    ox2 = max(x1, x2)+offset
    oy2 = max(y1, y2)+offset
    x = max(0, ox1.toInt-1)
    y = max(0, oy1.toInt-1)
    wh = max(0, ox2.toInt+1-x)
    ht = max(0, oy2.toInt+1-y)
    wWh = gtk_widget_get_allocated_width(cast[GtkWidgetPtr](w))
    wHt = gtk_widget_get_allocated_height(cast[GtkWidgetPtr](w))
    width = min(wWh, wh)
    height = min(wHt, ht)
  w.queueDrawArea(x.int32, y.int32, width.int32, height.int32)

func newScrolledWindow*(): ScrolledWindow {.inline.} =
  gtk_scrolled_window_new(nil, nil)

func setMinContentWidth*(sw: ScrolledWindow, w: int32) {.inline.} =
  gtk_scrolled_window_set_min_content_width(sw, w)

func setPolicy*(sw: ScrolledWindow, h, v = policyAutomatic) {.inline.} =
  gtk_scrolled_window_set_policy(sw, h, v)

func newStylus*(parent: Widget): Stylus {.inline.} =
  gtk_gesture_stylus_new(cast[GtkWidgetPtr](parent))

func getAxis*(s: Stylus, axis: AxisUse, value: var float64): bool {.inline.} =
  gtk_gesture_stylus_get_axis(s, axis, addr value)

func newToolBar*(): ToolBar {.inline.} =
  gtk_toolbar_new()

func add*(tb: ToolBar, item: ToolItem) =
  gtk_toolbar_insert(tb, cast[GtkToolItemPtr](item), -1)

func setSize*(tb: ToolBar, size: IconSize) =
  gtk_toolbar_set_icon_size(tb, size)

func newToolButton*(icon: IconName, label: string): ToolButton {.inline.} =
  gtk_tool_button_new(
    gtk_image_new_from_icon_name($icon, iconLarge), label)

func newFileChooser*(
  parent: Window,
  title: string,
  action: FileChooserAction,
  button1text: string,
  button1type: DialogResponseType,
  button2text: string,
  button2type: DialogResponseType
): FileChooserDialog {.inline.} =
  gtk_file_chooser_dialog_new(
    title, parent, action, button1text,
    button1type, button2text, button2type, nil)

func destroy*(fc: FileChooserDialog) {.inline.} =
  gtk_widget_destroy(cast[GtkWidgetPtr](fc))

func setDoOverwriteConfirmation*(
  fc: FileChooser,
  overwrite: bool
) {.inline.} =
  gtk_file_chooser_set_do_overwrite_confirmation(
    cast[GtkFileChooserPtr](fc), overwrite)

func filename*(fc: FileChooser): string {.inline.} =
  $gtk_file_chooser_get_filename(cast[GtkFileChooserPtr](fc))

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

func newBox*(
  orientation = oriHorizontal,
  spacing = 0'i32
): Box {.inline.} =
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

func setEventCompression*(w: DrawingArea, compress: bool) {.inline.} =
  gdk_window_set_event_compression(
    gtk_widget_get_window(cast[GtkWidgetPtr](w)), compress)

func width*(w: DrawingArea): int32 {.inline.} =
  gtk_widget_get_allocated_width(cast[GtkWidgetPtr](w))

func height*(w: DrawingArea): int32 {.inline.} =
  gtk_widget_get_allocated_height(cast[GtkWidgetPtr](w))

func setSourceRgba*(
  cr: Cairo,
  red, green, blue, alpha: float64
) {.inline.} =
  cairo_set_source_rgba(cr, red, green, blue, alpha)

func setSourceRgb*(
  cr: Cairo,
  red, green, blue: float64
) {.inline.} =
  cairo_set_source_rgb(cr, red, green, blue)

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

func setSourceSurface*(
  cr: Cairo,
  surface: Surface,
  x, y: float64
) {.inline.} =
  cairo_set_source_surface(cr, surface, x, y)

func newSurface*(w: DrawingArea): Surface {.inline.} =
  gdk_window_create_similar_surface(
    gtk_widget_get_window(cast[GtkWidgetPtr](w)),
    CAIRO_CONTENT_COLOR,
    gtk_widget_get_allocated_width(cast[GtkWidgetPtr](w)),
    gtk_widget_get_allocated_height(cast[GtkWidgetPtr](w)))

func newImageSurface*(w: DrawingArea): Surface {.inline.} =
  cairo_image_surface_create(
    CAIRO_FORMAT_ARGB32,
    gtk_widget_get_allocated_width(cast[GtkWidgetPtr](w)),
    gtk_widget_get_allocated_height(cast[GtkWidgetPtr](w)))

func newRecordingSurface*(w: DrawingArea): Surface {.inline.} =
  var rect = CairoRectangle(
    x: 0,
    y: 0,
    width: gtk_widget_get_allocated_width(cast[GtkWidgetPtr](w)).float,
    height: gtk_widget_get_allocated_height(cast[GtkWidgetPtr](w)).float)
  cairo_recording_surface_create(
    CAIRO_CONTENT_COLOR, addr rect)

func newCairo*(surface: Surface): Cairo {.inline.} =
  cairo_create(surface)

func saveAsSvg*(
  surface: Surface,
  fname: string,
  w, h: int32
): bool {.inline.} =
  # XXX destroy
  var svg = cairo_svg_surface_create(
    fname, w.float, h.float)
  if svg == nil:
    return false
  svg.cairo_svg_surface_restrict_to_version(
    CAIRO_SVG_VERSION_1_2)
  var cr = newCairo(svg)
  cr.setSourceSurface(surface, 0, 0)
  cr.paint()
  svg.cairo_surface_flush()
  svg.cairo_surface_finish()
  return true
