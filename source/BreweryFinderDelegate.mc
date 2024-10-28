import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Communications;
using Toybox.Position;
using Toybox.System;
using Toybox.Time;
using Toybox.Application.Storage;

class BreweryFinderDelegate extends WatchUi.BehaviorDelegate {
    private var _notify as Method(args as Dictionary or String or Null) as Void;

    var brewery_dict = {};

    var latitude = 0.0;
    var longitude = 0.0;

    function onPosition(loc as Position.Info) as Void {
        var myLocation = loc.position.toDegrees();
        latitude = myLocation[0];
        longitude = myLocation[1];
        makeRequest();
    }

    //! Set up the callback to the view
    //! @param handler Callback method for when data is received
    public function initialize(handler as Method(args as Dictionary or String or Null) as Void) {
        WatchUi.BehaviorDelegate.initialize();
        _notify = handler;
        if(Storage.getValue("lastUpdate") == null) {
            Storage.setValue("lastUpdate", 0);
        }
    }

    //! On a select event, make a web request
    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {
        // makeRequest();
        var positionInfo = Position.getInfo();
        var now = new Time.Moment(Time.now().value());

        System.println("Now: " + now.value());
        System.println("When: " + Storage.getValue("lastUpdate"));

        if(positionInfo.when != null) {
            if (now.value() - Storage.getValue("lastUpdate") < 600) {
                // System.println(now.subtract(positionInfo.when).value());
                // System.println("Difference: " + now.value() - Storage.getValue("lastUpdate"));
                onPosition(positionInfo);
                return true;
            }
        }
        Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));
        Storage.setValue("lastUpdate", now.value());
        System.println("Last Update: " + Storage.getValue("lastUpdate"));
        _notify.invoke("acquire");
        return true;
    }

    //! Make the web request
    private function makeRequest() as Void {
        _notify.invoke("loading");

        var options = {
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
            }
        };

        // var positionInfo = Position.getInfo();
        // var lat = 35.779591;
        // var lon = -78.638176;

        // if(positionInfo.position != null) {
        //     var degrees = positionInfo.position.toDegrees();
        //     // System.println(degrees[0]);
        //     lat = degrees[0];
        //     // System.println(degrees[1]);
        //     lon = degrees[1];
        // }

        System.println("Latitude: " + latitude);
        System.println("Longitude: " + longitude);

        if(latitude.toNumber() == 0) {
            System.println("No location data available");
        }

        var API_string = "https://api.openbrewerydb.org/breweries?by_dist=" + latitude + "," + longitude +"&per_page=10";

        Communications.makeWebRequest(
            API_string,
            null,
            options,
            method(:onReceive)
        );
    }

    var menu = new WatchUi.Menu2({:title=>"Brewery List"});
    var delegate = new BreweryMenu2Delegate(brewery_dict);

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
                    var street = brewery["street"];
                    var city = brewery["city"];
                    var state = brewery["state"];

                    brewery_dict[name] =[type, street, city, state];
                    // System.println(brewery.toString());

                    // Access properties
                    // System.println("Name: " + name);
                    // System.println("Type: " + type);
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
                // System.print(data.toString());
            }
        } else {
            _notify.invoke("Failed to load\nError: " + responseCode.toString());
        }
        // System.println(brewery_dict.toString());
    }
}