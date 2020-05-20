##  GTK - The GIMP Toolkit
##  gtkfilechooser.h: Abstract interface for file selector GUIs
##  Copyright (C) 2003, Red Hat, Inc.
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

type
  GtkFileChooser* = _GtkFileChooser

## *
##  GtkFileChooserAction:
##  @GTK_FILE_CHOOSER_ACTION_OPEN: Indicates open mode.  The file chooser
##   will only let the user pick an existing file.
##  @GTK_FILE_CHOOSER_ACTION_SAVE: Indicates save mode.  The file chooser
##   will let the user pick an existing file, or type in a new
##   filename.
##  @GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER: Indicates an Open mode for
##   selecting folders.  The file chooser will let the user pick an
##   existing folder.
##  @GTK_FILE_CHOOSER_ACTION_CREATE_FOLDER: Indicates a mode for creating a
##   new folder.  The file chooser will let the user name an existing or
##   new folder.
##
##  Describes whether a
##  or to save to a possibly new file.
##

type
  GtkFileChooserAction* = enum
    GTK_FILE_CHOOSER_ACTION_OPEN, GTK_FILE_CHOOSER_ACTION_SAVE,
    GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER, GTK_FILE_CHOOSER_ACTION_CREATE_FOLDER


## *
##  GtkFileChooserConfirmation:
##  @GTK_FILE_CHOOSER_CONFIRMATION_CONFIRM: The file chooser will present
##   its stock dialog to confirm about overwriting an existing file.
##  @GTK_FILE_CHOOSER_CONFIRMATION_ACCEPT_FILENAME: The file chooser will
##   terminate and accept the user’s choice of a file name.
##  @GTK_FILE_CHOOSER_CONFIRMATION_SELECT_AGAIN: The file chooser will
##   continue running, so as to let the user select another file name.
##
##  Used as a return value of handlers for the
##
##  value determines whether the file chooser will present the stock
##  confirmation dialog, accept the user’s choice of a filename, or
##  let the user choose another filename.
##
##  Since: 2.8
##

type
  GtkFileChooserConfirmation* = enum
    GTK_FILE_CHOOSER_CONFIRMATION_CONFIRM,
    GTK_FILE_CHOOSER_CONFIRMATION_ACCEPT_FILENAME,
    GTK_FILE_CHOOSER_CONFIRMATION_SELECT_AGAIN


proc gtk_file_chooser_get_type*(): GType
##  GError enumeration for GtkFileChooser
## *
##  GTK_FILE_CHOOSER_ERROR:
##
##  Used to get the
##
## *
##  GtkFileChooserError:
##  @GTK_FILE_CHOOSER_ERROR_NONEXISTENT: Indicates that a file does not exist.
##  @GTK_FILE_CHOOSER_ERROR_BAD_FILENAME: Indicates a malformed filename.
##  @GTK_FILE_CHOOSER_ERROR_ALREADY_EXISTS: Indicates a duplicate path (e.g. when
##   adding a bookmark).
##  @GTK_FILE_CHOOSER_ERROR_INCOMPLETE_HOSTNAME: Indicates an incomplete hostname (e.g. "http://foo" without a slash after that).
##
##  These identify the various errors that can occur while calling
##
##

type
  GtkFileChooserError* = enum
    GTK_FILE_CHOOSER_ERROR_NONEXISTENT, GTK_FILE_CHOOSER_ERROR_BAD_FILENAME,
    GTK_FILE_CHOOSER_ERROR_ALREADY_EXISTS,
    GTK_FILE_CHOOSER_ERROR_INCOMPLETE_HOSTNAME


proc gtk_file_chooser_error_quark*(): GQuark
##  Configuration
##

proc gtk_file_chooser_set_action*(chooser: ptr GtkFileChooser;
                                 action: GtkFileChooserAction)
