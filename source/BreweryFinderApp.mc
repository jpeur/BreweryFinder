import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class BreweryFinderApp extends Application.AppBase {

    //! Constructor
    public function initialize() {
        AppBase.initialize();
    }

    //! Handle app startup
    //! @param state Startup arguments
    public function onStart(state as Dictionary?) as Void {
    }

    //! Handle app shutdown
    //! @param state Shutdown arguments
    public function onStop(state as Dictionary?) as Void {
    }

    //! Return the initial view for the app
    //! @return Array Pair [View, Delegate]
    public function getInitialView() as [Views] or [Views, InputDelegates] {
        var view = new $.BreweryFinderView();
        var delegate = new $.BreweryFinderDelegate(view.method(:onReceive));
        return [view, delegate];
    }
}

function getApp() as BreweryFinderApp {
    return Application.getApp() as BreweryFinderApp;
}