import 'package:hajir/app/data/providers/network/api_provider.dart';
import 'package:hajir/app/data/providers/network/api_request_representable.dart';

class AttendanceApi implements APIRequestRepresentable {
  @override
  // TODO: implement body
  get body => throw UnimplementedError();

  @override
  // TODO: implement endpoint
  String get endpoint => throw UnimplementedError();

  @override
  Map<String, String>? get headers => {};

  @override
  // TODO: implement method
  HTTPMethod get method => throw UnimplementedError();

  @override
  // TODO: implement path
  String get path => throw UnimplementedError();

  @override
  Map<String, String>? get query => throw UnimplementedError();

  @override
  Future request() {
    return APIProvider.instance.request(this);
  }

  @override
  // TODO: implement url
  String get url => throw UnimplementedError();

  getAllInvitationList() {}
}
