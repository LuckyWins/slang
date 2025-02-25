import 'package:collection/collection.dart';

final _setEquality = SetEquality();

/// The config from build.yaml
class InterfaceConfig {
  final String name;
  final Set<InterfaceAttribute> attributes;
  final List<InterfacePath> paths;

  InterfaceConfig({
    required this.name,
    required this.attributes,
    required this.paths,
  });
}

class InterfacePath {
  final String path;

  /// true, if the path ends with '.*', all children have the same interface
  /// false, otherwise, i.e. this path itself will get an interface
  final bool isContainer;

  InterfacePath(String path)
      : path = path.replaceAll('.*', ''),
        isContainer = path.endsWith('.*');
}

/// The interface model used for generation
/// equals and hash are only dependent on attributes
class Interface {
  final String name;
  final Set<InterfaceAttribute> attributes;

  /// True, if at least one attribute is a list
  final bool hasLists;

  Interface({required this.name, required this.attributes})
      : hasLists = attributes.any((a) => a.returnType.startsWith('List<'));

  @override
  int get hashCode {
    return _setEquality.hash(attributes);
  }

  @override
  bool operator ==(Object other) {
    return other is Interface && equalAttributes(attributes, other.attributes);
  }

  @override
  String toString() {
    return '$name [${attributes.join(', ')}]';
  }

  static bool equalAttributes(
    Set<InterfaceAttribute> a,
    Set<InterfaceAttribute> b,
  ) {
    return _setEquality.equals(a, b);
  }

  /// True if,
  /// every non-optional attribute in [requiredSet] also exists in [testSet].
  /// every optional attribute in [requiredSet] which also exist in [testSet] must have the same signature.
  static bool satisfyRequiredSet({
    required Set<InterfaceAttribute> requiredSet,
    required Set<InterfaceAttribute> testSet,
  }) {
    for (final attribute in requiredSet) {
      if (attribute.optional) {
        for (final testAttribute in testSet) {
          if (attribute.attributeName == testAttribute.attributeName) {
            if (attribute.returnType != testAttribute.returnType ||
                !_setEquality.equals(
                    attribute.parameters, testAttribute.parameters)) {
              // this optional attribute also exists in testSet but with a different signature
              return false;
            }
            break;
          }
        }
      } else if (!testSet.contains(attribute)) {
        // this non-optional attribute does not exist in testSet
        return false;
      }
    }
    return true;
  }
}

class InterfaceAttribute {
  final String attributeName;
  final String returnType;
  final Set<AttributeParameter> parameters;
  final bool optional;

  InterfaceAttribute({
    required this.attributeName,
    required this.returnType,
    required this.parameters,
    required this.optional,
  });

  @override
  int get hashCode {
    return attributeName.hashCode *
        returnType.hashCode *
        _setEquality.hash(parameters) *
        optional.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return other is InterfaceAttribute &&
        attributeName == other.attributeName &&
        returnType == other.returnType &&
        _setEquality.equals(parameters, other.parameters) &&
        optional == other.optional;
  }

  @override
  String toString() {
    return '$returnType${optional ? '?' : ''} $attributeName${parameters.isNotEmpty ? '(' + parameters.join(', ') + ')' : ''}';
  }
}

class AttributeParameter {
  final String parameterName;
  final String type;

  AttributeParameter({required this.parameterName, required this.type});

  @override
  int get hashCode {
    return parameterName.hashCode * type.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return other is AttributeParameter &&
        parameterName == other.parameterName &&
        type == other.type;
  }

  @override
  String toString() {
    return '$type $parameterName';
  }
}

extension InterfaceConfigExt on InterfaceConfig {
  Interface toInterface() {
    return Interface(name: name, attributes: attributes);
  }
}

/// Interface collection defined in build.yaml + detected in a locale
class InterfaceCollection {
  // FINAL!
  // Interfaces with no specified path
  // will be applied globally
  final Set<Interface> globalInterfaces;

  // MODIFIABLE!
  // Interface Name -> Interface
  // This may be smaller than [pathInterfaceNameMap] because the user may
  // specify an interface without attributes - in this case the interface
  // will be determined (i.e. created afterwards).
  final Map<String, Interface> nameInterfaceMap;

  // FINAL!
  // Path -> Interface Name (all children of this path)
  final Map<String, String> pathInterfaceContainerMap;

  // FINAL!
  // Path -> Interface Name (the node at this path itself)
  final Map<String, String> pathInterfaceNameMap;

  InterfaceCollection({
    required this.globalInterfaces,
    required this.nameInterfaceMap,
    required this.pathInterfaceContainerMap,
    required this.pathInterfaceNameMap,
  });
}
