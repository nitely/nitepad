## This just wraps enough of GTK 3 to be useful

when defined(Linux):
  const libGtk = "libgtk-3.so.0"
else:
  {.error: "Unsupported OS".}

{.push dynlib: libGtk.}

type
  GtkApplicationPtr* = ptr object
  GApplicationFlags* = enum
    G_APPLICATION_FLAGS_NONE
  GtkOrientation* = enum
    GTK_ORIENTATION_HORIZONTAL
    GTK_ORIENTATION_VERTICAL
  GCallback* = proc () {.cdecl.}
  GApplicationPtr* = ptr object
  GtkWidgetPtr* = ptr object
  GtkContainerPtr* = ptr object
  GtkWindowPtr* = ptr object
  GtkBoxPtr* = ptr object
  GtkDrawingAreaPtr* = ptr object
  GConnectFlags* = int32
  GClosurePtr* = ptr object
  GClosureNotify* = proc (data: pointer, closure: GClosurePtr) {.cdecl.}
  CairoPtr* = ptr object
  CairoLineCap* = enum
    CAIRO_LINE_CAP_BUTT
    CAIRO_LINE_CAP_ROUND
    CAIRO_LINE_CAP_SQUARE
  CairoLineJoin* = enum
    CAIRO_LINE_JOIN_MITER
    CAIRO_LINE_JOIN_ROUND
    CAIRO_LINE_JOIN_BEVEL
  gint* = cint
  gstring* = cstring  # gchar *
  gboolean* = bool
  guint* = cuint
  gdouble* = cdouble
  gint8* = int8
  guint32* = uint32
  gint16* = int16

type
  GdkEventType* = enum
    GDK_NOTHING = -1, GDK_DELETE = 0, GDK_DESTROY = 1, GDK_EXPOSE = 2,
    GDK_MOTION_NOTIFY = 3, GDK_BUTTON_PRESS = 4, GDK_2BUTTON_PRESS = 5,
    GDK_3BUTTON_PRESS = 6, GDK_BUTTON_RELEASE = 7, GDK_KEY_PRESS = 8,
    GDK_KEY_RELEASE = 9, GDK_ENTER_NOTIFY = 10, GDK_LEAVE_NOTIFY = 11,
    GDK_FOCUS_CHANGE = 12, GDK_CONFIGURE = 13, GDK_MAP = 14, GDK_UNMAP = 15,
    GDK_PROPERTY_NOTIFY = 16, GDK_SELECTION_CLEAR = 17, GDK_SELECTION_REQUEST = 18,
    GDK_SELECTION_NOTIFY = 19, GDK_PROXIMITY_IN = 20, GDK_PROXIMITY_OUT = 21,
    GDK_DRAG_ENTER = 22, GDK_DRAG_LEAVE = 23, GDK_DRAG_MOTION = 24, GDK_DRAG_STATUS = 25,
    GDK_DROP_START = 26, GDK_DROP_FINISHED = 27, GDK_CLIENT_EVENT = 28,
    GDK_VISIBILITY_NOTIFY = 29, GDK_SCROLL = 31, GDK_WINDOW_STATE = 32, GDK_SETTING = 33,
    GDK_OWNER_CHANGE = 34, GDK_GRAB_BROKEN = 35, GDK_DAMAGE = 36, GDK_TOUCH_BEGIN = 37,
    GDK_TOUCH_UPDATE = 38, GDK_TOUCH_END = 39, GDK_TOUCH_CANCEL = 40,
    GDK_TOUCHPAD_SWIPE = 41, GDK_TOUCHPAD_PINCH = 42, GDK_PAD_BUTTON_PRESS = 43,
    GDK_PAD_BUTTON_RELEASE = 44, GDK_PAD_RING = 45, GDK_PAD_STRIP = 46,
    GDK_PAD_GROUP_MODE = 47, GDK_EVENT_LAST ##  helper variable for decls
  GdkDevice* = object
  GdkEventMotion* {.bycopy.} = object
    `type`*: GdkEventType
    window*: GtkWindowPtr
    send_event*: gint8
    time*: guint32
    x*: gdouble
    y*: gdouble
    axes*: ptr gdouble
    state*: guint
    is_hint*: gint16
    device*: ptr GdkDevice
    x_root*: gdouble
    y_root*: gdouble
  GdkEventMotionPtr* = ptr GdkEventMotion
  GdkEventButton* {.bycopy.} = object
    `type`*: GdkEventType
    window*: GtkWindowPtr
    send_event*: gint8
    time*: guint32
    x*: gdouble
    y*: gdouble
    axes*: ptr gdouble
    state*: guint
    button*: guint
    device*: ptr GdkDevice
    x_root*: gdouble
    y_root*: gdouble
  GdkEventButtonPtr* = ptr GdkEventButton

