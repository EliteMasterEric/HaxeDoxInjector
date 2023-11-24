# Haxe Dox Injector

A library which provides a macro to inject documentation into Haxe classes from JSON data.

## Installation

Install via Haxelib:

```
# Release

# Development
haxelib git haxe-dox-injector 
```

## Usage

Apply the macro. For example, this build script will inject documentation into `test.MyClassTwo` from `docs/test/MyClassTwo.json`.

```
# build.hxml
--library haxe-dox-injector

# Apply to a single class...
--macro addMetadata('@:build(dox.inject.Inject.apply("docs/"))', 'test.MyClassTwo')

# ...or to a whole package.
--macro addGlobalMetadata('test', '@:build(dox.inject.Inject.apply("docs/"))', true, true, true)
```

```json
// docs/test/MyClassTwo.json
{
  "classDoc": "This applies documentation on the class `MyClassTwo`",
  "fieldDocs": [
    {
      "name": "myField",
      "doc": "This applies documentation on the field `MyClassTwo#myField`"
    }
  ]
}
```

## License

Haxe Dox Injector is made available under the MIT License.