# mrtlib

A simple library help to find routes in Taipei MRT.

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).

## Usage

To the the library, you can create a new instance of `MRTMap`.

``` dart
final map = new MRTMap();
```

Then, you can input two stations and find all possible routes between them.

``` dart
final routes = map.findRoutes('大安', '忠孝復興');
```

That's all!
