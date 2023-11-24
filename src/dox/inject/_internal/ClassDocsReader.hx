package dox.inject._internal;

import dox.inject._internal.schema.ClassDocs;

class ClassDocsReader {
	var baseDir:String;

	public function new(baseDir:String) {
		this.baseDir = baseDir;
	}

	public function parseClassDocs(pack:Array<String>, name:String):Null<ClassDocs> {
        var path:String = haxe.io.Path.join([baseDir, pack.join('/'), '${name}.json']);

		if (!sys.FileSystem.exists(path)) {
			#if macro
			haxe.macro.Context.warning('Cannot locate ClassDocs JSON: ${path}', haxe.macro.Context.currentPos());
			return null;
			#else
			return null;
			#end
		}

        var contents:String = sys.io.File.getContent(path);

		// You can't use json2object in macros (cries)

		try {
			var valueDynamic:Dynamic = haxe.Json.parse(contents);
			return valueDynamic;
		} catch (e) {
			#if macro
			haxe.macro.Context.error('Cannot parse ClassDocs JSON: ${e}', haxe.macro.Context.currentPos());
			#end
			return null;
		}
	}
}
