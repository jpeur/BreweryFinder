import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Communications;
using Toybox.Position;
using Toybox.System;

class BreweryFinderDelegate extends WatchUi.BehaviorDelegate {
    private var _notify as Method(args as Dictionary or String or Null) as Void;

    //! Set up the callback to the view
    //! @param handler Callback method for when data is received
    public function initialize(handler as Method(args as Dictionary or String or Null) as Void) {
        WatchUi.BehaviorDelegate.initialize();
        _notify = handler;
    }

    //! On a menu event, make a web request
    //! @return true if handled, false otherwise
    public function onMenu() as Boolean {
        makeRequest();
        return true;
    }

    //! On a select event, make a web request
    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {
        makeRequest();
        return true;
    }

    //! Make the web request
    private function makeRequest() as Void {
        _notify.invoke("Executing\nRequest");

        var options = {
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
            }
        };

        var positionInfo = Position.getInfo();
        var lat = 35.779591;
        var lon = -78.638176;

        if(positionInfo has :latitude && positionInfo has :longitude) {
            lat = positionInfo.latitude;
            lon = positionInfo.longitude;
        }

        System.println("Latitude: " + lat);
        System.println("Longitude: " + lon);

        var API_string = "https://api.openbrewerydb.org/breweries?by_dist=" + lat + "," + lon +"&per_page=10";

        Communications.makeWebRequest(
            API_string,
            null,
            options,
            method(:onReceive)
        );
    }

    var menu = new WatchUi.Menu2({:title=>"Brewery List"});
    var delegate = new WatchUi.Menu2InputDelegate();

    //! Receive the data from the web request
    //! @param responseCode The server response code
    //! @param data Content from a successful request
    public function onReceive(responseCode as Number, data as Dictionary or String or Null) as Void {
        if (responseCode == 200) {
            if (data == null) {
                _notify.invoke("No data received");
                return;
            } else {
                for (var i = 0; i < data.size(); i++) {
                    var brewery = data[i];  // Get each brewery as a dictionary

                    var name = brewery["name"];
                    var type = brewery["brewery_type"];

                    // Access properties
                    System.println("Name: " + name);
                    System.println("Type: " + type);
                    menu.addItem(
                        new MenuItem(
                            name,
                            type,
                            "brew" + i,
                            {}
                        )
                    );
                }
                WatchUi.pushView(menu, delegate, WatchUi.SLIDE_BLINK);
                System.print(data.toString());
            }
        } else {
            _notify.invoke("Failed to load\nError: " + responseCode.toString());
        }
    }
}