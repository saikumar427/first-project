function TicketWedgetControl(tktID)
{     var eventId='';
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
	var ticketSave='';
	var ticketDiscount='';
	var ticketDiscountPrice='';
	var ticketnoTriggerDiscount='';
	var elementDisplayStatusArray=new Array();
	//var ticketDonationQty=0
	this.SetTicketName = function(tktName){
		ticketName=tktName;
		_labeltktName.innerHTML	= ticketName;
	}
	this.GetTicketName = function(){return ticketName;}

	this.SetTicketSave = function(tktyousave){
		ticketSave=tktyousave;
		_labeltktyousave.innerHTML	= ticketSave;
		_ticketHiddenYouSave.value = ticketSave;
	}
	this.GetTicketSave = function(){alert(ticketSave);return ticketSave;}
	
	this.SetTicketDiscount = function(tktdiscount){
		ticketDiscount=tktdiscount;
		_labeltktdiscount.innerHTML	= ticketDiscount;
		_ticketHiddenDiscount.value = ticketDiscount;
	}
	this.GetTicketDiscount = function(){return ticketDiscount;}
	
	this.SetTicketnoTriggerDiscount = function(tktdiscount){
		ticketnoTriggerDiscount=tktdiscount;
		_labeltktnotriggerdiscount.innerHTML	= ticketnoTriggerDiscount;
		_ticketHiddennoTriggerDiscount.value = ticketnoTriggerDiscount;
	}
	this.GetTicketDiscount = function(){return ticketnoTriggerDiscount;}
	
	
	this.SetTicketDiscountPrice = function(tktdiscountprice){
		ticketDiscountPrice=tktdiscountprice;
		_labeltktdiscountprice.innerHTML = ticketDiscountPrice;
		_ticketHiddenDiscountPrice.value = ticketDiscountPrice;
	}
	this.GetTicketDiscountPrice = function(){return ticketDiscountPrice;}

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
			_labeltktPrice.innerHTML = ticketActualPrice;
			_ticketHiddenPrice.value = ticketActualPrice;
			_ticketHiddenFinalPrice.value=ticketActualPrice;
		}
		else
		{
			_labeltktPrice.innerHTML =  "<strike>"+ticketActualPrice+"</strike><br/>"+ticketChargingPrice;
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
				_labeltktFee.innerHTML = ticketActualFee;
				_ticketHiddenFee.value = ticketActualFee;
			}
			else
			{
				_labeltktFee.innerHTML = "<strike>"+ticketActualFee+"</strike><br/>"+tktChargingFee;
				_ticketHiddenFee.value = tktChargingFee;
			}
	}
	this.GetTicketFee = function(){return 	_labeltktFee.innerHTML;}

	this.SetTicketChargingPrice = function(tktChargingPrice){
		ticketChargingPrice = tktChargingPrice;
	}
	this.GetTicketChargingPrice = function(){return ticketChargingPrice;}

	this.SetTicketStatusMsg = function(tktMsg){
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
			_labeltktName.innerHTML = _labeltktName.innerHTML + ' <img style="cursor:pointer;" id=imgShowHide'+Id+' src="/home/images/expand.gif" onClick=showDescription('+tktID+');>';
			_ticketDescLabel.innerHTML = ticketDesc;
		}
		//_ticketTable.appendChild(_ticketDescTr);
	}
	this.toggleDescription = function(ticketID){
		//alert('adsf');
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
		_select.name	= "qty_"+tktID;
		_select.id="qty_"+tktID;
		if(IsMemberTicket == 'Y')	_select.disabled	= true;
		_option			= document.createElement("option");
		_option.text	= 0;
		_option.value	= 0;
		_select.options.add(_option); 
		for(var i=parseFloat(minQty);i<=parseFloat(maxQty);i++)
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
	var _spansmallDesc		= document.createElement("DIV");
	_spansmallDesc.setAttribute("class","small");
	
	/********************Hidden Fields*********************/
	var _ticketHiddenPrice	= document.createElement("INPUT");
	_ticketHiddenPrice.type="hidden";
	_ticketHiddenPrice.id="originalprice_"+tktID;
	_ticketHiddenPrice.name="originalprice_"+tktID;	
	_container.appendChild(_ticketHiddenPrice);
	
	var _ticketHiddenDiscountPrice	= document.createElement("INPUT");
	_ticketHiddenDiscountPrice.type="hidden";
	_ticketHiddenDiscountPrice.id="discountprice_"+tktID;
	_ticketHiddenDiscountPrice.name="discountprice_"+tktID;	
	_container.appendChild(_ticketHiddenDiscountPrice);
	
	var _ticketHiddenDiscount	= document.createElement("INPUT");
	_ticketHiddenDiscount.type="hidden";
	_ticketHiddenDiscount.id="discount_"+tktID;
	_ticketHiddenDiscount.name="discount_"+tktID;	
	_container.appendChild(_ticketHiddenDiscount);
	
	var _ticketHiddennoTriggerDiscount	= document.createElement("INPUT");
	_ticketHiddennoTriggerDiscount.type="hidden";
	_ticketHiddennoTriggerDiscount.id="notriggerdiscount_"+tktID;
	_ticketHiddennoTriggerDiscount.name="notriggerdiscount_"+tktID;	
	_container.appendChild(_ticketHiddennoTriggerDiscount);
	
	var _ticketHiddenYouSave	= document.createElement("INPUT");
	_ticketHiddenYouSave.type="hidden";
	_ticketHiddenYouSave.id="yousave_"+tktID;
	_ticketHiddenYouSave.name="yousave_"+tktID;	
	_container.appendChild(_ticketHiddenYouSave);
	
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
	var _labeltktyousave = document.createElement("label");
	var _labeltktdiscount = document.createElement("label");
	var _labeltktnotriggerdiscount= document.createElement("label");
	var _labeltktdiscountprice = document.createElement("label");
	var _coundown =document.createElement("div");
	_txtktDonate.type = 'text';
	_txtktDonate.setAttribute("size","4");

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
			_ticketNameTd.appendChild(_spansmallDesc);
			//_tktsmallDescTR.appendChild(_tktsmallDescTD);
		}
		else
		{
			_ticketGroupTd.style.width	=	"0%";
			_ticketNameTd.style.width	=	"45%";
			_ticketNameTd.appendChild(_labeltktName);
			_ticketTr.appendChild(_ticketNameTd);
			/******************** More Option related*************************/
			_ticketDescTd.appendChild(_ticketDescLabel);
			_ticketDescTR.appendChild(_ticketDescTd);
			_ticketDescTd.setAttribute("colSpan",4);
			_ticketDescTd.setAttribute("width","100%");
			/*****************************************************************/
			_ticketNameTd.appendChild(_spansmallDesc);
			//_tktsmallDescTR.appendChild(_tktsmallDescTD);
		}
		if(tktData['Available']=='Y')
		{
		
			if(tktData['DonateType']=='Y')
			{
				var _ticketDonateTd				= document.createElement("TD");
				_ticketDonateTd.setAttribute("align","right");
				_ticketDonateTd.style.width		=	"15%";
				_ticketDonateTd.appendChild(_txtktDonate);
				_ticketTr.appendChild(_ticketDonateTd);
				var _ticketDonateDummyTd				= document.createElement("TD");
				_ticketDonateDummyTd.setAttribute("align","right");
				_ticketDonateDummyTd.style.width		=	"35%";
				_ticketTr.appendChild(_ticketDonateDummyTd);
				_container.appendChild(_donationHiddenQty);
			}
			else
			{
				
				/*****************************************************/	
				_labeltktPrice.name		= "lblPrice"+tktID;
				_labeltktPrice.id		= "lblPrice"+tktID;	
				var _ticketPriceTd		= document.createElement("TD");
				_ticketPriceTd.setAttribute("align","right");
				_ticketPriceTd.style.width	=	"10%";
				_ticketPriceTd.appendChild(_labeltktPrice);
				_ticketTr.appendChild(_ticketPriceTd);
				/*****************************************************/
				_labeltktdiscount.name		= "lblDiscount"+tktID;
				_labeltktdiscount.id		= "lblDiscount"+tktID;	
				var _ticketDiscountTd		= document.createElement("TD");
				_ticketDiscountTd.setAttribute("align","right");
				_ticketDiscountTd.style.width	=	"10%";
				_ticketDiscountTd.appendChild(_labeltktdiscount);
				_ticketTr.appendChild(_ticketDiscountTd);
				
				/*****************************************************/				
				_labeltktyousave.name		= "lblyousave"+tktID;
				_labeltktyousave.id			= "lblyousave"+tktID;	
				var _ticketSaveTd		= document.createElement("TD");
				_ticketSaveTd.setAttribute("align","right");
				_ticketSaveTd.style.width	=	"10%";
				_ticketSaveTd.appendChild(_labeltktyousave);//commentedbyme
				_ticketTr.appendChild(_ticketSaveTd);//commentedbyme
				/*****************************************************/
				
				_labeltktdiscountprice.name		= "lblDiscountPrice"+tktID;
				_labeltktdiscountprice.id		= "lblDiscountPrice"+tktID;	
				var _ticketDiscountPriceTd		= document.createElement("TD");
				_ticketDiscountPriceTd.setAttribute("align","right");
				_ticketDiscountPriceTd.style.width	=	"10%";
				_ticketDiscountPriceTd.appendChild(_labeltktdiscountprice);
				_ticketTr.appendChild(_ticketDiscountPriceTd);
				
				/*****************************************************/
				if(tktData['Msg']!='NA'){
				 var _ticketVolumeTd		= document.createElement("TD");
				_ticketVolumeTd.setAttribute("align","right");
				_ticketVolumeTd.style.width	=	"15%";
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
				var _ticketcountdown	= document.createElement("TR");
				_ticketcountdown.setAttribute("align","right");
				_ticketcountdown.style.width	=	"50%";
				_ticketcountdown.id="cntdwn";
				_ticketcountdown.appendChild(_coundown);
				_ticketTr.appendChild(_ticketcountdown);
			
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
			this.SetTicketStatusMsg(tktData['Msg']);
			this.SetTicketGroupId(tktData['GroupId']);
			this.SetTicketName(tktData['Name']);
			this.SetTicketSave(tktData['ticketSave']);
			this.SetTicketDiscount(tktData['ticketDiscountValue']);
			this.SetTicketnoTriggerDiscount(tktData['ticketnoTriggerDiscountValue']);
			this.SetActualPrice(tktData['ActualPrice']);
			this.SetTicketDiscountPrice(tktData['ticketDiscountPrice']);
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
	
	var tktCtrl=new TicketWedgetControl(tktData['Id']);
	
	tktCtrl.SetTicketData(tktData);
	var str = ''+tktData['Name']; 
	
	document.getElementById(parentElmId).appendChild(tktCtrl.GetContainer());
	ticketsArray.push(parentElmId);
	ticketWidgets[parentElmId]=tktCtrl;
	if(tktsData['tktDescMode'] && tktsData['tktDescMode']=='expand' && typeof(tktData['Desc'])!="undefined"){
	tktCtrl.toggleDescription(tktData['Id']);
	}
	
}
var totalAmount=0;

function Initialize(elmName)

{       elm = document.getElementById(elmName);
	
	var tags =elm.getElementsByTagName('div');
	var searchClass='grptktWedgetClass';

	for(i=0; i<tags.length; i++) {
		var test = tags[i].className;
		if (test.indexOf(searchClass) != -1)
		{
			addTicketControl(tags[i].id,tktsData[tags[i].id]);
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
	alert(result);

}
function eventOnSelectChanged(ticketID)
{
	if(document.getElementById('totalamount'))
	document.getElementById('totalamount').style.display='none';
	getGroupTicketProfile(ticketID);
}
function eventOnblurDonate(ticketID,text)
{ 
	if(document.getElementById('totalamount'))
	document.getElementById('totalamount').style.display='none';

	if(text!=''&&parseFloat(text)>0){
		ticketWidgets[ticketID].setDonationTicketQty(1);
		ticketWidgets[ticketID].setDonationPrice(text);
   }
   if(ticketWidgets[ticketStatusMsg]=='NA'){
   ticketWidgets[ticketID].setDonationTicketQty(0);
	   ticketWidgets[ticketID].setDonationPrice(0);
   
   }
   else{
	   ticketWidgets[ticketID].setDonationTicketQty(0);
	   ticketWidgets[ticketID].setDonationPrice(0);
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

	
	
	
	