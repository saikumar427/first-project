
var gPopupIsShown = false;
var gTabIndexes = new Array();
var gTabbableTags = new Array("A","BUTTON","TEXTAREA","INPUT","IFRAME");
if (!document.all) {
	document.onkeypress = keyDownHandler;
}	

function disableTabIndexes() {
	if (document.all) {
		var i = 0;
		for (var j = 0; j < gTabbableTags.length; j++) {
			var tagElements = document.getElementsByTagName(gTabbableTags[j]);
			for (var k = 0 ; k < tagElements.length; k++) {
				gTabIndexes[i] = tagElements[k].tabIndex;
				tagElements[k].tabIndex = "-1";
				i++;
			}
		}
	}
}


function keyDownHandler(e) {
    if (gPopupIsShown && e.keyCode == 9)  return false;
}