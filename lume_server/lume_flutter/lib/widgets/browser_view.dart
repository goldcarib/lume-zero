import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui_web;

/// A Web implementation of a browser view using HtmlElementView
class BrowserView extends StatelessWidget {
  final String url;
  
  const BrowserView({super.key, required this.url});
  
  @override
  Widget build(BuildContext context) {
    // Create a unique ID for this view based on URL
    final String viewId = 'iframe-view-${url.hashCode}';
    
    // Register the view factory
    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(
      viewId,
      (int viewId) {
        final element = html.IFrameElement();
        element.src = url;
        element.style.border = 'none';
        element.style.width = '100%';
        element.style.height = '100%';
        return element;
      }
    );
    
    return HtmlElementView(viewType: viewId);
  }
}