const
  GDK_BUTTON_PRIMARY* = 1
  GDK_POINTER_MOTION_MASK* = 1 shl 2
  GDK_BUTTON_PRESS_MASK* = 1 shl 8
  GDK_BUTTON_RELEASE_MASK* = 1 shl 9
  GDK_BUTTON1_MOTION_MASK* = 1 shl 5

proc gtk_application_new*(
  application_id: gstring,
  flags: GApplicationFlags
): GtkApplicationPtr {.importc.}

proc g_signal_connect_data*(
  instance: pointer,
  detailed_signal: gstring,
  c_handler: GCallback,
  data: pointer,
  destroy_data: GClosureNotify,
  connect_flags: GConnectFlags
): culong {.importc.}

template g_signal_connect*(
  instance, detailedSignal, cHandler, data: untyped
): untyped =
  g_signal_connect_data(
    instance, detailedSignal, cHandler, data, nil, GConnectFlags(0)
  )

proc g_application_run*(
  application: GApplicationPtr,
  argc: cint,
  argv: ptr cstring
): cint {.importc.}

proc gtk_application_window_new*(
  application: GtkApplicationPtr
): GtkWidgetPtr {.importc.}

proc gtk_window_set_title*(
  window: GtkWindowPtr, title: gstring
) {.importc.}

proc gtk_window_set_default_size*(
  window: GtkWindowPtr, width: gint, height: gint
) {.importc.}

proc gtk_widget_show_all*(widget: GtkWidgetPtr) {.importc.}

proc gtk_box_new*(
  orientation: GtkOrientation,
  spacing: gint
): GtkWidgetPtr {.importc.}

proc gtk_box_pack_start*(
  box: GtkBoxPtr,
  child: GtkWidgetPtr,
  expand: gboolean,
  fill: gboolean,
  padding: guint
) {.importc.}

proc gtk_container_add*(
  container: GtkContainerPtr,
  widget: GtkWidgetPtr
) {.importc.}

proc gtk_widget_set_events*(
  widget: GtkWidgetPtr,
  events: gint
) {.importc.}

proc gtk_widget_get_events*(widget: GtkWidgetPtr): gint {.importc.}

proc gtk_widget_queue_draw*(widget: GtkWidgetPtr) {.importc.}

proc gtk_drawing_area_new*(): GtkWidgetPtr {.importc.}

proc cairo_set_source_rgba*(
  cr: CairoPtr,
  red: cdouble,
  green: cdouble,
  blue: cdouble,
  alpha: cdouble
) {.importc.}

proc cairo_paint*(cr: CairoPtr) {.importc.}
proc cairo_set_line_width*(cr: CairoPtr, width: cdouble) {.importc.}
proc cairo_set_line_cap*(cr: CairoPtr, line_cap: CairoLineCap) {.importc.}
proc cairo_set_line_join*(cr: CairoPtr, line_join: CairoLineJoin) {.importc.}
proc cairo_new_path*(cr: CairoPtr) {.importc.}
proc cairo_line_to*(cr: CairoPtr, x: cdouble, y: cdouble) {.importc.}
proc cairo_stroke*(cr: CairoPtr) {.importc.}

{.pop.}
