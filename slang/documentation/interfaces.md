# Interfaces

## Motivation

Often, multiple maps have the same structure. You can create a common super class for that. This allows you to write cleaner code.

```json
{
  "onboarding": {
    "whatsNew": {
      "v2": {
        "title": "New in 2.0",
        "rows": [
          "Add sync"
        ]
      },
      "v3": {
        "title": "New in 3.0",
        "rows": [
          "New game modes",
          "And a lot more!"
        ]
      }
    }
  }
}
```

The generated mixin may look like this:

```dart
mixin ChangeData {
  String get title;
  List<String> get rows;
}
```

## Configuration

### Example (most explicit version)

```yaml
# Config
interfaces:
  MyInterface:
    paths:
      - onboarding.whatsNew.*
    attributes:
      - String title
      - String content
```

### Paths

You can either specify one node or all children of one parent.

Example|Description
---|---
`onboarding.firstPage`|single node
`onboarding.pages.*`|all children (non-recursive)

```json5
{
  "onboarding": {
    "firstPage": {
      "title": "hi",
      "content": "hi"
    },
    pages: [
      {
        "title": "hi",
        "content": "hi"
      },
      {
        "title": "hi",
        "content": "hi"
      },
      {
        "title": "hi",
        "content": "hi"
      }
    ]
  }
}
```

### Attributes

Attributes can be specified in multiple ways.

Example|Description
---|---
`String title`|simple version
`String greet(firstName, lastName)`|with parameters
`String? greet(firstName, lastName)`|optional
`List<Feature> features`|list of another interface

## Configuration Modes

### Summary

Mode|Description
---|---
single path|**One** node; `<interface>: <path>`; Attributes will be **detected** automatically
`paths` only|**Multiple** nodes; Attributes will be **detected** automatically
`attributes` only|**All** nodes satisfying `attributes` will get the **predefined** interface.
both|**Multiple** nodes will get the **predefined** interface

### Single Path

Use this, if you want to target one node.

```yaml
# Config
interfaces:
  MyInterface: a.c.* # all children of c (non-recursive)
```

### Multiple Paths

Use this, if you want to target multiple translations.

All nodes should only have the **same mandatory** parameters. Otherwise unexpected things may occur.

```yaml
# Config
interfaces:
  MyInterface:
    paths:
      - a.b # single node
      - a.c.* # all children of c (non-recursive)
```

### Attributes Only

Use this, if your selected translations are spread across the file.

```yaml
# Config
interfaces:
  MyInterface:
    attributes:
      - String title
      - String content
      - List<String>? features
```

```json5
{
  "a": { // interface applied (all mandatory attributes specified)
    "title": "Title A",
    "content": "Content A"
  },
  "b": { // interface applied (unknown attributes are ignored)
    "title": "Title A",
    "content": "Content A",
    "thirdAttribute": "Hi"
  },
  "c": { // ignored (content missing)
    "title": "Title A",
    "features": [
      "f1",
      "f2"
  },
  "d": [
    { // interface applied
      "title": "Title D1",
      "content": "Content C1"
    },
    { // ignored (content parameter list differs)
      "title": "Title D1",
      "content": "Content C1 $param1"
    }
  ]
}
```

### Paths and Attributes

This is the most explicit configuration.

```yaml
# Config
interfaces:
  MyInterface:
    paths:
      - onboarding.whatsNew.*
    attributes:
      - String title
      - String content
```
