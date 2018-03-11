# kvvliveapi
Swift Bindings  für die API, die von der KVV Live Webapp benutzt wird.

Dank geht an [Nervengift](https://github.com/Nervengift), durch dessen [kvvliveapi](https://github.com/Nervengift/kvvliveapi) Projekt dieses entstand.

## API Dokumentation
Folgende Anfrage-Methoden stehen zuf Verfügung:

### Haltestellen nach Name
```
func searchStop(by: String, maxInfos: Int, completion: (([Stop]) -> Void))
```
### Haltestellen nach geografischen Koordinaten
```
func searchStop(by: (lat: Double, lon: Double), maxInfos: Int, completion: (([StopWithDistance]) -> Void))
```
### Abfahrten nach Haltestelle (stopId) und Linie (route)
```
func getDepartures(route: String, stopId: String, maxInfos: Int, completion: (([Departure]) -> Void))
```
### Abfahrten nach Haltestelle (stopId)
```
func getDepartures(stopId: String, maxInfos: Int = 10, _ completion: (([Departure]) -> Void))
```

## Beispiel Verwendung
Um eine Anfrage zu starten muss zunächst ein Request instanziiert werden:

```
let request = KVVlive.Request()
```

Nun kann man folgendermaßen Abfahrten einer Haltestelle abrufen:

```
var departures: [Departure]
request.getDepartures(stopId: stopId) { fetchedDepartures in
    departures = fetchedDepartures
}
```   
Die empfangenen Abfahrten können mittels eines Completion Handlers der Variabeln zugewiesen werden.
