/*

*/

(
var folder = "~/Documents/sound-sketch/sc/lessons";
var files;
var window;
var list;

folder = folder.standardizePath;

files = PathName(folder)
	.files // ファイル一覧を取得
	.select({ |file| file.extension == "scd" }) // scdファイルのみにフィルターする
	.collect({ |file| file.fileName })
	.sort; // 昇順に並び替える

window = Window("sound-sketch", Rect(100, 100, 300, 400));

list = ListView(window, Rect(10, 10, 280, 380))
	.items_(files) // 取得したファイルのリストを表示
	.action_({ |view| // view = クリックされた要素
		var fileName = files[view.value]; // viewのうち、ファイル番号
		Document.open(folder +/+ fileName); // ファイル番号からファイルを開く
	});

window.front;
)