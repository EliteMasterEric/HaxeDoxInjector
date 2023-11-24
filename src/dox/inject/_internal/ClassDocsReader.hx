package dox.inject._internal;

import dox.inject._internal.schema.ClassDocs;

class ClassDocsReader {
	var baseDir:String;

	public function new(baseDir:String) {
		this.baseDir = baseDir;
	}

	public function parseClassDocs(pack:Array<String>, name:String):ClassDocs {
        var path:String = '${baseDir}/${pack.join('/')}/${name}.json';

        var contents:String = sys.io.File.getContent(path);

		// You can't use json2object in macros (cries)

		try {
			var valueDynamic:Dynamic = haxe.Json.parse(contents);
			return valueDynamic;
		} catch (e) {
			#if macro
			haxe.macro.Context.error('Error parsing ClassDocs JSON: ${e}', haxe.macro.Context.currentPos());
			#end
			return null;
		}
	}
}
