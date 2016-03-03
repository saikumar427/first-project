var T_Q='';
function getLongResponse(id,v){
	var l="";
	if(v=="") return l;
	var question=getQuestion(id,T_Q.questions);
	var t=question.t;
	if(t=="text" || t=="textarea") return l;
	var ov=question.optionVals;
	var ol=question.optionLabels;
	var res = v.split(",");
	for(var i=0;i<res.length;i++){
		for(var j=0;j<ov.length;j++){
			if(ov[j]==res[i]) {
				if(l!="") l +=", ";
				l += ol[j];
			}
		}
	}
	return l;
}
function formatDataAndSubmit(filledData){
	var transaction=T_Q.transaction;
	var buyer=T_Q.buyer;
	var tickets=transaction.tickets;
	var dt={"tid":transaction.tid, "attrib_setid":transaction.attrib_setid, "buyer":{"k":transaction.buyer.k, "profileid":transaction.buyer.profileid,"responses":[]}, "tprofiles":[]};
	dt.buyer.fname=filledData.buyer.fname;
	dt.buyer.lname=filledData.buyer.lname;
	dt.buyer.email=filledData.buyer.email;
	dt.buyer.phone=(filledData.buyer.phone)?filledData.buyer.phone:"";
	var buyerfields=buyer.fields;
	for(var i=0;i<buyerfields.length;i++){
		var v= (filledData.buyer[buyerfields[i]])?filledData.buyer[buyerfields[i]]:"";
		dt.buyer.responses.push({"id":buyerfields[i], "v":v, "l":getLongResponse(buyerfields[i],v)});
	}
	for(var i=0;i<tickets.length;i++){
		var tkt=tickets[i];
		if(filledData["T_"+tkt.id+"_P1"]){
			var tq=getTicketObject(tkt.id);
			for(var j=0;j<tkt.q;j++){
				var x=filledData["T_"+tkt.id+"_P"+(j+1)];
				var p={"k":x.k, "tktid":tkt.id, "profileid":x.profileid,"responses":[]};
				var bf=tq.basefields;
				for(var l=0;l<bf.length;l++){
					p[bf[l].c]=x[bf[l].c]?x[bf[l].c]:"";
				}
				var fields=tq.fields;
				for(var k=0;k<fields.length;k++){
					var v= (x[fields[k]])?(x[fields[k]]):"";
					p.responses.push({"id":fields[k], "v":v, "l":getLongResponse(fields[k],v)});
				}
				dt.tprofiles.push(p);
			}
		}
	}
	var req= jQuery.ajax({
			url: "/reg_widget/putprofiledatajson.jsp",
			type: "POST",
			data: { data : JSON.stringify(dt),eid: eventid }		 
	});
	req.done(function( msg ) {
		var resp=JSON.parse(msg);
		
		$(".alpaca-form-button-submit").before('<div id="notification-holder-bottom"></div>');
		if(resp.status=='success'){
			$("#loadingGIF").remove();
			$(".alpaca-form-button-submit").show();
			//hidePageLoadingImage();
			//showData('#profileform','bootstrap-edit');
			notification(props.buyer_profile_updated_status_msg,'success');
		}else
			notification(props.global_prob_errmsg,'danger');
	});
	//alert(JSON.stringify(dt, null, "  "));
}
function buildElements(){
	var schema={"type": "object","properties": {}};
	var options={"fields":  {}};
	var data={};
	data.buyer=T_Q.transaction.buyer;
	schema.properties.buyer=buildProfileSchema(T_Q.buyer);
	options.fields.buyer=buildProfileOptions(T_Q.buyer,0);
	options.hideInitValidationError=true;
	options.form= {
        "buttons": {
            "submit": {
                "title": props.global_continue_lbl,
                "click": function() {
                	$(".alpaca-form-button-submit").hide();
                	$(".alpaca-form-button-submit").after('<div id="loadingGIF"><img src="http://www.eventbee.com/main/images/layoutmanage/Pspinner.gif" style="width:34px;"></div>');
                	//showPageLoadingImage(props.loading);
                    var filledData = this.getValue();
                    formatDataAndSubmit(filledData);
                }
            }
        }
    };
	var tickets=T_Q.transaction.tickets;
	for(var i=0;i<tickets.length;i++){
		var qty=tickets[i].q;
		var id=tickets[i].id;
		var ticket=getTicketObject(id);
		if(ticket && (ticket.basefields.length+ticket.fields.length >0)){
			for(var j=0;j<qty;j++){
				schema.properties["T_"+ticket.id+"_P"+(j+1)]=buildProfileSchema(ticket);
				options.fields["T_"+ticket.id+"_P"+(j+1)]=buildProfileOptions(ticket,j);
				if(tickets[i].profiles && tickets[i].profiles.length>j)
					data["T_"+ticket.id+"_P"+(j+1)]=tickets[i].profiles[j];
			}
		}
	}
	return [schema, options, data];
}
function getTicketObject(ticketid){
	var ticket;
	var tickets=T_Q.tickets;
	for(var i=0;i<tickets.length;i++){
		if(ticketid==tickets[i].id) {ticket=tickets[i];break;}
	}
	return ticket;
}
function getQuestion(qid, questions){
	var question;
	for(var i=0;i<questions.length;i++){
		if(qid==questions[i].c) {question=questions[i];break;}
	}
	return question;
}
function buildProfileSchema(profile){
	var schema={"type": "object","properties": {}};
	schema.properties["k"]={"type": "string"};
	schema.properties["profileid"]={"type": "string"};
	var basefields=profile.basefields;
	
	for(var i=0;i<basefields.length;i++){
		var question=getQuestion(basefields[i].c,T_Q.basequestions);
		schema.properties[question.c]={"type": "string", "required":(basefields[i].req=="y")};
	}
	var fields=profile.fields;
	for(var i=0;i<fields.length;i++){
		var question=getQuestion(fields[i],T_Q.questions);
		t=question.t;
		var dt;
		if(t=="text"){
			dt={"type": "string", "required":(question.req=="y")};
		}
		else if(t=="textarea"){
			dt={"type": "string", "required":(question.req=="y")};
		}
		else if(t=="checkbox"){
			dt={"type": "string", "enum": question.optionVals, "required":(question.req=="y")};
		}
		else if(t=="select"){
			dt={"type": "string", "enum": question.optionVals, "required":(question.req=="y")};
		}
		else if(t=="radio"){
			dt={"type": "string", "enum": question.optionVals, "required":(question.req=="y")};
		}
		schema.properties[question.c]=dt;
	}
	return schema;
}
function buildProfileOptions(profile, index){
	var options={"label": formatLabel(profile.label, index), "fields":{}};
	options.fields["k"]={"type": "hidden"};
	options.fields["profileid"]={"type": "hidden"};
	var basefields=profile.basefields;
	for(var i=0;i<basefields.length;i++){
		var question=getQuestion(basefields[i].c,T_Q.basequestions);
		options.fields[question.c]={"type": "text", "label":question.l};
		if(question.c=='email') (options.fields[question.c])['type']='email';
	}
	var fields=profile.fields;
	for(var i=0;i<fields.length;i++){
		var question=getQuestion(fields[i],T_Q.questions);
		t=question.t;
		var dt;
		if(t=="text"){
			 dt={"type": "text", "label":question.l};
		}
		else if(t=="textarea"){
			 dt={"type": "textarea", "label":question.l, "cols":question.cols, "rows":question.rows};
		}
		else if(t=="checkbox"){
			 dt={"type": "checkbox", "label":question.l, "optionLabels":question.optionLabels};
		}
		else if(t=="select"){
			 dt={"type": "select", "removeDefaultNone": true, "label":question.l, "optionLabels":question.optionLabels};
		}
		else if(t=="radio"){
			 dt={"type": "radio", "removeDefaultNone": true, "label":question.l, "optionLabels":question.optionLabels};
		}
		options.fields[question.c]=dt;
	}
	return options;
}
function formatLabel(pattern, index){
	return pattern.replace("#index#", ""+(index+1)); 
}
var elements;
function renderForm(divid){
	elements=buildElements();
	//showData(divid, "bootstrap-display");
	showData(divid, "bootstrap-edit");
}
function showData(divid, viewtype){
	$(divid).empty();
	$(divid).alpaca({
    	"schema": elements[0],
    	"options":elements[1],
    	"data": elements[2],
    	"view": {"parent": viewtype}
    });
	hidePageLoadingImage();
}

