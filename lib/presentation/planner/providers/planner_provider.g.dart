// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planner_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$plannerAssignmentsHash() =>
    r'0b024712a6ce7a6cebea891d724dacaa5da61982';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [plannerAssignments].
@ProviderFor(plannerAssignments)
const plannerAssignmentsProvider = PlannerAssignmentsFamily();

/// See also [plannerAssignments].
class PlannerAssignmentsFamily
    extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [plannerAssignments].
  const PlannerAssignmentsFamily();

  /// See also [plannerAssignments].
  PlannerAssignmentsProvider call({
    required DateTime start,
    required DateTime end,
  }) {
    return PlannerAssignmentsProvider(start: start, end: end);
  }

  @override
  PlannerAssignmentsProvider getProviderOverride(
    covariant PlannerAssignmentsProvider provider,
  ) {
    return call(start: provider.start, end: provider.end);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'plannerAssignmentsProvider';
}

/// See also [plannerAssignments].
class PlannerAssignmentsProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [plannerAssignments].
  PlannerAssignmentsProvider({required DateTime start, required DateTime end})
    : this._internal(
        (ref) => plannerAssignments(
          ref as PlannerAssignmentsRef,
          start: start,
          end: end,
        ),
        from: plannerAssignmentsProvider,
        name: r'plannerAssignmentsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$plannerAssignmentsHash,
        dependencies: PlannerAssignmentsFamily._dependencies,
        allTransitiveDependencies:
            PlannerAssignmentsFamily._allTransitiveDependencies,
        start: start,
        end: end,
      );

  PlannerAssignmentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.start,
    required this.end,
  }) : super.internal();

  final DateTime start;
  final DateTime end;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(PlannerAssignmentsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PlannerAssignmentsProvider._internal(
        (ref) => create(ref as PlannerAssignmentsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        start: start,
        end: end,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _PlannerAssignmentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlannerAssignmentsProvider &&
        other.start == start &&
        other.end == end;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, start.hashCode);
    hash = _SystemHash.combine(hash, end.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PlannerAssignmentsRef
    on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `start` of this provider.
  DateTime get start;

  /// The parameter `end` of this provider.
  DateTime get end;
}

class _PlannerAssignmentsProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with PlannerAssignmentsRef {
  _PlannerAssignmentsProviderElement(super.provider);

  @override
  DateTime get start => (origin as PlannerAssignmentsProvider).start;
  @override
  DateTime get end => (origin as PlannerAssignmentsProvider).end;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
