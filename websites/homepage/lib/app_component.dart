// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library homepage.app_component;

import 'dart:html';
import 'package:js/js.dart' show JS;

import 'package:angular2/angular2.dart';

import 'notebooks_service.dart';

@JS()
class componentHandler {
  external static upgradeDom();
}

@Component(selector: 'my-app', templateUrl: 'app_component.html')
class AppComponent implements AfterContentInit {
  int total = 42;
  int discussion = 43;

  AppComponent() {
    NotebooksService notebooksService = new NotebooksService();
    notebooksService.fetchNotebooks().then((c) {
      total = notebooksService.totalPoints;
      discussion = notebooksService.discussionPoints;
    });
  }
  ngAfterContentInit() {
    componentHandler.upgradeDom();
  }
}
