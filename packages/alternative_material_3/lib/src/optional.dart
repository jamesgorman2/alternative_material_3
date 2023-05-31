
import 'dart:collection';

import '../material.dart';

abstract class Optional<E> {
  const Optional();

  static Optional<T> some<T>(T t) => Some<T>(t);
  static Optional<T> none<T>() => None<T>();
  static Optional<T> of<T>(T? t) => t == null ? None<T>() : Some<T>(t);

  E get value;
  Optional<E> or(E fallback);
  Optional<E> orFrom(E Function() f);
  E orElse(E fallback);
  E orElseFrom(E Function() f);
  E? orNull();
  E orThrow(Error error);
  E orThrowFrom(Error Function() f);

  bool get isEmpty;
  bool get isNotEmpty;

  Iterator<E> get iterator;

  Optional<E> where(bool Function(E element) f);

  bool any(bool Function(E element) f);

  Optional<T> map<T>(T Function(E e) f);
  Optional<T> flatMap<T>(Optional<T> Function(E e) f);
  void forEach(void Function(E e) f);

  List<E> toList();
}

@immutable
class Some<E> extends Optional<E> {
  const Some(E e) : _e = e;
  
  final E _e;

  @override
  bool any(bool Function(E element) f) => f(_e);

  @override
  void forEach(void Function(E e) f) => f(_e);

  @override
  bool get isEmpty => false;

  @override
  bool get isNotEmpty => true;

  @override
  Optional<E> or(E fallback) => this;

  @override
  E orElse(E fallback) => _e;

  @override
  E orElseFrom(E Function() f) => _e;

  @override
  E? orNull() => _e;

  @override
  E orThrow(Error error) => _e;

  @override
  Optional<T> map<T>(T Function(E e) f) => Some(f(_e));
  @override
  Optional<T> flatMap<T>(Optional<T> Function(E e) f) => f(_e);

  @override
  Iterator<E> get iterator => UnmodifiableSetView({_e}).iterator;

  @override
  E get value => _e;

  @override
  Optional<E> where(bool Function(E element) f) =>
      f(_e) ? this : None<E>();

  @override
  Optional<E> orFrom(E Function() f) => this;

  @override
  E orThrowFrom(Error Function() f) => _e;

  @override
  List<E> toList() => [_e];

}

class None<E> extends Optional<E> {
  const None();

  @override
  bool any(bool Function(E element) f) => false;

  @override
  Optional<T> flatMap<T>(Optional<T> Function(E e) f) => this as None<T>;

  @override
  void forEach(void Function(E e) f) {}

  @override
  bool get isEmpty => true;

  @override
  bool get isNotEmpty => false;

  @override
  Iterator<E> get iterator => UnmodifiableSetView<E>({}).iterator;

  @override
  Optional<T> map<T>(T Function(E e) f) => this as Optional<T>;

  @override
  Optional<E> or(E fallback) => Some(fallback);

  @override
  E orElse(E fallback) => fallback;

  @override
  E orElseFrom(E Function() f) => f();

  @override
  E? orNull() => null;
  @override
  E orThrow(Error error) {
    throw error;
  }

  @override
  E get value => throw OptionalNoneError();

  @override
  Optional<E> where(bool Function(E element) f) => this;

  @override
  Optional<E> orFrom(E Function() f) => Some(f());

  @override
  E orThrowFrom(Error Function() f) => throw f();

  @override
  List<E> toList() => [];
}

class OptionalNoneError extends Error {

}