/*function showDataForPreview(divid, viewtype){
	$(divid).empty();
	$(divid).alpaca({
    	"schema": JSON.parse('{"type":"object","properties":{"buyer":{"type":"object","properties":{"k":{"type":"string"},"profileid":{"type":"string"},"fname":{"type":"string","required":true},"lname":{"type":"string","required":true},"email":{"type":"string","required":true}}}}}'),
    	"options":JSON.parse('{"fields":{"buyer":{"label":"Buyer Profile","fields":{"k":{"type":"hidden"},"profileid":{"type":"hidden"},"fname":{"type":"text","label":"First Name"},"lname":{"type":"text","label":"Last Name"},"email":{"type":"email","label":"Email"}}}},"hideInitValidationError":true,"form":{"buttons":{"submit":{"title":"Continue"}}}}'),
    	"data": JSON.parse('{"buyer":{"phone":"","lname":"","email":"","profileid":"","k":"","fname":""}}'),
    	"view": {"parent": viewtype}
    });
	hidePageLoadingImage();
}*/

function editProfileResponse(response){
	T_Q=JSON.parse(response);
	renderForm('#profileform');
}
function getEditProfile(eid,tid,token,stage){
	eventid=eid;
	
	if(stage=='draft' || tid==''){
		$('#profileform').html("Buyer profile comes here");
		return;
	}
	showPageLoadingImage(props.loading);
		var req= jQuery.ajax({
			url: "/reg_widget/getprofiledatajson.jsp",
			type: "POST",
			data: {eid:eid,tid:tid }		 
	});
	req.done(function( msg ) {
		editProfileResponse(msg);
	});
 }

function showPageLoadingImage(msg) {
	loaded = false;
	var el = document.getElementById("imageLoad");
	if (el && !loaded) {
		el.innerHTML='';
		el.innerHTML = msg+'<br/><img src="/home/images/ajax-loader.gif">';
		$("#imageLoad").show();
	}
}

function hidePageLoadingImage(){
	if(document.getElementById("imageLoad")){
		$("#imageLoad").hide();
		loaded = true;
	}
}