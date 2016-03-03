function numberWithCommas(x) {
	var temp = parseFloat(x).toFixed(2);
	var parts = temp.toString().split(".");
	parts[0] = parts[0].toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	return parts.join(".");
}

function TicketWedgetControl(tktID)
{  
   var eventId='';
	this.tktID=tktID;
	var ticketName='';
	var ticketPrice='';
	var ticketFee='';
	var ticketStatusMsg='';
	var ticketActualPrice='';
	var ticketChargingPrice='';
	var ticketActualFee='';
	var ticketChargingFee='';
	var ticketProcessFee='';
	var ticketfinalProcessFee='';
	var ticketSelQty='';
	var ticketMinQty='';
	var ticketMaxQty='';
	var ticketIsAvailable='';
	var ticketDesc='';
	var ticketType='';
	var ticketGroupId='';
	var ticketGroupType='';
	var ticketIsMemberTicket='';
	var ticketDonationAmount='';
	var ticketErrorMessage='';
	var ticketIsEnabled='';
	var ticketPositionIndex='';
	var ticketClassName='';
	var ticketGroupId='';
	var ticketSmallDesc='';
	var elementDisplayStatusArray=new Array();
	//var ticketDonationQty=0
	this.SetTicketName = function(tktName){
		ticketName=tktName;
		_labeltktName.innerHTML	= ticketName;
	}
	this.GetTicketName = function(){return ticketName;}
	/*****************************************************************************************************************/
		this.SetActualPrice = function(tktActualPrice){
			ticketActualPrice = tktActualPrice
			//ticketChargingPrice = ticketActualPrice;
			this.SetTicketPrice(ticketActualPrice,ticketChargingPrice);
		}
		this.SetChargingPrice = function(tktChargingPrice){
			ticketChargingPrice = tktChargingPrice;
			this.SetTicketPrice(ticketActualPrice,ticketChargingPrice);
		}
	
		this.SetActualFee = function(tktActualFee){
		 	ticketActualFee = tktActualFee;
			this.SetTicketFee(ticketActualFee,ticketChargingFee);
		}
		this.SetChargingFee = function(tktChargingFee){
			ticketChargingFee = tktChargingFee;
			this.SetTicketFee(ticketActualFee,ticketChargingFee);
		}
	/*****************************************************************************************************************/
	this.SetTicketPrice	= function(tktActualPrice,tktChargingPrice){
		if(tktChargingPrice == '')
			tktChargingPrice = tktActualPrice;
		ticketActualPrice = tktActualPrice;
		ticketChargingPrice = tktChargingPrice;
		if(ticketActualPrice == ticketChargingPrice)
		{
			_labeltktPrice.innerHTML = numberWithCommas(ticketActualPrice);
			_ticketHiddenPrice.value = ticketActualPrice;
			_ticketHiddenFinalPrice.value=ticketActualPrice;
		}
		else
		{
			_labeltktPrice.innerHTML =  "<strike>"+numberWithCommas(ticketActualPrice)+"</strike><br/>"+numberWithCommas(ticketChargingPrice);
			_ticketHiddenFinalPrice.value = ticketChargingPrice;
		}
	}
	
	this.setDonationTicketQty	= function(qty){
	 _donationHiddenQty.value=qty;
	}
	
	this.setDonationPrice	= function(donationAmount){
		 _ticketHiddenPrice.value=donationAmount;
		 _ticketHiddenFinalPrice.value=donationAmount;
	}
	
	this.GetDonationTicketQty	= function(){return _donationHiddenQty.value;}
	
	this.GetTicketPrice	= function(){return ticketActualPrice;}
	this.SetTicketFee = function(tktActualFee,tktChargingFee){
			ticketActualFee = tktActualFee;
			ticketChargingFee = tktChargingFee
			if(ticketActualFee == ticketChargingFee)
			{
				_labeltktFee.innerHTML = numberWithCommas(ticketActualFee);
				_ticketHiddenFee.value = ticketActualFee;
			}
			else
			{
				_labeltktFee.innerHTML = "<strike>"+numberWithCommas(ticketActualFee)+"</strike><br/>"+numberWithCommas(tktChargingFee);
				_ticketHiddenFee.value = tktChargingFee;
			}
	}
	this.GetTicketFee = function(){return 	_labeltktFee.innerHTML;}

	this.SetTicketChargingPrice = function(tktChargingPrice){
		ticketChargingPrice = tktChargingPrice;
	}
	this.GetTicketChargingPrice = function(){return ticketChargingPrice;}

	this.SetTicketStatusMsg = function(tktMsg,tktdata){
		//alert(tktMsg);
		//alert("the tktdata:"+JSON.stringify(tktdata,undefined,2));
		
		if(tktdata.Available=='N' && tktdata.UnavailableType=='SOLDOUT' && tktdata.waitListType=='Y'){
			var tktName=tktdata.Name;
			var waitListLimit=tktdata.waitListLimit;
			//alert(waitListLimit);
			waitListLimit=waitListLimit=='100000'?tktdata.original_max:waitListLimit;
			waitListLimit=waitListLimit>tktdata.original_max?tktdata.original_max:waitListLimit;
			tktMsg=tktsData.TicketDisplayOptions['event.waitlisttickets.statusmessage'];
			var buttonName=tktsData.TicketDisplayOptions['event.waitlisttickets.buttonname'];
			tktName=tktName.replace(/'/g, '\'');
			//tktMsg='<span style="margin-right:10px;">'+tktdata.ActualPrice+'</span><span style="margin-left:55px;"><input type="button" value="'+buttonName+'" onclick="javascript:waitList('+tktID+',\''+tktName+'\','+waitListLimit+');"></span>';
			tktMsg='<table width="100%"><tbody><tr><td width="18%"></td><td width="37%">' +tktdata.ActualPrice+'</td><td><input id="waittkt_'+tktID+'" type="button" data-tktname="'+tktName+'" value="'+buttonName+'" onclick="javascript:waitList('+tktID+','+waitListLimit+');"></td></tr></tbody></table>';
			/*var hiddenElement = document.createElement("input");
			hiddenElement.type='hidden';
			hiddenElement.value=''
			document.getElementById("regform").appendChild(newLink);*/
		
		}
		  ticketStatusMsg = tktMsg;
		_labeltktStatus.innerHTML = ticketStatusMsg;
	}
	this.GetTicketStatusMsg = function(){return ticketStatusMsg;}
	
	this.SetTicketType = function(tktType){
		ticketType = tktType;
		_ticketHiddenType.value=tktType;
	}
	this.GetTicketType = function(){return ticketType;}
	this.SetTicketSmallDesc = function(txtDesc){
	    _spansmallDesc.innerHTML = txtDesc;
	}
	this.SetMemberTicketLogin = function(){
		ticketIsMemberTicket = 'Y';
		ticketSmallDesc = _spansmallDesc.innerHTML;
		if(ticketSmallDesc!="")
			_spansmallDesc.innerHTML = _spansmallDesc.innerHTML + '<br\>* Need Member <a href="#" onclick="javascript:funMemberTicketLogin('+tktID+','+eventId+');">login</a> Login  to buy';
		else
			_spansmallDesc.innerHTML = '* Need Member <a href="#" onclick="javascript:funMemberTicketLogin('+tktID+','+eventId+');">login</a> Login  to buy';
	}
	this.ClearMemberTicketLogin = function(){
		if(ticketIsMemberTicket=='Y')
		{
			_spansmallDesc.innerHTML = ticketSmallDesc;
			_select.disabled	= false;
		}
	}
	this.SetTicketDesc = function(tktDesc,Id){
		if(tktDesc!='undefined')
		{
			ticketDesc = tktDesc
			_labeltktName.innerHTML = _labeltktName.innerHTML + ' <img style="cursor:pointer;width:13px !important" id=imgShowHide'+Id+' src="/home/images/expand.gif" onClick=showDescription('+tktID+');>';
			_ticketDescLabel.innerHTML = ticketDesc;
		}
		//_ticketTable.appendChild(_ticketDescTr);
	}
	this.toggleDescription = function(ticketID){
		var currentExpandstatus=false;
		if(elementDisplayStatusArray['descTR'+ticketID]){
		currentExpandstatus=elementDisplayStatusArray['descTR'+ticketID];
		}
		if(currentExpandstatus)
		{
			if(document.getElementById('imgShowHide'+ticketID))
				document.getElementById('imgShowHide'+ticketID).src="/home/images/expand.gif";
			if(document.getElementById('descTR'+ticketID))
				document.getElementById('descTR'+ticketID).style.display = 'none';
		}
		else
		{
			if(document.getElementById('imgShowHide'+ticketID))
				document.getElementById('imgShowHide'+ticketID).src="/home/images/collapse.gif";
			if(document.getElementById('descTR'+ticketID))
				document.getElementById('descTR'+ticketID).style.display = 'block';
		}
		//if(elementDisplayStatusArray['descTR'+ticketID])
			elementDisplayStatusArray['descTR'+ticketID]=!currentExpandstatus;
	}
	
	this.GetTicketDesc = function(){return ticketDesc;}

	this.SetTicketClassName = function(tktClassName){
		
		ticketClassName		= tktClassName;
		_ticketTable.className	= ticketClassName;
	}
	this.GetTicketClassName = function(){return tktClassName;}
	
	this.SetTicketQuantity = function(minQty,maxQty,selectedQty,IsMemberTicket){
		var inc=1;
		if(tktsData.hasOwnProperty('ticketsincrement')){
		var incObj=tktsData['ticketsincrement'];
		if(incObj.hasOwnProperty(tktID)){
			inc=Number(incObj[tktID]);
			inc=inc==0?1:inc;
		}
		}
		_select.name	= "qty_"+tktID;
		_select.id="qty_"+tktID;
		
		if(IsMemberTicket == 'Y')	_select.disabled	= true;
		_option			= document.createElement("option");
		_option.text	= 0;
		_option.value	= 0;
		_select.options.add(_option); 
		for(var i=parseFloat(minQty);i<=parseFloat(maxQty);i=i+inc)
		{	
			_option		= document.createElement("option");
			_option.text	= i;
			_option.value	= i;
			if(i == selectedQty)
			{
				_option.selected = true;
			}
			_select.options.add(_option); 
		}
	}

	this.SetTicketActualFee = function(tktActualFee){ticketActualFee = tktActualFee;}
	this.GetTicketActualFee = function(){return ticketActualFee;}
	this.SetTicketChargingFee = function(tktChargingFee){ticketChargingFee = tktChargingFee;}
	this.GetTicketChargingFee = function(){return ticketChargingFee;}
	this.SetTicketProcessFee = function(tktProcessFee){ticketProcessFee = tktProcessFee;}
	this.GetTicketProcessFee = function(){return ticketProcessFee;}
	this.getTicketGroupId=function(){return ticketGroupId;}
	this.SetTicketGroupId = function(tktGroupId){ticketGroupId = tktGroupId;_ticketHiddenGroupid.value=tktGroupId;}
	this.SetEventId=function(EventId){eventId = EventId;}
	//_container.style.height =	"40px";
	//_container.style.width =	"100%"
	var _container			= document.createElement("DIV");	
	var _ticketTable		= document.createElement("TABLE");
	var _ticketTbody		= document.createElement("tbody");
	var _ticketTr			= document.createElement("TR");
	var _ticketDescImgTd	= document.createElement("TD");
	var _ticketDescTR		= document.createElement("TR");
	var _ticketDescTd		= document.createElement("TD");
	var _tktDummyTd			= document.createElement("TD");
	var _tktDummyTd1			= document.createElement("TD");
	var _ticketDescLabel	= document.createElement("label");
	_ticketDescTR.id = "descTR"+tktID;
	_ticketDescTR.style.display = "none";
	
	var _tktsmallDescTR		= document.createElement("TR");
	var _tktsmallDescTD		= document.createElement("TD");
	var _spansmallmessage		= document.createElement("DIV");
	var _spansmallDesc		= document.createElement("DIV");
	_container.setAttribute("class","widgetcontainer");
	_spansmallDesc.setAttribute("class","small");
	_spansmallmessage.id="divmsg_"+tktID;
	/********************Hidden Fields*********************/
	var _ticketHiddenPrice	= document.createElement("INPUT");
	_ticketHiddenPrice.type="hidden";
	_ticketHiddenPrice.id="originalprice_"+tktID;
	_ticketHiddenPrice.name="originalprice_"+tktID;	
	_container.appendChild(_ticketHiddenPrice);

	var _ticketHiddenFee= document.createElement("INPUT");
	_ticketHiddenFee.type="hidden";
	_ticketHiddenFee.id="processfee_"+tktID;
	_ticketHiddenFee.name="processfee_"+tktID;	
	_container.appendChild(_ticketHiddenFee);
	
	var _ticketHiddenFinalPrice= document.createElement("INPUT");
	_ticketHiddenFinalPrice.type="hidden";
	_ticketHiddenFinalPrice.id="finalprice_"+tktID;	
	_ticketHiddenFinalPrice.name="finalprice_"+tktID;	
	
	_container.appendChild(_ticketHiddenFinalPrice);

	var _ticketHiddenFinalFee= document.createElement("INPUT");
	_ticketHiddenFinalFee.type="hidden";
	_ticketHiddenFinalFee.id="finalprocessfee_"+tktID;
	_ticketHiddenFinalFee.name="finalprocessfee_"+tktID;	
	
	_container.appendChild(_ticketHiddenFinalFee);
	
	var _ticketHiddenGroupid= document.createElement("INPUT");
		_ticketHiddenGroupid.type="hidden";
		_ticketHiddenGroupid.id="ticketGroup_"+tktID;
		_ticketHiddenGroupid.name="ticketGroup_"+tktID;	
		_container.appendChild(_ticketHiddenGroupid);

	var _ticketHiddenType= document.createElement("INPUT");
			_ticketHiddenType.type="hidden";
			_ticketHiddenType.id="ticketType_"+tktID;
			_ticketHiddenType.name="ticketType_"+tktID;	
			_container.appendChild(_ticketHiddenType);
	
	
	
	

	 var _donationHiddenQty= document.createElement("INPUT");
	_donationHiddenQty.type="hidden";
	_donationHiddenQty.id="qty_"+tktID;
	_donationHiddenQty.name="qty_"+tktID;
	_donationHiddenQty.value="0";
	    
	/********************************************************/
	
	_ticketTable.style.width	=	"100%";

	var _labeltktName	= document.createElement("label");
	var _labeltktStatus	= document.createElement("label");
	var _select			= document.createElement("select");	
	var _labeltktPrice	= document.createElement("label");
	var _labeltktFee	= document.createElement("label");
	var _imgtktDesc		= document.createElement("a");
	var _txtktDonate	= document.createElement("INPUT");
	
	 _labeltktName.style.fontWeight = '100';
     _labeltktPrice.style.fontWeight = '100';
     _labeltktFee.style.fontWeight = '100';
	
	_txtktDonate.type = 'text';
	_txtktDonate.setAttribute("size","4");
	_ticketTbody.id="tktbodyimg_"+tktID;
	_ticketTbody.appendChild(_ticketTr);
	//_ticketTbody.appendChild(_tktsmallDescTR);
	_ticketTbody.appendChild(_ticketDescTR);
	
	_ticketTable.appendChild(_ticketTbody);
	_container.appendChild(_ticketTable);

	this.GetContainer = function()
	{ 
		return _container; 
	}

	this.initializeControls = function(tktData)
	{   
		var _ticketGroupTd	= document.createElement("TD");
		var _ticketNameTd	= document.createElement("TD");

		if(tktData['isLooseTicket']=='N')
		{
			_ticketGroupTd.style.width	=	"5%";
			_ticketGroupTd.setAttribute("rowSpan",3);
			_ticketGroupTd.id="groupname_"+tktID;
			_ticketNameTd.style.width	=	"50%";
			
			_ticketNameTd.appendChild(_labeltktName);
			_ticketTr.appendChild(_ticketGroupTd);
			_ticketTr.appendChild(_ticketNameTd);
			/******************** More Option related**************************/
			_tktDummyTd1.setAttribute("width","5%");
			_ticketDescTd.setAttribute("colSpan",4);
			_ticketDescTd.appendChild(_ticketDescLabel);
			_ticketDescTd.setAttribute("colSpan",4);
			_ticketDescTR.appendChild(_ticketDescTd);
			
			/*******************************************************************/
			_ticketNameTd.appendChild(_spansmallmessage);
			_ticketNameTd.appendChild(_spansmallDesc);
			//_tktsmallDescTR.appendChild(_tktsmallDescTD);
		}
		else
		{
			_ticketGroupTd.style.width	=	"0%";
			_ticketNameTd.style.width	=	"53%";
			
			_ticketNameTd.appendChild(_labeltktName);
			_ticketTr.appendChild(_ticketNameTd);
			/******************** More Option related*************************/
			_ticketDescTd.appendChild(_ticketDescLabel);
			_ticketDescTR.appendChild(_ticketDescTd);
			_ticketDescTd.setAttribute("colSpan",4);
			_ticketDescTd.setAttribute("width","100%");
			/*****************************************************************/
			_ticketNameTd.appendChild(_spansmallmessage);
			_ticketNameTd.appendChild(_spansmallDesc);
			//_tktsmallDescTR.appendChild(_tktsmallDescTD);
		}
		if(tktData['Available']=='Y')
		{
		
			if(tktData['DonateType']=='Y')
			{
			
			var _ticketDonateTd	= document.createElement("TD");
				_ticketDonateTd.setAttribute("align","right");
				_ticketDonateTd.setAttribute("valign","top");
				_ticketDonateTd.style.width		=	"15%";
				_ticketDonateTd.style.padding		=	"2px";
				_ticketDonateTd.appendChild(_txtktDonate);
				_ticketTr.appendChild(_ticketDonateTd);
				var _ticketDonateDummyTd= document.createElement("TD");
				_ticketDonateDummyTd.setAttribute("align","right");
				
				_ticketDonateDummyTd.style.width="35%";
				_ticketTr.appendChild(_ticketDonateDummyTd);
				_container.appendChild(_donationHiddenQty);
			
				if(tktData['Msg']=='NA'){
				 		      _txtktDonate.setAttribute("disabled","true");
							  _ticketDonateDummyTd.style.width="25%";
							  var _ticketHiddenquantity= document.createElement("INPUT");
								_ticketHiddenquantity.type="hidden";
								_ticketHiddenquantity.id="qty_"+tktID;
								_ticketHiddenquantity.name="qty_"+tktID;
								_ticketHiddenquantity.value="0";	

								_container.appendChild(_ticketHiddenquantity);

								var _ticketStatusTd	= document.createElement("TD");
								_ticketStatusTd.setAttribute("align","right");
								_ticketStatusTd.style.width	=	"50%";
								_ticketStatusTd.appendChild(_labeltktStatus);
								_ticketTr.appendChild(_ticketStatusTd);
								
					}
				
			}
			else
			{
				
				/*****************************************************/	
				_labeltktPrice.name		= "lblPrice"+tktID;
				_labeltktPrice.id		= "lblPrice"+tktID;	
				var _ticketPriceTd		= document.createElement("TD");
				_ticketPriceTd.setAttribute("align","right");
				_ticketPriceTd.setAttribute("valign","top");
				_ticketPriceTd.style.width	=	"15%";
				_ticketPriceTd.style.padding	=	"2px";
				_ticketPriceTd.appendChild(_labeltktPrice);
				_ticketTr.appendChild(_ticketPriceTd);
				/*****************************************************/
				_labeltktFee.name		= "lblFee"+tktID;
				_labeltktFee.id			= "lblFee"+tktID;	
				var _ticketFeeTd		= document.createElement("TD");
				_ticketFeeTd.setAttribute("align","right");
				_ticketFeeTd.setAttribute("valign","top");
				_ticketFeeTd.style.width	=	"15%";
				_ticketFeeTd.style.padding	=	"2px";
				_ticketFeeTd.appendChild(_labeltktFee);
				_ticketTr.appendChild(_ticketFeeTd);
				/*****************************************************/
				if(tktData['Msg']!='NA'){
				 var _ticketVolumeTd		= document.createElement("TD");
				_ticketVolumeTd.setAttribute("align","right");
				_ticketVolumeTd.setAttribute("valign","top");
				_ticketVolumeTd.style.width	=	"20%";
				_ticketVolumeTd.id="td_ticketid_"+tktID;
				_ticketVolumeTd.appendChild(_select);
				_ticketTr.appendChild(_ticketVolumeTd);
				}
				else{
				var _ticketHiddenquantity	= document.createElement("INPUT");
				_ticketHiddenquantity.type="hidden";
				_ticketHiddenquantity.id="qty_"+tktID;
				_ticketHiddenquantity.name="qty_"+tktID;
				_ticketHiddenquantity.value="0";	

				_container.appendChild(_ticketHiddenquantity);

				var _ticketStatusTd		= document.createElement("TD");
				_ticketStatusTd.setAttribute("align","right");
				_ticketStatusTd.style.width	=	"50%";
				_ticketStatusTd.appendChild(_labeltktStatus);
				_ticketTr.appendChild(_ticketStatusTd);
				
				}
				/*****************************************************/
			}
		}
		else
		{
				
			var _ticketHiddenquantity	= document.createElement("INPUT");
			_ticketHiddenquantity.type="hidden";
			_ticketHiddenquantity.id="qty_"+tktID;
			_ticketHiddenquantity.name="qty_"+tktID;
			_ticketHiddenquantity.value="0";	
			
			_container.appendChild(_ticketHiddenquantity);

			var _ticketStatusTd		= document.createElement("TD");
			_ticketStatusTd.setAttribute("align","center");
			_ticketStatusTd.style.width	=	"50%";
			_ticketStatusTd.appendChild(_labeltktStatus);
			_ticketTr.appendChild(_ticketStatusTd);
		}

	}
	this.SetTicketData = function(tktData)
		{
			this.initializeControls(tktData);
			this.SetTicketGroupId(tktData['GroupId']);
			var tckname=tktData['Name'];
			if(tktData['Strike']!=undefined && tktData['Strike']=='Y')
			tckname='<strike>'+tckname+'</strike>';
			this.SetTicketName(tckname);
			this.SetTicketStatusMsg(tktData['Msg'],tktData);
			this.SetActualPrice(tktData['ActualPrice']);
			this.ticketIsAvailable=tktData['Available'];
			this.ticketStatusMsg=tktData['Msg'];
			this.SetEventId(tktData['eventId']);
			if(typeof(tktData['ChargingPrice'])!="undefined")
			{
				this.SetChargingPrice(tktData['ChargingPrice']);
			}
			this.SetActualFee(tktData['ActualFee']);
			if (typeof(tktData['ChargingFee'])!="undefined")
			{
				this.SetChargingFee(tktData['ChargingFee']);
			}
			//this.SetTicketPrice(tktData['ActualPrice'],tktData['ChargingPrice']);
			//this.SetTicketFee(tktData['ActualFee'],tktData['ChargingFee']);
			this.SetTicketQuantity(tktData['Min'],tktData['Max'],tktData['Selected'],tktData['IsMemberTicket']);
			this.SetTicketClassName(tktData['Style']);
			this.SetTicketType(tktData['ticketType']);
			if(typeof(tktData['Desc'])!="undefined")
			{
				this.SetTicketDesc(tktData['Desc'],tktData['Id']);
			}	
			if(typeof(tktData['smallDesc'])!="undefined")
			{
				this.SetTicketSmallDesc(tktData['smallDesc']);
			}
			if((typeof(tktData['IsMemberTicket'])!="undefined") && (tktData['IsMemberTicket']=="Y"))
			{
				this.SetMemberTicketLogin();
			}
	}
	_select.onchange = function()
	{
		eventOnSelectChanged(tktID);
	}
	_txtktDonate.onblur = function()
	{
		eventOnblurDonate(tktID,_txtktDonate.value);
	}
	/*_txtktDonate.onkeyup = function()
	{
		eventOnblurDonate(tktID,_txtktDonate.value);
	}
	*/
}

