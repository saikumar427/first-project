function BuildRadioCtrl(ControlData){
	var lblText='';
	var txtBoxid='';
	var chkIndex='';
	var errorMsg='';
	var className='';
	this.SetRequired = function(req){
		if(req=='Y')
			_labelTD.appendChild(_errorSpan);
	}
	this.SetlblText = function(labelText){
		lblText = labelText;
		_labelTD.innerHTML = lblText;
	}
	this.GetlblText = function(){
		return lblText;
	}
	this.SetErrorMsg = function(ctrlErrMsg){
		errorMsg = ctrlErrMsg
		_errorTD.innerHTML = errorMsg
	}
	this.GetErrorMsg = function(){
		return errorMsg;
	}

	this.SetValue = function(selValue){
		for(var rbtCount=0;rbtCount<ControlData['Options'].length;rbtCount++)
		{
			if(ControlData['Options'][rbtCount].Value == selValue)
			{
				var _rbtCtrl = document.getElementById(ControlData['Id']+'_'+rbtCount);
				_rbtCtrl.checked = true;
			}
		}
	}
	this.GetValue = function(){
		/************************************************************************************************************/
		/*****************************this will return selected radio button index.**********************************/
		/************************************************************************************************************/
		var selectedValue ='';
		for(var rbtCount=0;rbtCount<ControlData['Options'].length;rbtCount++)
		{
			var rbtValue = document.getElementById(ControlData['Id']+'_'+rbtCount);
			if(rbtValue.checked)
			{
				selectedValue = rbtValue.value;
			}
		}
		return selectedValue;
	}
	
	this.SetCtrlData = function(ctrlData,ctrlType){
		this.SetlblText(ctrlData['lblText']);
		this.SetRequired(ctrlData['Required']);
		this.SetErrorMsg(ctrlData['ErrorMsg']);
	}

	var _container	= document.createElement("DIV");	
	var _ctrlTable	= document.createElement("TABLE");
	_ctrlTable.setAttribute("width","100%");
	var _ctrlTbody	= document.createElement("tbody");
	var _ctrlTR		= document.createElement("TR");
	var _labelTD	= document.createElement("TD");
	var _controlTD	= document.createElement("TD");
	var _errorTR	= document.createElement("TR");
	var _errorTD	= document.createElement("TD");
	var _errorDIV	= document.createElement("DIV");
	_labelTD.setAttribute("align","left");
	_labelTD.setAttribute("vAlign","top");
	_controlTD.setAttribute("align","left");
	_controlTD.setAttribute("vAlign","top");

	var _errorSpan  = document.createElement("span");
	//_errorSpan.style.color = ControlData['StarColor'];
	_errorSpan.innerHTML = " *"
	var checkedIndex = ControlData['CheckedIndex'];
	this.displayHorizontal = function(){
		for(var rbtCount=0;rbtCount<ControlData['Options'].length;rbtCount++)
		{
			var _rbtlblTD				= document.createElement("TD");
			var _rbtCtrlTD				= document.createElement("TD");
			var _radiobutton = '';
			try{
				_radiobutton = document.createElement('<input type="radio" name='+ControlData['Id']+'/>');
			}catch(err){
				_radiobutton = document.createElement('input');
			}
			_radiobutton.setAttribute('type','radio');  
		    _radiobutton.setAttribute('name',ControlData['Id']);   
			_radiobutton.id				= ControlData['Id']+'_'+rbtCount;
			_radiobutton.value			= ControlData['Options'][rbtCount].Value;
			if(checkedIndex!='')
			{
				if(checkedIndex==rbtCount)
				{
					_radiobutton.defaultChecked = true;
				}
			}
			var spannode 	= document.createElement("span");
			spannode.innerHTML = ControlData['Options'][rbtCount].Display;
			_rbtCtrlTD.appendChild(_radiobutton);
			_rbtCtrlTD.appendChild(spannode);
			_ctrlTR.appendChild(_rbtCtrlTD);
		}
	}
	this.displayVertical = function(){
		var _vTbody		= document.createElement("tbody");
		for(var rbtCount=0;rbtCount<ControlData['Options'].length;rbtCount++)
		{
			var _rbtlblTD		= document.createElement("TD");
			var _rbtCtrlTD		= document.createElement("TD");
			var _vTr			= document.createElement("TR");
			try{
				_radiobutton = document.createElement('<input type="radio" name='+ControlData['Id']+'/>');
			}catch(err){
				_radiobutton = document.createElement('input');
			}
			_radiobutton.type			= "radio";	
			_radiobutton.id				= ControlData['Id']+'_'+rbtCount;
			_radiobutton.name			= ControlData['Id']
			_radiobutton.value			= ControlData['Options'][rbtCount].Value;
					
			if(checkedIndex!='')
			{
				if(checkedIndex==rbtCount)
				{
					_radiobutton.defaultChecked = true;
				}
			}
			var spannode 	= document.createElement("span");
			spannode.innerHTML = ControlData['Options'][rbtCount].Display;
			_rbtCtrlTD.appendChild(_radiobutton);
			_rbtCtrlTD.appendChild(spannode);
			_vTr.appendChild(_rbtCtrlTD);
			_vTbody.appendChild(_vTr);
		}
		_vTable.appendChild(_vTbody);
	}

	if (ControlData['DisplayStyle']=='1')
	{
		_labelTD.setAttribute("width","50%");
		_ctrlTR.appendChild(_labelTD);
		this.displayHorizontal();
	}
	else if (ControlData['DisplayStyle']=='2') 
	{
		_labelTD.setAttribute("width","50%");
		_controlTD.setAttribute("width","50%");
		_ctrlTR.appendChild(_labelTD);
		var _vTable		= document.createElement("TABLE");
		this.displayVertical();
		_controlTD.appendChild(_vTable);
		_ctrlTR.appendChild(_controlTD);
	}
	else if (ControlData['DisplayStyle']=='3')
	{
		_labelTD.setAttribute("width","100%");
		var _labelTR	= document.createElement("TR");
		var cSpan = ControlData['Options'].length;
		_labelTR.appendChild(_labelTD);
		_labelTD.setAttribute("colSpan", cSpan);
		_ctrlTbody.appendChild(_labelTR);
		this.displayHorizontal();
	}
	else if ((ControlData['DisplayStyle']=='4') || (typeof(ControlData['DisplayStyle'])) == 'undefined' || ControlData['DisplayStyle']=='')
	{ 

		_labelTD.setAttribute("width","100%");
		_controlTD.setAttribute("width","100%");
		var _labelTR	= document.createElement("TR");
		var cSpan = ControlData['Options'].length;
		_labelTR.appendChild(_labelTD);
		_labelTD.setAttribute("colSpan", cSpan);
		var _vTable		= document.createElement("TABLE");
		this.displayVertical();
			
		_controlTD.appendChild(_vTable);
		_ctrlTR.appendChild(_controlTD);
		_ctrlTbody.appendChild(_labelTR);
	
	}
	_ctrlTbody.appendChild(_ctrlTR);
	_ctrlTable.appendChild(_ctrlTbody);
	_container.appendChild(_ctrlTable);
   
	this.Validate = function(){
		var status = false;
		if((ControlData['Required'] == 'N') || (typeof(ControlData['Required'])) == 'undefined')
		{
			status = true;
		}
		else
		{
			var selectedValue = this.GetValue();
			if (selectedValue == '')
			{
				_errorTD.style.color='red';
				_errorTD.setAttribute("colSpan",2);
				_errorTR.appendChild(_errorTD);
				_errorDIV.style.color='red';
				_errorDIV.innerHTML = _errorTD.innerHTML;
				_labelTD.appendChild(_errorDIV);
				//_ctrlTbody.appendChild(_errorDIV);
				//_ctrlTbody.appendChild(_errorTR);
				_ctrlTable.appendChild(_ctrlTbody);
				_container.appendChild(_ctrlTable);
			}
			else
			{
				if(_errorTR.hasChildNodes()){
					_errorTR.removeChild(_errorTD);
					_labelTD.removeChild(_errorDIV);
				}
				status = true;
			}
		}
		return status;
	}
	this.GetContainer = function(){ 
		return _container; 
	}
}