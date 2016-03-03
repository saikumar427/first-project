function BuildTextareaCtrl(ControlData){
	var lblText='';
	var txtBoxid='';
	var txtBoxValue='';
	var errorMsg='';
	var className='';
	this.SetRequired = function(req){
		if(req=='Y')
			_labelTD.appendChild(_errorSpan);
	}

	this.SetlblText = function(labelText){
		lblText = labelText;
		spannode.innerHTML = lblText;
	}
	this.GetlblText = function(){
		return lblText;
	}
	this.SetValue = function(textValue){
		txtBoxValue = textValue;
		_textarea.value=txtBoxValue;
	}
	this.GetValue = function(){
		return _textarea.value;
	}
	this.SetErrorMsg = function(ctrlErrMsg){
		errorMsg = ctrlErrMsg
		_errorTD.innerHTML = errorMsg
	}
	this.GetErrorMsg = function(){
		return errorMsg;
	}
	this.SetCtrlData = function(ctrlData,ctrlType){
		this.SetlblText(ctrlData['lblText']);
		this.SetRequired(ctrlData['Required']);
		this.SetValue(ctrlData['txtValue']);
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
	var spannode 	= document.createElement("span");
	var _label		= document.createElement("label");
	var _textarea	= document.createElement("textarea");
	var _errorDIV	= document.createElement("DIV");
	_textarea.setAttribute("rows",ControlData['rows'] );
	_textarea.setAttribute("cols",ControlData['cols'] );
	
	var _errorSpan  = document.createElement("span");
	//_errorSpan.style.color = ControlData['StarColor'];
	_errorSpan.innerHTML = " *"
	_textarea.id	= ControlData['Id'];
	_textarea.name	= ControlData['Id'];
	_labelTD.setAttribute("align","left");
	_labelTD.setAttribute("vAlign","top");
	_controlTD.setAttribute("align","left");
	_controlTD.setAttribute("vAlign","top");
	_labelTD.appendChild(spannode);
	if (ControlData['DisplayStyle'] == "5")
	{
		_labelTD.setAttribute("width","50%");
		_controlTD.setAttribute("width","50%");
		_ctrlTR.appendChild(_labelTD);
	}
	else if ((ControlData['DisplayStyle'] == "6")  || (typeof(ControlData['DisplayStyle'])) == "undefined" || ControlData['DisplayStyle'] == "")
	{
		_labelTD.setAttribute("width","100%");
		_controlTD.setAttribute("width","100%");
		var _lblTR = document.createElement("TR");
		_lblTR.appendChild(_labelTD);
		_ctrlTbody.appendChild(_lblTR);
		_controlTD.setAttribute("colSpan",2);
	}
	_controlTD.appendChild(_textarea);
	_ctrlTR.appendChild(_controlTD);
	_ctrlTbody.appendChild(_ctrlTR);
	_ctrlTable.appendChild(_ctrlTbody);
	_container.appendChild(_ctrlTable);

	this.Validate = function()
	{
		var status = false;
		if((ControlData['Required'] == 'N') || (typeof(ControlData['Required'])) == 'undefined')
		{
			status = true;
		}
		else
		{
			var txtValue = this.GetValue();
			txtValue = txtValue.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
			if(txtValue == '')
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
				if(_errorTR.hasChildNodes())
				{
					_errorTR.removeChild(_errorTD);
					_labelTD.removeChild(_errorDIV);
				}
				status = true;
			}
		}
		return status;
	}
	this.GetContainer = function()
	{ 
		return _container; 
	}
}