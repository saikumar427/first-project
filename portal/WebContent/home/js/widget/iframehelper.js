
var demodfactor=-1;
var inmodfactor=-1;
function generateIFrames(){
var height = Element.getDimensions($("leftList")).height
var newInner = '';
if (height != oldHeight || oldScrollIframe != scrollIframe) {
if(inmodfactor==(height-oldHeight))
return;
if(document.getElementById("generatedIFrames") && (height-oldHeight)>0)
{
var a=Math.round(oldHeight/21);
var b=Math.round(height/21);
for (var i = a; i <b; i++) {
newInner = '<iframe id ="f_'+i+'"  style="border: 0; margin: 0; padding: 0; height: 0; width: 0;"></iframe>\n';
jQuery("#generatedIFrames").prepend(newInner);
}
inmodfactor=(height-oldHeight);
oldHeight = height;
oldScrollIframe = scrollIframe;
}
else if(document.getElementById("generatedIFrames") && (oldHeight-height)>0){
if(demodfactor==(height-oldHeight))
return;
var a=Math.round(oldHeight/21);
var b=Math.round(height/21);
for (var i = a; i >= b; i--) {
var rk=jQuery("#f_"+i);
rk.remove();
}

oldHeight = height;
oldScrollIframe = scrollIframe;
demodfactor=(height-oldHeight);
}
}
}