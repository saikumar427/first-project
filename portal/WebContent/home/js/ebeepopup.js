function ebeepopupwindow(eleId,eleName){
	this.position='absolute';
	this.height='';
	this.width='';
	this.disableBackground=false;
	this.popupelement;
	this.popupcontent;
	this.popbackgroudele;
	this.popupCloseAction;
	this.popupName=eleName;
	this.opened=false;
	var backgroundele;
	var inited=false;
	this.init=function(){
		if(!window.jQuery){
			var script = document.createElement('script');
			script.type = "text/javascript";
			script.src = "http://www.eventbee.com/home/js/jQuery.js";
			document.getElementsByTagName('head')[0].appendChild(script);
		}
		if(document.getElementById(eleId)){
			this.popupelement=document.getElementById(eleId);
		}
		else{
			this.popupelement=document.createElement("div");
			this.popupelement.setAttribute("id",eleId)
			document.body.appendChild(this.popupelement);
		}
		this.popupelement.className='ebeepopup';
		this.popupelement.innerHTML="<img src='http://www.eventbee.com/home/images/images/close.png' class='ebeepopupclose' onclick='"+this.popupName+".hide()' id='popupclose'>";	
		this.popupcontent=document.createElement("div");
		this.popupcontent.setAttribute('id',"ebeepopupcontent");
		this.popupcontent.className='ebeepopupcontent';
		this.popupelement.appendChild(this.popupcontent);
		//jQuery(this.popupelement).draggable();
		////////////// creating background div
		if(document.getElementById("backgroundPopup")){
			backgroundele=document.getElementById("backgroundPopup");
			//backgroundele.style.height=document.body.scrollHeight+'px';
		}else{
			backgroundele=document.createElement("div");
			backgroundele.setAttribute('id',"backgroundPopup");
			document.body.appendChild(backgroundele);
		}
		this.bgwidthmonitor();
		inited=true;
	}
	this.show=function(){
		if(inited){
			if(!this.disableBackground){
				backgroundele.style.display='block';
				jQuery("*").attr("tabindex", "-1");
				jQuery("#"+eleId+" *").removeAttr("tabindex");
			}
			var pos=jQuery(document).scrollTop()+130;
			this.popupelement.style.top=pos+'px'
			this.popupelement.style.display='block';
			//jQuery(this.popupelement).draggable();
			this.opened=true;
		}
	}
	this.hide=function(){
		jQuery("*").removeAttr("tabindex");
		backgroundele.style.display='none';
		this.popupelement.style.display='none';
		this.opened=false;
		if(this.popupCloseAction!=undefined)
			this.popupCloseAction.apply();
	}
	
	this.onPopupClose=function(fn){
		this.popupCloseAction=fn;
	}
	this.setContent=function(content){
		this.popupcontent.innerHTML=content;
	}
	this.setWidth=function(width){
		this.popupelement.style.width=width;
	}
	this.setHeight=function(height){
		this.popupelement.style.height=height;
	}
	this.setDraggable=function(isDraggable){
		if(isDraggable) jQuery(this.popupelement).draggable();
		else jQuery(this.popupelement).draggable("disable");
	}
	this.bgwidthmonitor=function(){
		bckheight=jQuery(document).height();
		bckwidth=jQuery(document).width();
		backgroundele.style.height=bckheight+'px';
		backgroundele.style.width=bckwidth+'px';
		setTimeout(eleName+'.bgwidthmonitor()',10);
	}
	this.reset=function(){
		this.popupcontent.innerHTML="";
		this.popupelement.style.width="";
		this.popupelement.style.height="";
		this.popupCloseAction=undefined;
		this.disableBackground=false;
	}
}
