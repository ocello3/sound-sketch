~w.onClose = {
	CmdPeriod.run; // windowを閉じた時にCmd + .を実行して全て停止する
};

~w.alwaysOnTop = true; // windowを最前面に固定する