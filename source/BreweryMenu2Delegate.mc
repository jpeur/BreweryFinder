import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.System;

class BreweryMenu2Delegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
        // System.println("Handling input");
    }

    function onSelect(index) as Void {
        System.println("Selected item at index: " + index);
    }

    function onBack() as Void {
        // System.println("Exciting the app");
        System.exit();
    }
}