package;

import haxe.Json;
import haxe.io.Path;
import neko.Lib;
import sys.FileSystem;
import sys.io.File;

/**
 * ...
 * @author YellowAfterlife
 */
class Main {
	static function patchRec(dir:String, val:Any, depth:Int):Any {
		if (++depth >= 128) return val;
		if (val is Array) {
			var arr:Array<Any> = val;
			for (i => v0 in arr) {
				var v1 = patchRec(dir, v0, depth);
				if (v0 != v1) arr[i] = v1;
			}
			return arr;
		}
		if (Reflect.isObject(val)) {
			if (Reflect.hasField(val, "include")) {
				return load(Path.join([dir, (val:{include:String}).include]));
			}
			for (field in Reflect.fields(val)) {
				var v0 = Reflect.field(val, field);
				var v1 = patchRec(dir, v0, depth);
				if (v0 != v1) Reflect.setField(val, field, v1);
			}
		}
		return val;
	}
	static function load(path:String) {
		if (!FileSystem.exists(path)) {
			Sys.println('File "$path" does not exist');
			return null;
		}
		
		var text = try {
			File.getContent(path);
		} catch (x:Dynamic) {
			Sys.println('Could not read file "$path"');
			return null;
		}
		
		var ext = Path.extension(path);
		var root:Any;
		switch (ext.toLowerCase()) {
			case "json":
				root = Json.parse(text);
			//case "yaml":
			//	root = Yaml.parse(text);
			default:
				Sys.println('Unknown file type "$ext" for "$path"');
				return null;
		}
		
		var dir = Path.directory(path);
		root = patchRec(dir, root, 0);
		return root;
	}
	
	static function main() {
		var args = Sys.args();
		if (args.length < 2) {
			Sys.println("Howto: LibraryCompiler input.json output.json");
			//Sys.println("(also accepts YAML for input)");
			return;
		}
		var inPath = args[0];
		var outPath = args[1];
		var json = load(inPath);
		File.saveContent(outPath, Json.stringify(json, null, "\t"));
	}
}