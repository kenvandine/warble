/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class Warble.Widgets.Dialogs.RulesDialog : Granite.Dialog {

    public RulesDialog (Warble.MainWindow main_window) {
        Object (
            deletable: false,
            resizable: false,
            title: "How to Play Warble",
            transient_for: main_window,
            modal: true,
            width_request: 300,
            hexpand: false
        );
    }

    construct {
        var body = get_content_area ();

        // Create the header
        var header_title = new Gtk.Label ("How to Play") {
            halign = Gtk.Align.CENTER,
            hexpand = true,
            margin_end = 10,
            wrap = true
        };
        header_title.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);

        var header_grid = create_grid ();
        header_grid.attach (header_title, 0, 0);

        body.append (header_grid);
        body.append (new Warble.Widgets.Rules ());

        // Add action buttons
        var start_button = new Gtk.Button.with_label (_("Close"));
        start_button.clicked.connect (() => {
            close ();
        });

        add_action_widget (start_button, 1);
    }

    private Gtk.Grid create_grid () {
        return new Gtk.Grid () {
            halign = Gtk.Align.CENTER,
            hexpand = true,
            margin_start = 30,
            margin_end = 30,
            margin_bottom = 10,
            row_spacing = 8,
            column_spacing = 10
        };
    }

}