proc gtk_file_chooser_get_action*(chooser: ptr GtkFileChooser): GtkFileChooserAction
proc gtk_file_chooser_set_local_only*(chooser: ptr GtkFileChooser;
                                     local_only: gboolean)
proc gtk_file_chooser_get_local_only*(chooser: ptr GtkFileChooser): gboolean
proc gtk_file_chooser_set_select_multiple*(chooser: ptr GtkFileChooser;
    select_multiple: gboolean)
proc gtk_file_chooser_get_select_multiple*(chooser: ptr GtkFileChooser): gboolean
proc gtk_file_chooser_set_show_hidden*(chooser: ptr GtkFileChooser;
                                      show_hidden: gboolean)
proc gtk_file_chooser_get_show_hidden*(chooser: ptr GtkFileChooser): gboolean
proc gtk_file_chooser_set_do_overwrite_confirmation*(chooser: ptr GtkFileChooser;
    do_overwrite_confirmation: gboolean)
proc gtk_file_chooser_get_do_overwrite_confirmation*(chooser: ptr GtkFileChooser): gboolean
proc gtk_file_chooser_set_create_folders*(chooser: ptr GtkFileChooser;
    create_folders: gboolean)
proc gtk_file_chooser_get_create_folders*(chooser: ptr GtkFileChooser): gboolean
##  Suggested name for the Save-type actions
##

proc gtk_file_chooser_set_current_name*(chooser: ptr GtkFileChooser; name: ptr gchar)
proc gtk_file_chooser_get_current_name*(chooser: ptr GtkFileChooser): ptr gchar
##  Filename manipulation
##

proc gtk_file_chooser_get_filename*(chooser: ptr GtkFileChooser): ptr gchar
proc gtk_file_chooser_set_filename*(chooser: ptr GtkFileChooser; filename: cstring): gboolean
proc gtk_file_chooser_select_filename*(chooser: ptr GtkFileChooser;
                                      filename: cstring): gboolean
proc gtk_file_chooser_unselect_filename*(chooser: ptr GtkFileChooser;
                                        filename: cstring)
proc gtk_file_chooser_select_all*(chooser: ptr GtkFileChooser)
proc gtk_file_chooser_unselect_all*(chooser: ptr GtkFileChooser)
proc gtk_file_chooser_get_filenames*(chooser: ptr GtkFileChooser): ptr GSList
proc gtk_file_chooser_set_current_folder*(chooser: ptr GtkFileChooser;
    filename: ptr gchar): gboolean
proc gtk_file_chooser_get_current_folder*(chooser: ptr GtkFileChooser): ptr gchar
##  URI manipulation
##

proc gtk_file_chooser_get_uri*(chooser: ptr GtkFileChooser): ptr gchar
proc gtk_file_chooser_set_uri*(chooser: ptr GtkFileChooser; uri: cstring): gboolean
proc gtk_file_chooser_select_uri*(chooser: ptr GtkFileChooser; uri: cstring): gboolean
proc gtk_file_chooser_unselect_uri*(chooser: ptr GtkFileChooser; uri: cstring)
proc gtk_file_chooser_get_uris*(chooser: ptr GtkFileChooser): ptr GSList
proc gtk_file_chooser_set_current_folder_uri*(chooser: ptr GtkFileChooser;
    uri: ptr gchar): gboolean
proc gtk_file_chooser_get_current_folder_uri*(chooser: ptr GtkFileChooser): ptr gchar
##  GFile manipulation

proc gtk_file_chooser_get_file*(chooser: ptr GtkFileChooser): ptr GFile
proc gtk_file_chooser_set_file*(chooser: ptr GtkFileChooser; file: ptr GFile;
                               error: ptr ptr GError): gboolean
proc gtk_file_chooser_select_file*(chooser: ptr GtkFileChooser; file: ptr GFile;
                                  error: ptr ptr GError): gboolean
