/*
 * Copyright (c) 2022 Andrew Vojak (https://avojak.com)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA
 *
 * Authored by: Andrew Vojak <andrew.vojak@gmail.com>
 */

public class Warble.Widgets.Key : Gtk.EventBox {

    private class KeyImage : Gtk.Image {

        private const int SIZE = 32;

        public char letter { get; construct; }

        public KeyImage (char letter) {
            Object (
                gicon: new ThemedIcon (Constants.APP_ID + ".key-blank"),
                pixel_size: SIZE,
                letter: letter,
                expand: false,
                halign: Gtk.Align.CENTER
            );
        }

        protected override bool draw (Cairo.Context ctx) {
            base.draw (ctx);
            ctx.save ();
            draw_letter (ctx);
            ctx.restore ();
            return false;
        }
    
        private void draw_letter (Cairo.Context ctx) {
            var color = new Granite.Drawing.Color.from_string (Warble.ColorPalette.TEXT_COLOR.get_value ());
            ctx.set_source_rgb (color.R, color.G, color.B);
    
            ctx.select_font_face ("Inter", Cairo.FontSlant.NORMAL, Cairo.FontWeight.BOLD);
            ctx.set_font_size (15);
    
            Cairo.TextExtents extents;
            ctx.text_extents (letter.to_string (), out extents);
            double x = (SIZE / 2) - (extents.width / 2 + extents.x_bearing);
            double y = (SIZE / 2) - (extents.height / 2 + extents.y_bearing);
            ctx.move_to (x, y);
            ctx.show_text (letter.to_string ());
        }

    }

    public char letter { get; construct; }

    private Warble.Models.State _state = Warble.Models.State.BLANK;
    public Warble.Models.State state {
        get { return this._state; }
        set { this._state = value; update_icon (); }
    }

    private Warble.Widgets.Key.KeyImage key;

    public Key (char letter) {
        Object (
            letter: letter
        );
    }

    construct {
        key = new Warble.Widgets.Key.KeyImage (letter);
        this.child = key;

        // I *think* this will work for touchscreens, but I don't have a device to test on :(
        add_events (Gdk.EventMask.BUTTON_PRESS_MASK | Gdk.EventMask.TOUCH_MASK);
        this.button_press_event.connect (() => {
            clicked (letter);
        });
        this.touch_event.connect (() => {
            clicked (letter);
        });
    }

    private void update_icon () {
        switch (state) {
            case BLANK:
                key.gicon = new ThemedIcon (Constants.APP_ID + ".key-blank");
                break;
            case INCORRECT:
                key.gicon = new ThemedIcon (Constants.APP_ID + ".key-incorrect");
                break;
            case CLOSE:
                key.gicon = new ThemedIcon (Constants.APP_ID + ".key-close");
                break;
            case CORRECT:
                key.gicon = new ThemedIcon (Constants.APP_ID + ".key-correct");
                break;
            default:
                assert_not_reached ();
        }
    }

    public signal void clicked (char letter);

}
