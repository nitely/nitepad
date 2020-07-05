## This just wraps enough of GTK 3 to be useful

when defined(Linux):
  const libGtk = "libgtk-3.so.0"
  const libRsvg = "librsvg-2.so.2"
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
  GdkWindowPtr* = ptr object
  GtkBoxPtr* = ptr object
  GtkDrawingAreaPtr* = ptr object
  GConnectFlags* = int32
  GClosurePtr* = ptr object
  GClosureNotify* = proc (data: pointer, closure: GClosurePtr) {.cdecl.}
  CairoPtr* = ptr object
  CairoSurfacePtr* = ptr object
  GtkGestureStylusPtr* = ptr object
  GtkScrolledWindowPtr* = ptr object
  GtkAdjustmentPtr* = ptr object
  GtkToolbarPtr* = ptr object
  GtkToolItemPtr* = ptr object
  GtkToolButtonPtr* = ptr object
  GtkFileChooserDialogPtr* = ptr object
  GtkFileChooserPtr* = ptr object
  GtkDialogPtr* = ptr object
  GtkMessageDialogPtr* = ptr object
  CairoLineCap* = enum
    CAIRO_LINE_CAP_BUTT
    CAIRO_LINE_CAP_ROUND
    CAIRO_LINE_CAP_SQUARE
  CairoLineJoin* = enum
    CAIRO_LINE_JOIN_MITER
    CAIRO_LINE_JOIN_ROUND
    CAIRO_LINE_JOIN_BEVEL
  gint* = cint  # int32
  gstring* = cstring  # gchar *
  gboolean* = bool
  guint* = cuint  # uint32
  gdouble* = cdouble  # float64
  gint8* = int8
  guint32* = uint32
  gint16* = int16
  gulong* = culong
  GType* = gulong
  GErrorPtr* = ptr object
  GErrorPtrPtr* = GErrorPtr
  RsvgHandlePtr* = ptr object

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
  GdkEventConfigurePtr* = ptr object
  GdkAxisUse* = enum
    GDK_AXIS_IGNORE
    GDK_AXIS_X
    GDK_AXIS_Y
    GDK_AXIS_PRESSURE
  CairoContent* = enum
    CAIRO_CONTENT_COLOR = 0x1000,
    CAIRO_CONTENT_ALPHA = 0x2000,
    CAIRO_CONTENT_COLOR_ALPHA = 0x3000
  GtkPolicyType* = enum
    GTK_POLICY_ALWAYS, GTK_POLICY_AUTOMATIC, GTK_POLICY_NEVER, GTK_POLICY_EXTERNAL
  GtkIconSize* = enum
    GTK_ICON_SIZE_INVALID, GTK_ICON_SIZE_MENU, GTK_ICON_SIZE_SMALL_TOOLBAR,
    GTK_ICON_SIZE_LARGE_TOOLBAR, GTK_ICON_SIZE_BUTTON, GTK_ICON_SIZE_DND,
    GTK_ICON_SIZE_DIALOG
  GtkFileChooserAction* = enum
    GTK_FILE_CHOOSER_ACTION_OPEN, GTK_FILE_CHOOSER_ACTION_SAVE,
    GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER, GTK_FILE_CHOOSER_ACTION_CREATE_FOLDER
  GtkResponseType* = enum
    GTK_RESPONSE_HELP = -11, GTK_RESPONSE_APPLY = -10, GTK_RESPONSE_NO = -9,
    GTK_RESPONSE_YES = -8, GTK_RESPONSE_CLOSE = -7, GTK_RESPONSE_CANCEL = -6,
    GTK_RESPONSE_OK = -5, GTK_RESPONSE_DELETE_EVENT = -4, GTK_RESPONSE_ACCEPT = -3,
    GTK_RESPONSE_REJECT = -2, GTK_RESPONSE_NONE = -1
  GTypeInstancePtr* = ptr object
  CairoSvgVersion* = enum
    CAIRO_SVG_VERSION_1_1
    CAIRO_SVG_VERSION_1_2
  CairoSurfaceType* = enum
    CAIRO_SURFACE_TYPE_IMAGE,
    CAIRO_SURFACE_TYPE_PDF,
    CAIRO_SURFACE_TYPE_PS,
    CAIRO_SURFACE_TYPE_XLIB,
    CAIRO_SURFACE_TYPE_XCB,
    CAIRO_SURFACE_TYPE_GLITZ,
    CAIRO_SURFACE_TYPE_QUARTZ,
    CAIRO_SURFACE_TYPE_WIN32,
    CAIRO_SURFACE_TYPE_BEOS,
    CAIRO_SURFACE_TYPE_DIRECTFB,
    CAIRO_SURFACE_TYPE_SVG,
    CAIRO_SURFACE_TYPE_OS2,
    CAIRO_SURFACE_TYPE_WIN32_PRINTING,
    CAIRO_SURFACE_TYPE_QUARTZ_IMAGE,
    CAIRO_SURFACE_TYPE_SCRIPT,
    CAIRO_SURFACE_TYPE_QT,
    CAIRO_SURFACE_TYPE_RECORDING,
    CAIRO_SURFACE_TYPE_VG,
    CAIRO_SURFACE_TYPE_GL,
    CAIRO_SURFACE_TYPE_DRM,
    CAIRO_SURFACE_TYPE_TEE,
    CAIRO_SURFACE_TYPE_XML,
    CAIRO_SURFACE_TYPE_SKIA,
    CAIRO_SURFACE_TYPE_SUBSURFACE
  CairoFormat* = enum
    CAIRO_FORMAT_INVALID = -1,
    CAIRO_FORMAT_ARGB32 = 0,
    CAIRO_FORMAT_RGB24 = 1,
    CAIRO_FORMAT_A8 = 2,
    CAIRO_FORMAT_A1 = 3,
    CAIRO_FORMAT_RGB16_565 = 4
  CairoRectangle* {.bycopy.} = object
    x*, y*, width*, height*: cdouble
  CairoRectanglePtr* = ptr CairoRectangle
  GtkDialogFlags* = enum
    GTK_DIALOG_MODAL = 1 shl 0, GTK_DIALOG_DESTROY_WITH_PARENT = 1 shl 1,
    GTK_DIALOG_USE_HEADER_BAR = 1 shl 2
  GtkButtonsType* = enum
    GTK_BUTTONS_NONE, GTK_BUTTONS_OK, GTK_BUTTONS_CLOSE, GTK_BUTTONS_CANCEL,
    GTK_BUTTONS_YES_NO, GTK_BUTTONS_OK_CANCEL
  GtkMessageType* = enum
    GTK_MESSAGE_INFO, GTK_MESSAGE_WARNING, GTK_MESSAGE_QUESTION, GTK_MESSAGE_ERROR,
    GTK_MESSAGE_OTHER

