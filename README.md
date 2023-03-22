# Terrasavr's standard item library

[Terrasavr+](https://yal.cc/r/terrasavr/plus/) supports user-created item libraries.

This repository contains the standard library
(the one that you get by pressing "Load standard")
and a simple pre-processor application to make writing these easier.

## Structure

(check out [example.json](example.json) for a complete example)

```json
{
	"resourceType": "TerrasavrLibrary",
	"resourceVersion": "1.0",
	"content": node
}
```
where `node` can be...

### "text"

Inserts a snippet of text. Line breaks (`\n`) will be converted to `<br/>` automatically.

### { "href": "https://...", "text": "..." }

Inserts a link, can be surrounded by text.

Supported protocols are HTTP and HTTPS.

### \[...nodes]

Zero or more nodes that'll be put in a `<div>`.

### { "summary": "..." }

A collapsible category. Supported properties are:

- `summary`: Shown in the collapsible header.
- `item`: a numeric item ID (e.g. `217`) or Persistent ID (`"MoltenHamaxe"`) to use for an icon next to the category name.
- `content`: a node to show inside the category.  
  Good for lengthy explanations. Incompatible with item filters.
- `items`: an array of item IDs/PIDs to include in the category.
- `pidMatches`: adds all items whose PID matches the provided regular expression string (like `"Dye$"`).
- `tagsContain`: adds all items whose tags contain the given string.  
  Mostly used for standard auto-categories. Find tags in [dataset.json](https://yal.cc/r/terrasavr/beta/data/dataset.json).
- `excludeItems`: an array of item IDs/PIDs to _exclude_ from the category.  
  Used with above to filter unwanted items (such as Potion Statue when matching potions by PID).
- `excludePidMatches`: like `pidMatches`, but excludes the items instead.

Notes: 

- Item inclusions (array/tag/PID match) add up together before running item exclusions.
- Empty spots can be represented with a blank item (`null`, `0`, or `"None"`).
- Item collections are padded with empty items to the nearest multiplier of 10 because

For example,
```json
{
	"summary": "Some eggs for these trying times",
	"items": [
		"LizardEgg",
		"SpiderEgg",
		"RottenEgg",
		"BlueEgg"
	]
}
```

### null
Ignored and not added anywhere, allowing to use it instead of wiggling the trailing comma.

## LibraryCompiler

Writing a library in one big JSON file can be a bit of an inconenience so I conceived a small pre-processor that introduces a new node type
```json
{ "include": "path.json" }
```
which will replace the node with the contents of the said JSON file (path being relative to the original). I'm just recursively traversing the JSON object so you can insert these wherever you want. Also it doesn't check for cyclical references so try not to do that.

You can compile it with [Haxe](https://haxe.org) like so:
```ps
haxe build.hxml
```
and then run it like
```ps
neko bin/LibraryCompiler.n std/index.json bin/standardLibrary.json
```

## Standard library

The standard library consists from auto-generated categories (such as hooks or fishing items - where possible) and some hand-made ones (such as equipment made from various metals and arranged into convenient grids).

Hand-made categories primarily date to 2016 or whenever was the last time when I did a full playthrough of the game, so there's likely space for improvement there.

You can fork the repository, add some missing things, and submit a pull request.