proc gtk_file_chooser_unselect_file*(chooser: ptr GtkFileChooser; file: ptr GFile)
proc gtk_file_chooser_get_files*(chooser: ptr GtkFileChooser): ptr GSList
proc gtk_file_chooser_set_current_folder_file*(chooser: ptr GtkFileChooser;
    file: ptr GFile; error: ptr ptr GError): gboolean
proc gtk_file_chooser_get_current_folder_file*(chooser: ptr GtkFileChooser): ptr GFile
##  Preview widget
##

proc gtk_file_chooser_set_preview_widget*(chooser: ptr GtkFileChooser;
    preview_widget: ptr GtkWidget)
proc gtk_file_chooser_get_preview_widget*(chooser: ptr GtkFileChooser): ptr GtkWidget
proc gtk_file_chooser_set_preview_widget_active*(chooser: ptr GtkFileChooser;
    active: gboolean)
proc gtk_file_chooser_get_preview_widget_active*(chooser: ptr GtkFileChooser): gboolean
proc gtk_file_chooser_set_use_preview_label*(chooser: ptr GtkFileChooser;
    use_label: gboolean)
proc gtk_file_chooser_get_use_preview_label*(chooser: ptr GtkFileChooser): gboolean
proc gtk_file_chooser_get_preview_filename*(chooser: ptr GtkFileChooser): cstring
proc gtk_file_chooser_get_preview_uri*(chooser: ptr GtkFileChooser): cstring
proc gtk_file_chooser_get_preview_file*(chooser: ptr GtkFileChooser): ptr GFile
##  Extra widget
##

proc gtk_file_chooser_set_extra_widget*(chooser: ptr GtkFileChooser;
                                       extra_widget: ptr GtkWidget)
proc gtk_file_chooser_get_extra_widget*(chooser: ptr GtkFileChooser): ptr GtkWidget
##  List of user selectable filters
##

proc gtk_file_chooser_add_filter*(chooser: ptr GtkFileChooser;
                                 filter: ptr GtkFileFilter)
proc gtk_file_chooser_remove_filter*(chooser: ptr GtkFileChooser;
                                    filter: ptr GtkFileFilter)
proc gtk_file_chooser_list_filters*(chooser: ptr GtkFileChooser): ptr GSList
##  Current filter
##

proc gtk_file_chooser_set_filter*(chooser: ptr GtkFileChooser;
                                 filter: ptr GtkFileFilter)
proc gtk_file_chooser_get_filter*(chooser: ptr GtkFileChooser): ptr GtkFileFilter
##  Per-application shortcut folders

proc gtk_file_chooser_add_shortcut_folder*(chooser: ptr GtkFileChooser;
    folder: cstring; error: ptr ptr GError): gboolean
proc gtk_file_chooser_remove_shortcut_folder*(chooser: ptr GtkFileChooser;
    folder: cstring; error: ptr ptr GError): gboolean
proc gtk_file_chooser_list_shortcut_folders*(chooser: ptr GtkFileChooser): ptr GSList
proc gtk_file_chooser_add_shortcut_folder_uri*(chooser: ptr GtkFileChooser;
    uri: cstring; error: ptr ptr GError): gboolean
proc gtk_file_chooser_remove_shortcut_folder_uri*(chooser: ptr GtkFileChooser;
    uri: cstring; error: ptr ptr GError): gboolean
proc gtk_file_chooser_list_shortcut_folder_uris*(chooser: ptr GtkFileChooser): ptr GSList
proc gtk_file_chooser_add_choice*(chooser: ptr GtkFileChooser; id: cstring;
                                 label: cstring; options: cstringArray;
                                 option_labels: cstringArray)
proc gtk_file_chooser_remove_choice*(chooser: ptr GtkFileChooser; id: cstring)
proc gtk_file_chooser_set_choice*(chooser: ptr GtkFileChooser; id: cstring;
                                 option: cstring)
proc gtk_file_chooser_get_choice*(chooser: ptr GtkFileChooser; id: cstring): cstring