const
  GDK_BUTTON_PRIMARY* = 1
  GDK_POINTER_MOTION_MASK* = 1 shl 2
  GDK_BUTTON_PRESS_MASK* = 1 shl 8
  GDK_BUTTON_RELEASE_MASK* = 1 shl 9
  GDK_BUTTON1_MOTION_MASK* = 1 shl 5
  GDK_TOUCH_MASK* = 1 shl 22

proc g_type_check_instance_is_a*(
  instance: GTypeInstancePtr,
  iface_type: GType
): gboolean {.importc.}

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

proc gtk_window_get_type*(): Gtype {.importc.}

proc gtk_window_set_title*(
  window: GtkWindowPtr, title: gstring
) {.importc.}

proc gtk_window_set_default_size*(
  window: GtkWindowPtr, width: gint, height: gint
) {.importc.}

proc gtk_widget_destroy*(widget: GtkWidgetPtr) {.importc.}

proc gtk_widget_set_size_request*(
  widget: GtkWidgetPtr,
  width: gint,
  height: gint
) {.importc.}

proc gtk_widget_show_all*(widget: GtkWidgetPtr) {.importc.}

proc gtk_widget_get_window*(widget: GtkWidgetPtr): GdkWindowPtr {.importc.}

proc gtk_widget_get_toplevel*(widget: GtkWidgetPtr): GtkWidgetPtr {.importc.}

proc gtk_widget_get_allocated_width*(widget: GtkWidgetPtr): cint {.importc.}

proc gtk_widget_get_allocated_height*(widget: GtkWidgetPtr): cint {.importc.}

proc gtk_widget_set_events*(
  widget: GtkWidgetPtr,
  events: gint
) {.importc.}

proc gtk_widget_get_events*(widget: GtkWidgetPtr): gint {.importc.}

proc gtk_widget_queue_draw*(widget: GtkWidgetPtr) {.importc.}

proc gtk_widget_queue_draw_area*(
  widget: GtkWidgetPtr,
  x: gint,
  y: gint,
  width: gint,
  height: gint
) {.importc.}

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

proc gtk_scrolled_window_new*(
  hadjustment: GtkAdjustmentPtr,
  vadjustment: GtkAdjustmentPtr
): GtkScrolledWindowPtr {.importc.}

proc gtk_scrolled_window_set_min_content_width*(
  scrolled_window: GtkScrolledWindowPtr,
  width: gint
) {.importc.}

proc gtk_scrolled_window_set_policy*(
  scrolled_window: GtkScrolledWindowPtr,
  hscrollbar_policy: GtkPolicyType,
  vscrollbar_policy: GtkPolicyType
) {.importc.}

proc gtk_drawing_area_new*(): GtkWidgetPtr {.importc.}

proc gtk_gesture_stylus_new*(
  widget: GtkWidgetPtr
): GtkGestureStylusPtr {.importc.}
proc gtk_gesture_stylus_get_axis*(
  gesture: GtkGestureStylusPtr,
  axis: GdkAxisUse,
  value: ptr gdouble
): gboolean {.importc.}

