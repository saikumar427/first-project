function getAllWidgets(widgetId, obj, idArray,eid){ 
	var html = '';
	$.each(idArray, function(key, object){
		for(var mKey in object){
				var date1 = new Date();
				
				var text = mKey.slice(0,5);
				/* .textWidgetImg for : if any image in text widget set img width as 100% */
				if('text_'==text){
					html = '<div id="'+mKey+'" class="textWidgetImg">'+'</div>'; 	
				}else{
					html = '<div id="'+mKey+'">'+'</div>'; 	
				}
				
				//html = '<div id="'+mKey+'">'+'</div>';
				$('#'+widgetId).append(html);
				var widgetHtml = obj[mKey];
				$('#'+mKey).html(widgetHtml);
		}
	});
}

var printtickets = function(){
	$("#forPrint .PrintDelete").hide();
	var mode = 'iframe'; //popup
    var close = mode == "popup";
    var options = { mode : mode, popClose : close};
    $("div#forPrint").printArea( options );
    $("#forPrint .PrintDelete").show();
};

/*
function VoucherSourcetoPrint() {
	return "<html><head><script>function step1(){\n" +
			"setTimeout('step2()', 10);}\n" +
			"function step2(){window.print();window.close()}\n" +
			"</scri" + "pt></head><body onload='step1()'>\n" +
			"<img src='http://www.eventbee.com/home/images/poweredby.jpg' /></body></html>";
}

var printtickets = function(){
	var eventTitle = $('#eventTitle').html();
	eventTitle = eventTitle.split("-")[0];
	$("#forPrint .PrintDelete").hide();
	var divContents = $("#forPrint").html();
	$("#forPrint .PrintDelete").show();
    var printWindow = window.open('', '', 'height=650,width=900');
    printWindow.document.write('<html><head><title>'+eventTitle+'</title>');
    printWindow.document.write('</head><body >');
    printWindow.document.write('<pre><code>'+divContents+'</code></pre>');
    printWindow.document.write(VoucherSourcetoPrint());
    printWindow.document.write('</body></html>');
    printWindow.document.close();
    printWindow.print();
    
};*/


