part of 'component.dart';

typedef ComponentSideEffect<T> = T Function(ComponentSideEffectApi);

abstract interface class ComponentSideEffectApi implements SideEffectApi {}

abstract interface class ComponentSideEffectRegistrar
    implements SideEffectRegistrar {
  @override
  T register<T>(ComponentSideEffect<T> sideEffect);
}

abstract interface class ComponentHandle
    implements CapsuleReader, ComponentSideEffectRegistrar {}

class _ComponentHandleImpl implements ComponentHandle {
  _ComponentHandleImpl(this.api, this.container);

  final Component api;
  final CapsuleContainer container;
  int sideEffectDataIndex = 0;

  @override
  T call<T>(Capsule<T> capsule) {
    final dispose = container.onNextUpdate(capsule, api.rebuild);
    api._dependencyDisposers.add(dispose);
    return container.read(capsule);
  }

  @override
  T register<T>(ComponentSideEffect<T> sideEffect) {
    /// Not available on Dart React.
    // assert(
    //   api.manager.debugDoingBuild,
    //   "You may only register side effects during a RearchConsumers's build! "
    //   'You are likely getting this error because you are calling '
    //   '"use.fooBar()" in a function callback.',
    // );

    if (sideEffectDataIndex == api._sideEffectData.length) {
      api._sideEffectData.add(sideEffect(api));
    }
    return api._sideEffectData[sideEffectDataIndex++] as T;
  }
}
