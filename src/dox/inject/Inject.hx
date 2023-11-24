package dox.inject;

#if macro
import haxe.macro.Type.AbstractType;
import haxe.macro.Type.EnumType;
import haxe.macro.Type.DefType;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type.ClassType;
import haxe.macro.Type.ModuleType;
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
	public static macro function apply(docsPath:String):Array<Field> {
		// The target class. We can add new properties to this class.
		var cls:ClassType = Context.getLocalClass().get();
		// The fields of the target class.
		var fields:Array<Field> = Context.getBuildFields();
		// Context.info('Performing injection (class ${cls.pack.join('.')}.${cls.name}, ${docsPath})', Context.currentPos());
		Sys.print('Performing injection (class ${cls.pack.join('.')}.${cls.name}, ${docsPath})');

		// Apply the documentation to the class and its fields.
		var reader:ClassDocsReader = new ClassDocsReader(docsPath);
		applyFieldDocsToClass(cls, fields, reader);

		// Return the modified fields.
		return fields;
	}

	static function applyFieldDocsToClass(cls:ClassType, fields:Array<Field>, reader:ClassDocsReader):Void {
		var classPackage:Array<String> = cls.pack;
		var className:String = cls.name;

		var classDocs:Null<ClassDocs> = reader.parseClassDocs(classPackage, className);

		if (classDocs == null) return;

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
	#end
}
