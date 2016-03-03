var ctrlwidget=[];
function putWidgetIdeal(ticketid,qid, profileid){
var elmid=ticketid+'_'+qid+'_'+profileid;
var jsondata=eval('(' + profileJsondata + ')');
var questionjson=jsondata[ticketid+'_'+qid];
var  objWidget = new InitControlWidget(questionjson, elmid);
ctrlwidget.push(elmid);
CtrlWidgets[elmid] = objWidget;
}

