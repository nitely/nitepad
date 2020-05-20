##  GTK - The GIMP Toolkit
##  Copyright (C) 1995-1997 Peter Mattis, Spencer Kimball and Josh MacDonald
##
##  This library is free software; you can redistribute it and/or
##  modify it under the terms of the GNU Lesser General Public
##  License as published by the Free Software Foundation; either
##  version 2 of the License, or (at your option) any later version.
##
##  This library is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
##  Lesser General Public License for more details.
##
##  You should have received a copy of the GNU Lesser General Public
##  License along with this library. If not, see <http://www.gnu.org/licenses/>.
##
##
##  Modified by the GTK+ Team and others 1997-2000.  See the AUTHORS
##  file for a list of people on the GTK+ Team.  See the ChangeLog
##  files for a list of changes.  These files are distributed with
##  GTK+ at ftp://ftp.gtk.org/pub/gtk/.
##
## *
##  GtkDialogFlags:
##  @GTK_DIALOG_MODAL: Make the constructed dialog modal,
##      see gtk_window_set_modal()
##  @GTK_DIALOG_DESTROY_WITH_PARENT: Destroy the dialog when its
##      parent is destroyed, see gtk_window_set_destroy_with_parent()
##  @GTK_DIALOG_USE_HEADER_BAR: Create dialog with actions in header
##      bar instead of action area. Since 3.12.
##
##  Flags used to influence dialog construction.
##

type
  GtkDialogFlags* = enum
    GTK_DIALOG_MODAL = 1 shl 0, GTK_DIALOG_DESTROY_WITH_PARENT = 1 shl 1,
    GTK_DIALOG_USE_HEADER_BAR = 1 shl 2


## *
##  GtkResponseType:
##  @GTK_RESPONSE_NONE: Returned if an action widget has no response id,
##      or if the dialog gets programmatically hidden or destroyed
##  @GTK_RESPONSE_REJECT: Generic response id, not used by GTK+ dialogs
##  @GTK_RESPONSE_ACCEPT: Generic response id, not used by GTK+ dialogs
##  @GTK_RESPONSE_DELETE_EVENT: Returned if the dialog is deleted
##  @GTK_RESPONSE_OK: Returned by OK buttons in GTK+ dialogs
##  @GTK_RESPONSE_CANCEL: Returned by Cancel buttons in GTK+ dialogs
##  @GTK_RESPONSE_CLOSE: Returned by Close buttons in GTK+ dialogs
##  @GTK_RESPONSE_YES: Returned by Yes buttons in GTK+ dialogs
##  @GTK_RESPONSE_NO: Returned by No buttons in GTK+ dialogs
##  @GTK_RESPONSE_APPLY: Returned by Apply buttons in GTK+ dialogs
##  @GTK_RESPONSE_HELP: Returned by Help buttons in GTK+ dialogs
##
##  Predefined values for use as response ids in gtk_dialog_add_button().
##  All predefined values are negative; GTK+ leaves values of 0 or greater for
##  application-defined response ids.
##

type
  GtkResponseType* = enum
    GTK_RESPONSE_HELP = -11, GTK_RESPONSE_APPLY = -10, GTK_RESPONSE_NO = -9,
    GTK_RESPONSE_YES = -8, GTK_RESPONSE_CLOSE = -7, GTK_RESPONSE_CANCEL = -6,
    GTK_RESPONSE_OK = -5, GTK_RESPONSE_DELETE_EVENT = -4, GTK_RESPONSE_ACCEPT = -3,
    GTK_RESPONSE_REJECT = -2, GTK_RESPONSE_NONE = -1
  GtkDialog* = _GtkDialog
  GtkDialogPrivate* = _GtkDialogPrivate
  GtkDialogClass* = _GtkDialogClass


## *
##  GtkDialog:
##
##  The
##  and should not be directly accessed.
##

type
  _GtkDialog* {.bycopy.} = object
    window*: GtkWindow         ## < private >
    priv*: ptr GtkDialogPrivate


## *
##  GtkDialogClass:
##  @parent_class: The parent class.
##  @response: Signal emitted when an action widget is activated.
##  @close: Signal emitted when the user uses a keybinding to close the dialog.
##

type
  _GtkDialogClass* {.bycopy.} = object
    parent_class*: GtkWindowClass ## < public >
    response*: proc (dialog: ptr GtkDialog; response_id: gint) ##  Keybinding signals
    close*: proc (dialog: ptr GtkDialog) ## < private >
                                    ##  Padding for future expansion
    _gtk_reserved1*: proc ()
    _gtk_reserved2*: proc ()
    _gtk_reserved3*: proc ()
    _gtk_reserved4*: proc ()


proc gtk_dialog_get_type*(): GType
proc gtk_dialog_new*(): ptr GtkWidget
proc gtk_dialog_new_with_buttons*(title: ptr gchar; parent: ptr GtkWindow;
                                 flags: GtkDialogFlags;
                                 first_button_text: ptr gchar): ptr GtkWidget {.
    varargs.}
proc gtk_dialog_add_action_widget*(dialog: ptr GtkDialog; child: ptr GtkWidget;
                                  response_id: gint)
proc gtk_dialog_add_button*(dialog: ptr GtkDialog; button_text: ptr gchar;
                           response_id: gint): ptr GtkWidget
proc gtk_dialog_add_buttons*(dialog: ptr GtkDialog; first_button_text: ptr gchar) {.
    varargs.}
proc gtk_dialog_set_response_sensitive*(dialog: ptr GtkDialog; response_id: gint;
                                       setting: gboolean)
proc gtk_dialog_set_default_response*(dialog: ptr GtkDialog; response_id: gint)
proc gtk_dialog_get_widget_for_response*(dialog: ptr GtkDialog; response_id: gint): ptr GtkWidget
proc gtk_dialog_get_response_for_widget*(dialog: ptr GtkDialog;
                                        widget: ptr GtkWidget): gint
proc gtk_alternative_dialog_button_order*(screen: ptr GdkScreen): gboolean
proc gtk_dialog_set_alternative_button_order*(dialog: ptr GtkDialog;
    first_response_id: gint) {.varargs.}
proc gtk_dialog_set_alternative_button_order_from_array*(dialog: ptr GtkDialog;
    n_params: gint; new_order: ptr gint)
##  Emit response signal

proc gtk_dialog_response*(dialog: ptr GtkDialog; response_id: gint)
##  Returns response_id

proc gtk_dialog_run*(dialog: ptr GtkDialog): gint
proc gtk_dialog_get_action_area*(dialog: ptr GtkDialog): ptr GtkWidget
proc gtk_dialog_get_content_area*(dialog: ptr GtkDialog): ptr GtkWidget
proc gtk_dialog_get_header_bar*(dialog: ptr GtkDialog): ptr GtkWidget