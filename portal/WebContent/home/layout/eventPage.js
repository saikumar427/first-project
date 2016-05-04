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