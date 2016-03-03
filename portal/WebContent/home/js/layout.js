
var req="homemenu";
function moveModule(o_col, d_col) {
    iscol=o_col.indexOf('C')>-1;
  	o_sl = document.fm[o_col].selectedIndex;
  	d_sl = document.fm[d_col].length;
	if (o_sl != -1 && document.fm[o_col].options[o_sl].value > "") {
		if((document.fm[o_col].length==1)&&(iscol)){
			alert("Column need to have atleast one beelet");
		}else if((document.fm[o_col].selectedIndex==0)&&(!iscol)){
			
		}else{
			if (req.indexOf(document.fm[o_col].options[o_sl].value) > -1) {
			      alert ("This beelet position is fixed.");
    		}else{
    			oText = document.fm[o_col].options[o_sl].text;
 				oValue = document.fm[o_col].options[o_sl].value;
 				document.fm[o_col].options[o_sl] = null;
   				document.fm[d_col].options[d_sl] = new Option (oText, oValue, false, true);
   			}
   		}
 	} else {
    		alert("Please select a module first");
  	}
}
function orderModule(down, col) {
 	sl = document.fm[col].selectedIndex;
 	if (sl != -1 && document.fm[col].options[sl].value > "") {
    		oText = document.fm[col].options[sl].text;
    		oValue = document.fm[col].options[sl].value;
    		if (document.fm[col].options[sl].value > "" && sl > 0 && down == 0) {
    		if (req.indexOf(document.fm[col].options[sl-1].value) > -1) {

    		}else{
      			document.fm[col].options[sl].text = document.fm[col].options[sl-1].text;
 			document.fm[col].options[sl].value = document.fm[col].options[sl-1].value;
   			document.fm[col].options[sl-1].text = oText;
   			document.fm[col].options[sl-1].value = oValue;
     			document.fm[col].selectedIndex--;
     			}
 		} else if (sl < document.fm[col].length-1 && document.fm[col].options[sl+1].value > "" && down == 1) {
 		if (req.indexOf(document.fm[col].options[sl].value) > -1) {
					      alert ("This beelet position is fixed.");
    		}else{
 				document.fm[col].options[sl].text = document.fm[col].options[sl+1].text;
     			document.fm[col].options[sl].value = document.fm[col].options[sl+1].value;
    			document.fm[col].options[sl+1].text = oText;
    			document.fm[col].options[sl+1].value = oValue;
 			document.fm[col].selectedIndex++;
 			}
 		}
	} else {
  		alert("Please select a module first");
 	}
}
function doSubmit(){
	var len=(document.fm["cols"].length);
	var val="";
	for(i=0;i<len;i++){
		if(document.fm.cols[i].checked==true){
			val=document.fm.cols[i].value;
			break;
		}
	}
	
	return doSub(val);
}
function doSub(val) {
  if(val==2){
   		document.fm["C1_lst"].value = makeList("C21");
   		document.fm["C2_lst"].value = makeList("C22");
   		document.fm["layout"].value = setLayout("lo2");

	}
	if(val==3){
	   		document.fm["C1_lst"].value = makeList("C31");
	   		document.fm["C2_lst"].value = makeList("C32");
	   		document.fm["C3_lst"].value = makeList("C33");
	   		document.fm["layout"].value = setLayout("lo3");

	}
	 return true;
}
function makeList(col) {
  	val = "";
  	for (j=0; j<document.fm[col].length; j++) {
    		if (val > "") {
			val += ",";
		}   		if (document.fm[col].options[j].value > "") val += document.fm[col].options[j].value;
	}
	
  	return val;
}
function setLayout(col) {
	o_sl = document.fm[col].selectedIndex;
	val=document.fm[col].options[o_sl].value;
	
	return val;
}


