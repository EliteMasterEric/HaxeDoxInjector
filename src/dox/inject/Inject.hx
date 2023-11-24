package dox.inject;

import haxe.display.Display.Package;
#if macro
import haxe.macro.Context;
import haxe.macro.Expr.Position;
import haxe.macro.Type.ClassType;
import haxe.macro.Expr.Field;
#end
import dox.inject._internal.ClassDocsReader;
import dox.inject._internal.schema.ClassDocs;

class Inject {
	#if macro
	/**
	 * Apply with `--macro addMetadata('@:build(dox.inject.Inject.applyToClass(<DOCSPATH>))', <CLASSPATH>)`
	 * @param docsPath The path to the directory containing the documentation files.
	 * @return The fields of the target class.
	 */
	public static macro function applyToClass(docsPath:String):Array<Field> {
		// The target class. We can add new properties to this class.
		var cls:ClassType = Context.getLocalClass().get();
		// The fields of the target class.
		var fields:Array<Field> = Context.getBuildFields();
		Context.info('Performing injection (class ${cls.pack.join('.')}.${cls.name}, ${docsPath})', Context.currentPos());

		// Apply the documentation to the class and its fields.
		var reader:ClassDocsReader = new ClassDocsReader(docsPath);
		applyFieldDocsToClass(cls, fields, reader);

		// Return the modified fields.
		return fields;
	}

	static function applyFieldDocsToClass(cls:ClassType, fields:Array<Field>, reader:ClassDocsReader):Void {
		var classPackage:Array<String> = cls.pack;
		var className:String = cls.name;

		var classDocs:ClassDocs = reader.parseClassDocs(classPackage, className);

		// TODO: Applying documentation to the class itself doesn't seem to work.
		cls.doc = classDocs.classDoc;

		for (fieldDoc in classDocs.fieldDocs) {
			for (field in fields) {
				if (field.name == fieldDoc.name) {
					field.doc = fieldDoc.doc;
				}
			}
		}
	}

	/**
	 * Apply with `--macro dox.inject.Inject.applyToPackage(<DOCSPATH>, <PACKAGE>)`
	 * @param docsPath The path to the directory containing the documentation files.
	 * @param packagePath The package to apply the documentation to.
	 */
	public static function applyToPackage(docsPath:String, packagePath:String):Void {
		Context.onGenerate(function (types:Array<haxe.macro.Types>) {
			for (type in types) {
				switch (type) {
					case TInst(t, params):
						var classType:ClassType = t.get();
						var pack:String = classType.pack.join('.');

						if (pack == packagePath) {
							// Add the metadata to the class.
							target.meta.add(':build', macro dox.inject.Inject.applyToClass($v{docsPath}));
						}
					default:
						Context.info('Skipping dox injection on ${type}', Context.currentPos());
				}
			}
		});
	}
	#end
}
