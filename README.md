# kvvliveapi
Swift Bindings  für die API, die von der KVV Live Webapp benutzt wird.

Dank geht an [Nervengift](https://github.com/Nervengift), durch dessen [kvvliveapi](https://github.com/Nervengift/kvvliveapi) Projekt dieses entstand.

## Verwendung
Um eine Anfrage zu starten muss zunächst ein Request instanziiert werden:

```
let request = KVVlive.Request()
```

Nun kann man beispielsweise nach Abfahrten einer Haltestelle suchen:

```
var departures: [Departure]
request.getDepartures(stopId: stopId) { fetchedDepartures in
    departures = fetchedDepartures
}
```   
Folgende Anfrage-Methoden stehen zuf Verfügung:

```
func searchStop(by: String, maxInfos: Int, completion: (([Stop]) -> Void))
func searchStop(by: (lat: Double, lon: Double), maxInfos: Int, completion: (([StopWithDistance]) -> Void))
func getDepartures(route: String, stopId: String, maxInfos: Int, completion: (([Departure]) -> Void))
func getDepartures(stopId: String, maxInfos: Int = 10, _ completion: (([Departure]) -> Void))
```
