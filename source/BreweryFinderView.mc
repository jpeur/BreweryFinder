import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class BreweryFinderView extends WatchUi.View {
    private var _message as String = "Press Start to get breweries";

    // var myText;

    //! Constructor
    public function initialize() {
        WatchUi.View.initialize();
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        // myText = new WatchUi.TextArea({
        //     :text=>_message,
        //     :color=>Graphics.COLOR_WHITE,
        //     :font=>Graphics.FONT_MEDIUM,
        //     :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
        //     :locY=>WatchUi.LAYOUT_VALIGN_CENTER,
        //     :justification=>Graphics.TEXT_JUSTIFY_CENTER,
        //     :width=> dc.getWidth() * 0.9,
        //     :height=> dc.getHeight() * 0.9,
        // });
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    //! Restore the state of the app and prepare the view to be shown
    public function onShow() as Void {

    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        // dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        // dc.clear();
        // myText.draw(dc);
        View.onUpdate(dc);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    public function onHide() as Void {
    }

    //! Show the result or status of the web request
    //! @param args Data from the web request, or error message
    public function onReceive(args as Dictionary or String or Null) as Void {
        if (args instanceof String) {
            _message = args;
        } else if (args instanceof Dictionary) {
            // Print the arguments duplicated and returned by jsonplaceholder.typicode.com
            var keys = args.keys();
            _message = "";
            for (var i = 0; i < keys.size(); i++) {
                _message += Lang.format("$1$: $2$\n", [keys[i], args[keys[i]]]);
            }
        }
        WatchUi.requestUpdate();
    }
}