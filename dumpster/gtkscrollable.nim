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

type
  GtkScrolledWindow* = _GtkScrolledWindow
  GtkScrolledWindowPrivate* = _GtkScrolledWindowPrivate
  GtkScrolledWindowClass* = _GtkScrolledWindowClass
  _GtkScrolledWindow* {.bycopy.} = object
    container*: GtkBin
    priv*: ptr GtkScrolledWindowPrivate


## *
##  GtkScrolledWindowClass:
##  @parent_class: The parent class.
##  @scrollbar_spacing:
##  @scroll_child: Keybinding signal which gets emitted when a
##     keybinding that scrolls is pressed.
##  @move_focus_out: Keybinding signal which gets emitted when focus is
##     moved away from the scrolled window by a keybinding.
##

type
  _GtkScrolledWindowClass* {.bycopy.} = object
    parent_class*: GtkBinClass
    scrollbar_spacing*: gint ## < public >
                           ##  Action signals for keybindings. Do not connect to these signals
                           ##
                           ##  Unfortunately, GtkScrollType is deficient in that there is
                           ##  no horizontal/vertical variants for GTK_SCROLL_START/END,
                           ##  so we have to add an additional boolean flag.
                           ##
    scroll_child*: proc (scrolled_window: ptr GtkScrolledWindow;
                       scroll: GtkScrollType; horizontal: gboolean): gboolean
    move_focus_out*: proc (scrolled_window: ptr GtkScrolledWindow;
                         direction: GtkDirectionType) ## < private >
                                                    ##  Padding for future expansion
    _gtk_reserved1*: proc ()
    _gtk_reserved2*: proc ()
    _gtk_reserved3*: proc ()
    _gtk_reserved4*: proc ()


## *
##  GtkCornerType:
##  @GTK_CORNER_TOP_LEFT: Place the scrollbars on the right and bottom of the
##   widget (default behaviour).
##  @GTK_CORNER_BOTTOM_LEFT: Place the scrollbars on the top and right of the
##   widget.
##  @GTK_CORNER_TOP_RIGHT: Place the scrollbars on the left and bottom of the
##   widget.
##  @GTK_CORNER_BOTTOM_RIGHT: Place the scrollbars on the top and left of the
##   widget.
##
##  Specifies which corner a child widget should be placed in when packed into
##  a #GtkScrolledWindow. This is effectively the opposite of where the scroll
##  bars are placed.
##

type
  GtkCornerType* = enum
    GTK_CORNER_TOP_LEFT, GTK_CORNER_BOTTOM_LEFT, GTK_CORNER_TOP_RIGHT,
    GTK_CORNER_BOTTOM_RIGHT


## *
##  GtkPolicyType:
##  @GTK_POLICY_ALWAYS: The scrollbar is always visible. The view size is
##   independent of the content.
##  @GTK_POLICY_AUTOMATIC: The scrollbar will appear and disappear as necessary.
##   For example, when all of a #GtkTreeView can not be seen.
##  @GTK_POLICY_NEVER: The scrollbar should never appear. In this mode the
##   content determines the size.
##  @GTK_POLICY_EXTERNAL: Don't show a scrollbar, but don't force the
##   size to follow the content. This can be used e.g. to make multiple
##   scrolled windows share a scrollbar. Since: 3.16
##
##  Determines how the size should be computed to achieve the one of the
##  visibility mode for the scrollbars.
##

type
  GtkPolicyType* = enum
    GTK_POLICY_ALWAYS, GTK_POLICY_AUTOMATIC, GTK_POLICY_NEVER, GTK_POLICY_EXTERNAL


proc gtk_scrolled_window_get_type*(): GType
proc gtk_scrolled_window_new*(hadjustment: ptr GtkAdjustment;
                             vadjustment: ptr GtkAdjustment): ptr GtkWidget
proc gtk_scrolled_window_set_hadjustment*(scrolled_window: ptr GtkScrolledWindow;
    hadjustment: ptr GtkAdjustment)
proc gtk_scrolled_window_set_vadjustment*(scrolled_window: ptr GtkScrolledWindow;
    vadjustment: ptr GtkAdjustment)
