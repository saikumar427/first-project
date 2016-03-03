
 function InitControlWidget(questionjson,elmid)
  {   
      questionjson.Id='q_'+elmid; 
      questionjson.txtValue=''; 
      var ctrlType=questionjson.type;
       var objWidget='';
    	if(ctrlType == 'text')
 		objWidget = new BuildTextBoxCtrl(questionjson);
 	else if(ctrlType == 'textarea')
 		objWidget = new BuildTextareaCtrl(questionjson);
 	else if(ctrlType == 'select')
 		objWidget = new BuildSelectCtrl(questionjson);
 	else if(ctrlType == 'radio'){
 		objWidget = new BuildRadioCtrl(questionjson);
		 		}
 	else if(ctrlType == 'checkbox'){
 		objWidget = new BuildCheckboxCtrl(questionjson);
 		
 }
  
      objWidget.SetCtrlData(questionjson);
	  if(document.getElementById(elmid))
      document.getElementById(elmid).appendChild(objWidget.GetContainer());
      if(typeof(responsesdata[elmid])!='undefined')
      objWidget.SetValue(responsesdata[elmid]);

 	return objWidget;
 }
