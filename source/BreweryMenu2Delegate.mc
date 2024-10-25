import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.System;

class BreweryMenu2Delegate extends WatchUi.Menu2InputDelegate {
    var brewery_dict = {};

    function initialize(incoming_dict) {
        Menu2InputDelegate.initialize();
        // System.println("Handling input");
        brewery_dict = incoming_dict;
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        // System.println("Selected item at index: " + index);
        var label = item.getLabel();
        var dictionary_array = brewery_dict[label];
        // System.println("Selected item: " + label);
        // System.println("Selected item: " + brewery_dict[label]);
        if (brewery_dict[label] != null) {
            var menu = new WatchUi.Menu2({:title=>label});
            var delegate = new WatchUi.Menu2InputDelegate();

            // street
            menu.addItem(
                new MenuItem(
                    dictionary_array[1],
                    dictionary_array[2] + ", " + dictionary_array[3],
                    "address",
                    {}
                )
            );

            WatchUi.pushView(menu, delegate, WatchUi.SLIDE_BLINK);
        }
    }

    function onBack() as Void {
        // System.println("Exciting the app");
        System.exit();
    }
}