var ticketWidgets=[];
 
 			
function addTicketControl(parentElmId,tktData)
{      
	if(tktsData.waitList!=undefined && tktsData.waitList.status=='Expired'){
		document.getElementById('registration').style.display='block';
		document.getElementById('registration').innerHTML='<div style="text-align:center"><b>Sorry you are late the link has expired , if you want to re-request for the tickets go to the<a href="http://www.eventbee.com/event?eid='+eventid+'"> Event Page!</a></b></div>';
		return;
	}
	//alert("tkts data::"+JSON.stringify(tktsData,undefined,2));
	//alert("tkt data::"+JSON.stringify(tktData,undefined,2));
	//alert(tktsData.waitList);
	var tktCtrl=new TicketWedgetControl(tktData['Id']);
	if(tktsData.waitList!=undefined && tktsData.waitList!=null){
	if(tktData['Id']==tktsData.waitList.tktid){
	tktData["Strike"]="N";
	tktData["Available"]="Y";
	tktData["Max"]=tktsData.waitList.tktqty;
	}
	}

	if(tktData.Available=='N' && tktData.UnavailableType=='SOLDOUT' && tktData.waitListType=='Y')
		tktData["Strike"]="N";
	tktCtrl.SetTicketData(tktData);
	document.getElementById(parentElmId).appendChild(tktCtrl.GetContainer());
	ticketsArray.push(parentElmId);
	ticketWidgets[parentElmId]=tktCtrl;
	if(tktsData['tktDescMode'] && tktsData['tktDescMode']=='expand' && typeof(tktData['Desc'])!="undefined"){
	tktCtrl.toggleDescription(tktData['Id']);
	}
	
	if(tktsData.waitList!=undefined && tktsData.waitList!=null)
		if(tktData['Id']==tktsData.waitList.tktid){
			delete tktCtrl.ticketStatusMsg;
			document.getElementById('qty_'+tktData['Id']).selectedIndex=tktsData.waitList.tktqty;
			document.getElementById('qty_'+tktData['Id']).style.display='none';
			var spanElement=document.createElement("span");
			spanElement.innerHTML=tktsData.waitList.tktqty;
			document.getElementById("td_ticketid_"+tktData['Id']).appendChild(spanElement);
			var recurDate=tktsData.waitList.eventdate;
			
			if(document.getElementById('eventdate')){
			var select = document.getElementById("eventdate");
	        for(var i = 0;i < select.options.length;i++){
	            if(select.options[i].value == recurDate){
	                select.options[i].selected = true;
	            }
	        }
			}
			
			//var html='<input type="hidden" id="waitlist_'+tktsData.waitList.tktid+'" name="qty_'+tktsData.waitList.tktid+'">';
			
			//document.getElementById('td_ticketid_'+tktData['Id']).innerHTML=html;
			
		/*	document.getElementById('qty_'+tktData['Id']).disabled=true;
			var hiddenElement = document.createElement("input");
			hiddenElement.type='hidden';
			hiddenElement.value=tktsData.waitList.tktqty;
			hiddenElement.name='qty_'+tktsData.waitList.tktid;
			hiddenElement.id='waitlist_'+tktsData.waitList.tktid;
			document.getElementById("regform").appendChild(hiddenElement);*/
		}
		
	
	
	
}
var totalAmount=0;

