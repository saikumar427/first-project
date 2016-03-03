
function fun( ins){

var totalcount=0;

if(document.getElementById("requiredblock")){

var publictickets =eval("document.t1.tn"+ins);

totalcount=totalcount+Number( pubprices[ publictickets.selectedIndex]);

var tmppr=eval("document.t1.tkttmppr"+ins);

tmppr.value=pubprices[publictickets.selectedIndex];



}

var price =eval("document.t1.tp"+ins);





if(optprices.length==1){



var ckedbox=eval("document.t1.tpopt"+ins);

if(ckedbox.checked){

totalcount=totalcount+Number( optprices[0]);



}



}





if(optprices.length>1){



	var opttickets =eval("document.t1.tpopt"+ins);

	for(var hh=0;hh<opttickets.length;hh++){

		

		if(opttickets[hh].checked){

			totalcount=totalcount+Number( optprices[hh]);

		}

	}



}





	price.value=formatCurrency(totalcount);

	removeDis(ins);

}//end of function 





function formatCurrency(rawData){

var displayData=''+rawData;

if(displayData.indexOf(".",0)>-1){

		var l=displayData.length-1;

		var k=displayData.indexOf(".",0);

		if((l-k)==1){

		  	displayData=displayData+"0";

		}

	}else{

		displayData=displayData+".00";

	}

return displayData

}



function setprice(){

if(document.getElementById("requiredblock")){

for(var hh=1;hh<=5;hh++){

var publictickets =eval("document.t1.tn"+hh);

var pr=eval("document.t1.tp"+hh);

if(pr)

pr.value=pubprices[0];



var grdtotal=eval("document.t1.tpgrand"+hh);

if(grdtotal)

grdtotal.value=pubprices[0];



var tmppr=eval("document.t1.tkttmppr"+hh);

if(tmppr)

tmppr.value=pubprices[publictickets.selectedIndex];





}

}



}





function removeDis(ins){


var txb=eval("document.t1.tpdis"+ins);
var tempdisc=0;
var price =eval("document.t1.tp"+ins);
if(txb.value==''){

alert("Discount is empty");

txb.focus();

txb.select();
}
else{



	if(isNaN(txb.value) ){

		alert("Not a number");

		txb.focus();

		txb.select();

		

	}else if(Number((txb.value)) >Number(price.value)){

		alert("Discount is higher than total amount");

		txb.focus();

		txb.select();		

	}

	else if(txb.value >= 0){

		tempdisc=Number(txb.value);

		

		//alert("is valid "+txb.value);

				

		var grandtotal=price.value-tempdisc;

		var grdtottxb=eval("document.t1.tpgrand"+ins);

		grdtottxb.value=formatCurrency(grandtotal);

	}



}



}











function checkform(){



	var status=true;

	      var i=1;

		var txb=eval("document.t1.tpdis"+i);	

		

		if(!document.getElementById("requiredblock")){

		var frm=document.t1;

		var options=frm.tpopt1;

		var ticketselected=0;
		
		if(options.length > 1){
		for(var j=0;j<options.length;j++){

		if(options[j].checked==true){



		ticketselected++;



		}

		}
		}else{
			if(options.checked){
				ticketselected = 1;		
			}
		}

                if(ticketselected==0){

                alert("please select a ticket");

                  status=false;

		 }

                   }

		

		var price =eval("document.t1.tpgrand"+i);

		if(txb.value==''){

		alert("Discount is empty");

		status=false;

		}

		if(isNaN(txb.value)){

			alert("Discount "+i+" is Not a Number");

			status=false;

		}else{

			if(txb.value<0){

				alert("Discount "+i+" is Not a positive Number");

				status=false;

			}else if(price.value<0){

					alert("Discount  is more than Total");

					status=false;

				

					

			}

		}



		

	

	

	return status;

}



