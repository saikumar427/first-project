/* sendMyticketMail for My Tickets widget Start */
function sendMyticketMail(tid,eid,token){
	jQuery(".mailSendSuccess").hide();
	jQuery(".mailSendError").hide();
	var url="/customevents/buyerPageCheck.jsp?tid="+tid+'&eid='+eid+'&token='+token;
	$.ajax({
		type:'POST',
		url:url,
		success:function(result){
			var res=JSON.parse(result);
			if(res.status=='success'){
				var urlMail="/main/user/mytickets!getTransactionId?transaction_id="+tid;
				jQuery.ajax({
					type:"POST",
					url:urlMail,
					success:function(id){
						if(id.indexOf("success")>-1){
							jQuery(".mailSendSuccess").show();
							jQuery("#sendMailDescrip").hide();
							jQuery("#sendMail").hide();
						}else{
							jQuery(".mailSendError").show();
						}
					},
					error:function(){
						//alert("error");
						//jQuery('#mailSendError').show();
					}
				});
			}else{
				jQuery(".mailSendError").show();
			}
		},
		error:function(){
			//alert('error');
		}
	});
		
}
/* sendMyticketMail for My Tickets widget End */

/*File widget build start*/
function fileWidgetBuild(data,eid){
	var htmlFile='';
	var file_data = data.files;
	$.each(file_data, function(key,value){
		if('def_widget_options'==value.type){
			//from def_widget_options
		}else{
			htmlFile+='<div class="col-md-12 col-sm-12 ">';
			htmlFile+='<div class="col-md-12 col-sm-12 row"><b>'+value.filename+'</b></div>';
			htmlFile+='<div><div class="col-md-10 col-sm-10 row">'+value.filedesc+'</div>';
			htmlFile+='<div class="col-md-2 col-sm-2 row">';
			htmlFile+='<a href="/customevents/filedownload.jsp?code='+value.fileid+'&fileName='+value.filename+'&extension='+value.extension+'" class="btn btn-sm btn-primary" title="Download" >';
			htmlFile+='<i class="glyphicon glyphicon-download-alt" ></i></a></div></div>';
			htmlFile+='<div class="col-md-12 col-sm-12 row"><hr></div>';
			htmlFile+='</div>';
		}
	});
	$('#filesImp').html(htmlFile);
}
/*File widget build end*/

/*status message success or error start */
function notification(message, type) {
    var html = '<div class="alert alert-' + type + ' alert-dismissable page-alert" style="margin-bottom:15px;text-align: left;">';    
    html += '<button type="button" class="close close-notification-bottom"><span aria-hidden="true">x</span></button>';
    html += message;
    html += '</div>';    
    var htmlObject=$.parseHTML(html);
    $("#notification-holder-bottom").show();
    $(htmlObject).hide().prependTo('#notification-holder-bottom').slideDown();
    setTimeout(function(){
    	$(htmlObject).remove();
    },5000);
};

$(document).on("click",".close-notification-bottom",function(){
	$("#notification-holder-bottom").slideUp();
	$("#notification-holder-bottom").remove();
});
/*status message success or error stop */
