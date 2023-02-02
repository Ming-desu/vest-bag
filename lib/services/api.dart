import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'api.g.dart';

@RestApi(baseUrl: 'https://vest-bag.herokuapp.com/api')
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

  @GET("/web-views")
  Future<WebView> getWebView();
}

@JsonSerializable()
class WebView {
  String? id;
  String? url;
  String? createdAt;
  String? updatedAt;
  int? v;

  WebView({this.id, this.url, this.createdAt, this.updatedAt, this.v});

  factory WebView.fromJson(Map<String, dynamic> json) {
    return WebView(
      id: json['sub']['_id'],
      url: json['sub']['url'],
      createdAt: json['sub']['created_at'],
      updatedAt: json['sub']['updated_at'],
      v: json['sub']['__v'],
    );
  }
}