proc gtk_scrolled_window_get_hadjustment*(scrolled_window: ptr GtkScrolledWindow): ptr GtkAdjustment
proc gtk_scrolled_window_get_vadjustment*(scrolled_window: ptr GtkScrolledWindow): ptr GtkAdjustment
proc gtk_scrolled_window_get_hscrollbar*(scrolled_window: ptr GtkScrolledWindow): ptr GtkWidget
proc gtk_scrolled_window_get_vscrollbar*(scrolled_window: ptr GtkScrolledWindow): ptr GtkWidget
proc gtk_scrolled_window_set_policy*(scrolled_window: ptr GtkScrolledWindow;
                                    hscrollbar_policy: GtkPolicyType;
                                    vscrollbar_policy: GtkPolicyType)
proc gtk_scrolled_window_get_policy*(scrolled_window: ptr GtkScrolledWindow;
                                    hscrollbar_policy: ptr GtkPolicyType;
                                    vscrollbar_policy: ptr GtkPolicyType)
proc gtk_scrolled_window_set_placement*(scrolled_window: ptr GtkScrolledWindow;
                                       window_placement: GtkCornerType)
proc gtk_scrolled_window_unset_placement*(scrolled_window: ptr GtkScrolledWindow)
proc gtk_scrolled_window_get_placement*(scrolled_window: ptr GtkScrolledWindow): GtkCornerType
proc gtk_scrolled_window_set_shadow_type*(scrolled_window: ptr GtkScrolledWindow;
    `type`: GtkShadowType)
proc gtk_scrolled_window_get_shadow_type*(scrolled_window: ptr GtkScrolledWindow): GtkShadowType
proc gtk_scrolled_window_add_with_viewport*(
    scrolled_window: ptr GtkScrolledWindow; child: ptr GtkWidget)
proc gtk_scrolled_window_get_min_content_width*(
    scrolled_window: ptr GtkScrolledWindow): gint
proc gtk_scrolled_window_set_min_content_width*(
    scrolled_window: ptr GtkScrolledWindow; width: gint)
proc gtk_scrolled_window_get_min_content_height*(
    scrolled_window: ptr GtkScrolledWindow): gint
proc gtk_scrolled_window_set_min_content_height*(
    scrolled_window: ptr GtkScrolledWindow; height: gint)
proc gtk_scrolled_window_set_kinetic_scrolling*(
    scrolled_window: ptr GtkScrolledWindow; kinetic_scrolling: gboolean)
proc gtk_scrolled_window_get_kinetic_scrolling*(
    scrolled_window: ptr GtkScrolledWindow): gboolean
proc gtk_scrolled_window_set_capture_button_press*(
    scrolled_window: ptr GtkScrolledWindow; capture_button_press: gboolean)
proc gtk_scrolled_window_get_capture_button_press*(
    scrolled_window: ptr GtkScrolledWindow): gboolean
proc gtk_scrolled_window_set_overlay_scrolling*(
    scrolled_window: ptr GtkScrolledWindow; overlay_scrolling: gboolean)
proc gtk_scrolled_window_get_overlay_scrolling*(
    scrolled_window: ptr GtkScrolledWindow): gboolean
proc gtk_scrolled_window_set_max_content_width*(
    scrolled_window: ptr GtkScrolledWindow; width: gint)
proc gtk_scrolled_window_get_max_content_width*(
    scrolled_window: ptr GtkScrolledWindow): gint
proc gtk_scrolled_window_set_max_content_height*(
    scrolled_window: ptr GtkScrolledWindow; height: gint)
proc gtk_scrolled_window_get_max_content_height*(
    scrolled_window: ptr GtkScrolledWindow): gint
proc gtk_scrolled_window_set_propagate_natural_width*(
    scrolled_window: ptr GtkScrolledWindow; propagate: gboolean)
proc gtk_scrolled_window_get_propagate_natural_width*(
    scrolled_window: ptr GtkScrolledWindow): gboolean
proc gtk_scrolled_window_set_propagate_natural_height*(
    scrolled_window: ptr GtkScrolledWindow; propagate: gboolean)
proc gtk_scrolled_window_get_propagate_natural_height*(
    scrolled_window: ptr GtkScrolledWindow): gboolean