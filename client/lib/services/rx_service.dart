import 'package:rxdart/rxdart.dart';

/// C = invoking Command
/// R = Result Type
class RxService<C, R> {
  late Subject<C> _source;
  late Subject<R> _sink;
  late BehaviorSubject<bool> _isLoading;

  RxService() {
    _isLoading = BehaviorSubject<bool>.seeded(false);
    _source = BehaviorSubject<C>();
    _sink = BehaviorSubject<R>();

    _source.listen((value) => invoke(value));
  }

  Subject<bool> get isLoading => _isLoading;
  Subject<C> get source => _source;
  Subject<R> get sink => _sink;

  /// support direct invocation to get immediate value while at the same time
  /// putting the value in a Stream for any other listeners.
  Future<R> invoke(C command) async => throw UnimplementedError();
  Future<R?> invokeOrNull(C command) async => throw UnimplementedError();
}

abstract class RxCommand {}