function Initialize(elmName)
{   var profeecount=0;

	elm = document.getElementById(elmName);
	var tags =elm.getElementsByTagName('div');
	var searchClass='tktWedgetClass';
	for(i=0; i<tags.length; i++) {
		var test = tags[i].className;
		if (test.indexOf(searchClass) != -1)
		{
		
     	if(tktsData[tags[i].id].ChargingFee!=0.00 && (tktsData[tags[i].id].Available=="Y"))
		{
	
		profeecount++;
	
		}
		addTicketControl(tags[i].id,tktsData[tags[i].id]);
		}
		else if(test.indexOf("tckgrpname") != -1){
                setTicketGroupDescription(tags[i].id);
				if(tktsData['tktgrpDescMode'] && tktsData['tktgrpDescMode']=='expand')
					showTcktGrpDescr(tags[i].id);
        }
			
		
	}
	getTicketsAvailabilityMsg();
	if($('seatingsection')){
		seatingticketresponse();
		getseatingsection();
	}
	else{
		getBuyButtonStatus();
	}
	
 checkprofee(profeecount,tags);
}
			function checkprofee(profeecount,tags)
			{
					if(profeecount==0)
					{
					
					if($('feelabel'))
					$('feelabel').innerHTML="";
									
				var searchClass='tktWedgetClass';
				for(i=0; i<tags.length; i++) {
					var test = tags[i].className;
					if (test.indexOf(searchClass) != -1)
					{		
									var  lblid=	"lblFee"+tags[i].id;
								if($(lblid))$(lblid).hide();
						}
								
								}
	}

}
function funSet(){
	var newVal	=	document.getElementById('txtBOXchange').value;
	var id		=	document.getElementById('txtBOX').value;
	ticketWidgets[id].SetTicketName(newVal);
}
function funGet(){
	var id		=	document.getElementById('txtBOX').value;
	var result = ticketWidgets[id].GetTicketName();
//	alert(result);

}
function eventOnSelectChanged(ticketID)
{
	if(document.getElementById('totalamount'))
	document.getElementById('totalamount').style.display='none';
}
function eventOnblurDonate(ticketID,text)
{    text=jQuery.trim(text);
    if(document.getElementById('totalamount'))
	document.getElementById('totalamount').style.display='none';

	
	if(text!=''&&parseFloat(text)>0&& !isNaN(text)){
	
		ticketWidgets[ticketID].setDonationTicketQty(1);
		ticketWidgets[ticketID].setDonationPrice(parseFloat(text));
       	donatObject[ticketID]=true;
}
   else{
 
      if(text!='')
   	   { donatObject[ticketID]=false;
		 ticketWidgets[ticketID].setDonationTicketQty(0);
	     ticketWidgets[ticketID].setDonationPrice(0);
	   }
	     else{
	     donatObject[ticketID]=true;
		 ticketWidgets[ticketID].setDonationTicketQty(0);
	     ticketWidgets[ticketID].setDonationPrice(0);
	     }
	  }
}
function showDescription(ticketID)
{
	ticketWidgets[ticketID].toggleDescription(ticketID);
}
function funMemberTicketLogin(ticketID,eventId)
{
	getMemeberLoginPopUp(eventId);
}
function funMemberLoggedIn()
{
	var id		=	document.getElementById('txtBOX').value;
	var result = ticketWidgets[id].ClearMemberTicketLogin();
}