proc gtk_toolbar_new*(): GtkToolbarPtr {.importc.}
proc gtk_toolbar_insert*(
  toolbar: GtkToolbarPtr,
  item: GtkToolItemPtr,
  pos: gint
) {.importc.}
proc gtk_toolbar_set_icon_size*(
  toolbar: GtkToolbarPtr,
  icon_size: GtkIconSize
) {.importc.}

proc gtk_tool_button_new*(
  icon_widget: GtkWidgetPtr,
  label: gstring
): GtkToolButtonPtr {.importc.}

proc gtk_image_new_from_icon_name*(
  icon_name: gstring,
  size: GtkIconSize
): GtkWidgetPtr {.importc.}

proc gtk_file_chooser_dialog_new*(
  title: gstring,
  parent: GtkWindowPtr,
  action: GtkFileChooserAction,
  first_button_text: gstring,
  first_button_type: GtkResponseType,
  second_button_text: gstring,
  second_button_type: GtkResponseType,
  ending: pointer
): GtkFileChooserDialogPtr {.importc.}

proc gtk_file_chooser_set_do_overwrite_confirmation*(
  chooser: GtkFileChooserPtr,
  do_overwrite_confirmation: gboolean
) {.importc.}
proc gtk_file_chooser_get_filename*(
  chooser: GtkFileChooserPtr
): gstring {.importc.}

proc gtk_dialog_run*(dialog: GtkDialogPtr): gint {.importc.}

proc gtk_message_dialog_new*(
  parent: GtkWindowPtr,
  flags: GtkDialogFlags,
  `type`: GtkMessageType,
  buttons: GtkButtonsType,
  message_format: gstring
): GtkMessageDialogPtr {.importc.}

proc cairo_set_source_rgba*(
  cr: CairoPtr,
  red: cdouble,
  green: cdouble,
  blue: cdouble,
  alpha: cdouble
) {.importc.}
proc cairo_set_source_rgb*(
  cr: CairoPtr,
  red: cdouble,
  green: cdouble,
  blue: cdouble
) {.importc.}
proc cairo_paint*(cr: CairoPtr) {.importc.}
proc cairo_set_line_width*(cr: CairoPtr, width: cdouble) {.importc.}
proc cairo_set_line_cap*(cr: CairoPtr, line_cap: CairoLineCap) {.importc.}
proc cairo_set_line_join*(cr: CairoPtr, line_join: CairoLineJoin) {.importc.}
proc cairo_new_path*(cr: CairoPtr) {.importc.}
proc cairo_line_to*(cr: CairoPtr, x: cdouble, y: cdouble) {.importc.}
proc cairo_stroke*(cr: CairoPtr) {.importc.}
proc cairo_move_to*(cr: CairoPtr, x: cdouble, y: cdouble) {.importc.}
proc cairo_curve_to*(cr: CairoPtr, x1, y1, x2, y2, x3, y3: cdouble) {.importc.}
proc cairo_create*(target: CairoSurfacePtr): CairoPtr {.importc.}
proc cairo_set_source_surface*(
  cr: CairoPtr,
  surface: CairoSurfacePtr,
  x: cdouble,
  y: cdouble
) {.importc.}
proc cairo_svg_surface_create*(
  filename: cstring,
  width_in_points: cdouble,
  height_in_points: cdouble
): CairoSurfacePtr {.importc.}
proc cairo_surface_flush*(surface: CairoSurfacePtr) {.importc.}
proc cairo_surface_finish*(surface: CairoSurfacePtr) {.importc.}
proc cairo_svg_surface_restrict_to_version*(
  surface: CairoSurfacePtr,
  version: CairoSvgVersion
) {.importc.}
proc cairo_surface_get_type*(
  surface: CairoSurfacePtr
): CairoSurfaceType {.importc.}
proc cairo_image_surface_create*(
  format: CairoFormat,
  width: cint,
  height: cint
): CairoSurfacePtr {.importc.}
proc cairo_recording_surface_create*(
  content: CairoContent,
  extents: CairoRectanglePtr
): CairoSurfacePtr {.importc.}

proc gdk_window_create_similar_surface*(
  window: GdkWindowPtr,
  content: CairoContent,
  width: cint,
  height: cint
): CairoSurfacePtr {.importc.}

proc gdk_window_set_event_compression*(
  window: GdkWindowPtr,
  event_compression: gboolean
) {.importc.}

{.pop.}

{.push dynlib: libRsvg.}

proc rsvg_handle_new_from_file*(
  filename: gstring,
  error: GErrorPtrPtr
): RsvgHandlePtr {.importc.}
proc rsvg_handle_render_cairo*(
  handle: RsvgHandlePtr,
  cr: CairoPtr
): gboolean {.importc.}
proc rsvg_handle_set_dpi*(
  handle: RsvgHandlePtr,
  dpi: cdouble
) {.importc.}

{.pop.}
