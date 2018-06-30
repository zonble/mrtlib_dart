import 'dart:collection';
import 'mrtlib_data.dart' as mrtlib_data;

class MRTExit {
  String name;
  List<MRTLink> links = [];
  MRTExit(this.name);
  addLink(String routeID, MRTExit to) {
    final link = new MRTLink(routeID, to);
    this.links.add(link);
  }
}

class MRTLink {
  String routeID;
  MRTExit to;
  MRTLink(this.routeID, this.to);
}

class MRTRoute {
  MRTExit from;
  List<MRTLink> links;
  String _description = '';
  int get stationCount => this.links.length;
  int transionCount = 0;

  MRTRoute(MRTExit from, List<MRTLink> links) {
    this.from = from;
    this.links = links;
    this._description = from.name;
    String lastRouteID = this.links[0].routeID;
    if (this.links.length < 2) {
      this._description +=
          ' -${this.links.last.routeID}-> ${this.links.last.to.name}';
      return;
    }
    for (var x = 1; x < this.links.length; x++) {
      MRTLink link = this.links[x];
      if (link.routeID != lastRouteID) {
        this._description += ' -${lastRouteID}-> ${this.links[x - 1].to.name}';
        transionCount++;
      }
      lastRouteID = link.routeID;
    }

    this._description +=
        ' ${this.links.last.routeID}-> ${this.links.last.to.name}';
  }

  String toString() {
    return this._description;
  }

  int compareTo(MRTRoute anotherRoute) {
    if (anotherRoute.stationCount > this.stationCount) {
      return -1;
    } else if (anotherRoute.stationCount < this.stationCount) {
      return 1;
    }
    if (anotherRoute.transionCount > this.transionCount) {
      return -1;
    } else if (anotherRoute.transionCount < this.transionCount) {
      return 1;
    }
    return 0;
  }
}

class MRTMap {
  Map<String, MRTExit> exits = {};

  MRTMap() {
    this.load();
  }
  void load() {
    var data = mrtlib_data.data;
    for (final item in data) {
      String routeID = item[0];
      String from = item[1];
      String to = item[2];

      if (!this.exits.containsKey(from)) {
        this.exits[from] = new MRTExit(from);
      }
      if (!this.exits.containsKey(to)) {
        this.exits[to] = new MRTExit(to);
      }
      MRTExit fromExit = this.exits[from];
      MRTExit toExit = this.exits[to];
      fromExit.addLink(routeID, toExit);
      toExit.addLink(routeID, fromExit);
    }
  }

  List<MRTRoute> findRoutes(String from, String to) {
    if (from == null) { 
      throw new Exception('from is null');
    } else if (to == null) {
      throw new Exception('to is null');
    } else if (from == to) {
      throw new Exception('Begin and destination should be different.');
    }
    MRTExit fromExit = this.exits[from];
    MRTExit toExit = this.exits[to];
    if (fromExit == null) {
      throw new Exception('Unable to find this exit as begin.');
    } else if (toExit == null) {
      throw new Exception('Unable to find this exit as destination.');
    }
    _MRTRouteFinder finder = new _MRTRouteFinder(fromExit, toExit);
    return finder.routes;
  }
}

class _MRTRouteFinder {
  Queue<MRTLink> _visitedLinks = new Queue<MRTLink>();
  Queue<MRTExit> _visitedExits = new Queue<MRTExit>();
  MRTExit fromExit;
  MRTExit toExit;
  List<MRTRoute> foundRoutes = new List<MRTRoute>();
  List<MRTRoute> get routes => this.foundRoutes.toList();

  void _travelLinksOfExit(MRTExit exit) {
    List<MRTLink> links = exit.links;
    for (final MRTLink link in links) {
      if (link.to == this.toExit) {
        this._visitedLinks.addLast(link);
        List<MRTLink> copy = this._visitedLinks.toList();
        foundRoutes.add(new MRTRoute(this.fromExit, copy));
        this._visitedLinks.removeLast();
      } else if (!_visitedExits.contains(link.to)) {
        this._visitedExits.addLast(exit);
        this._visitedLinks.addLast(link);
        this._travelLinksOfExit(link.to);
        this._visitedExits.removeLast();
        this._visitedLinks.removeLast();
      }
    }
  }

  _MRTRouteFinder(MRTExit this.fromExit, MRTExit this.toExit) {
    this._travelLinksOfExit(fromExit);
    this.foundRoutes.sort((a, b) => a.compareTo(b));
  }
}
