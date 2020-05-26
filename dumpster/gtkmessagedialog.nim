##  GTK - The GIMP Toolkit
##  Copyright (C) 2000 Red Hat, Inc.
##
##  This library is free software; you can redistribute it and/or
##  modify it under the terms of the GNU Lesser General Public
##  License as published by the Free Software Foundation; either
##  version 2 of the License, or (at your option) any later version.
##
##  This library is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
##  Lesser General Public License for more details.
##
##  You should have received a copy of the GNU Lesser General Public
##  License along with this library. If not, see <http://www.gnu.org/licenses/>.
##
##
##  Modified by the GTK+ Team and others 1997-2003.  See the AUTHORS
##  file for a list of people on the GTK+ Team.  See the ChangeLog
##  files for a list of changes.  These files are distributed with
##  GTK+ at ftp://ftp.gtk.org/pub/gtk/.
##

type
  GtkMessageDialog* = _GtkMessageDialog
  GtkMessageDialogPrivate* = _GtkMessageDialogPrivate
  GtkMessageDialogClass* = _GtkMessageDialogClass
  _GtkMessageDialog* {.bycopy.} = object
    parent_instance*: GtkDialog ## < private >
    priv*: ptr GtkMessageDialogPrivate

  _GtkMessageDialogClass* {.bycopy.} = object
    parent_class*: GtkDialogClass ##  Padding for future expansion
    _gtk_reserved1*: proc ()
    _gtk_reserved2*: proc ()
    _gtk_reserved3*: proc ()
    _gtk_reserved4*: proc ()


## *
##  GtkButtonsType:
##  @GTK_BUTTONS_NONE: no buttons at all
##  @GTK_BUTTONS_OK: an OK button
##  @GTK_BUTTONS_CLOSE: a Close button
##  @GTK_BUTTONS_CANCEL: a Cancel button
##  @GTK_BUTTONS_YES_NO: Yes and No buttons
##  @GTK_BUTTONS_OK_CANCEL: OK and Cancel buttons
##
##  Prebuilt sets of buttons for the dialog. If
##  none of these choices are appropriate, simply use %GTK_BUTTONS_NONE
##  then call gtk_dialog_add_buttons().
##
##  > Please note that %GTK_BUTTONS_OK, %GTK_BUTTONS_YES_NO
##  > and %GTK_BUTTONS_OK_CANCEL are discouraged by the
##  > [GNOME Human Interface Guidelines](http://library.gnome.org/devel/hig-book/stable/).
##

type
  GtkButtonsType* = enum
    GTK_BUTTONS_NONE, GTK_BUTTONS_OK, GTK_BUTTONS_CLOSE, GTK_BUTTONS_CANCEL,
    GTK_BUTTONS_YES_NO, GTK_BUTTONS_OK_CANCEL


proc gtk_message_dialog_get_type*(): GType
proc gtk_message_dialog_new*(parent: ptr GtkWindow; flags: GtkDialogFlags;
                            `type`: GtkMessageType; buttons: GtkButtonsType;
                            message_format: ptr gchar): ptr GtkWidget {.varargs.}
proc gtk_message_dialog_new_with_markup*(parent: ptr GtkWindow;
                                        flags: GtkDialogFlags;
                                        `type`: GtkMessageType;
                                        buttons: GtkButtonsType;
                                        message_format: ptr gchar): ptr GtkWidget {.
    varargs.}
proc gtk_message_dialog_set_image*(dialog: ptr GtkMessageDialog;
                                  image: ptr GtkWidget)
proc gtk_message_dialog_get_image*(dialog: ptr GtkMessageDialog): ptr GtkWidget
proc gtk_message_dialog_set_markup*(message_dialog: ptr GtkMessageDialog;
                                   str: ptr gchar)
proc gtk_message_dialog_format_secondary_text*(
    message_dialog: ptr GtkMessageDialog; message_format: ptr gchar) {.varargs.}
proc gtk_message_dialog_format_secondary_markup*(
    message_dialog: ptr GtkMessageDialog; message_format: ptr gchar) {.varargs.}
proc gtk_message_dialog_get_message_area*(message_dialog: ptr GtkMessageDialog): ptr GtkWidget