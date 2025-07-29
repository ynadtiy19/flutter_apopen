import 'dart:async';
// import 'dart:typed_data'; // 1. 已移除：此导入是多余的，因为 flutter/services.dart 已包含所需内容。
import 'package:flutter/services.dart';

/// 用于与原生平台通信的 MethodChannel。
/// com.sunpub/apopen 是通道的唯一名称，需要与原生端保持一致。
final MethodChannel _channel = const MethodChannel('com.sunpub/apopen')
  ..setMethodCallHandler(_handler);

///
/// 处理来自原生代码的方法调用（回调）。
/// 例如，当分享操作完成后，原生代码可以调用此处理器来通知Flutter结果。
///
Future<void> _handler(MethodCall methodCall) async {
  // 3. 已扩展：使用 switch 结构来处理不同的回调方法。
  switch (methodCall.method) {
    case 'onShareResponse':
      // 假设原生代码会返回分享的结果，例如 "success", "cancel", "failure"
      final String? status = methodCall.arguments as String?;
      print('分享结果回调: $status');
      // 在这里，您可以根据状态更新UI或执行其他逻辑
      break;
    default:
      print('收到了一个未知的原生回调: ${methodCall.method}');
      break;
  }
}

/// 向支付宝注册您的应用。
///
/// [appId] 是您在支付宝开放平台申请的应用ID。
Future<void> registerAP({required String appId}) async {
  // 2. 类型已修改：使用 Future<void> 表示我们不期望从此方法获得返回值。
  await _channel.invokeMethod("registerAp", {
    "appId": appId,
  });
}

/// 分享纯文本到支付宝。
Future<void> shareText(String text) async {
  await _channel.invokeMethod("shareText", {
    "text": text,
  });
}

/// 分享图片的二进制数据到支付宝。
///
/// [data] 是图片的 Uint8List 数据。
Future<void> shareImageData(Uint8List data) async {
  await _channel.invokeMethod("shareImageData", {
    "imageData": data,
  });
}

/// 通过图片URL分享到支付宝。
Future<void> shareImageUrl(String url) async {
  await _channel.invokeMethod("shareImageUrl", {
    "imageUrl": url,
  });
}

/// 分享网页，并附带一张图片的二进制数据作为缩略图。
Future<void> shareWebAndImgData({
  String title = '',
  String desc = '',
  required String wepageUrl,
  required Uint8List imageData,
}) async {
  await _channel.invokeMethod("shareWebData", {
    "title": title,
    "desc": desc,
    "wepageUrl": wepageUrl,
    "imageData": imageData,
  });
}

/// 分享网页，并附带一个图片URL作为缩略图。
Future<void> shareWebAndImgUrl({
  String title = '',
  String desc = '',
  required String wepageUrl,
  required String imageUrl,
}) async {
  await _channel.invokeMethod("shareWebUrl", {
    "title": title,
    "desc": desc,
    "wepageUrl": wepageUrl,
    "imageUrl": imageUrl,
  });
}

/// 检查用户设备上是否安装了支付宝App。
///
/// 返回一个布尔值：`true` 表示已安装，`false` 表示未安装。
Future<bool> isAPAppInstalled() async {
  // 2. 类型已修改：明确期望返回一个布尔值。
  final bool? result = await _channel.invokeMethod("isAPAppInstalled");
  // 添加了 null 检查，确保总是返回一个布尔值，增加代码的健壮性。
  return result ?? false;
}