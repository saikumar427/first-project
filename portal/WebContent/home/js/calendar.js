
var _CMArray;
var _CDArray;
var _CYArray;
var monthArray = new Array('','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');

 function setselectedDate(moDD,dyDD,yrDD,mo,dy,yr) {
	var matchedMo = -1;
        var matchedYr;
	for (var i=0;i<moDD.options.length;i++) {
               var checkval=parseInt(moDD.options[i].value);
	if(moDD.options[i].value=="08") checkval=8;
	if(moDD.options[i].value=="09") checkval=9;
	       if (monthArray[checkval] == mo) {
      			matchedMo = i;
               	break;
	       }
	}

        for (var i=0;i<yrDD.options.length;i++) {
              var checkyr=parseInt(yrDD.options[i].value);
              if (yrDD.options[i].value == yr) {
                     matchedYr=i;
                     break;
		}
	}
	if (matchedMo == -1) dy = 1;
	moDD.options.selectedIndex = Math.max(0,matchedMo);
         if(dyDD.options.length==31)
		dyDD.options.selectedIndex = dy-1;
	else
		dyDD.options.selectedIndex = dy;
        yrDD.options.selectedIndex=Math.max(0,matchedYr);
   }

function selectDate (dy,mo,yr) {
	    var mo=monthArray[mo];  
       setselectedDate(_CMArray,_CDArray,_CYArray,mo,dy,yr);
}

function popUpGen(page,w,h,id,globalProps) {
       	if (!id) id="popup";
	if (!globalProps) globalProps = "resizable=yes,menubar=no,status=no,scrollbars=yes,toolbar=no,directories=no,location=no";
	var win;
	if (navigator.appName == 'Netscape') {			 	
		win = window.open(page,id,'width='+w+',height='+h+','+globalProps+',screenX=0,screenY=0');
	} else {
		win = window.open(page,id,'width='+w+',height='+h+','+globalProps+',top=0,left=0');
	}
	win.focus();
    return false;
}

  var calendarLink = "/home/cal.jsp?";
function CalanderPop(CMArray, CDArray, CYArray) {
    _CMArray=CMArray;
    _CDArray=CDArray;
    _CYArray=CYArray;
     var setMonth = "";
  setMonth = CMArray.options[CMArray.options.selectedIndex].value;
     var setYear = CYArray.options[CYArray.options.selectedIndex].value;
	return popUpGen(calendarLink+"setMonth="+setMonth+"&setYear="+setYear,350,400,'popupcal','resizable=yes,menubar=no,status=no,scrollbars=no,toolbar=no,directories=no,location=no');
}

function CalanderPop(CMArray, CDArray, CYArray, isPrevShown, isreportShown) {
    _CMArray=CMArray;
    _CDArray=CDArray;
    _CYArray=CYArray;
    var setMonth = "";
     if (isPrevShown==null)
           isPrevShown="Yes";
  setMonth = CMArray.options[CMArray.options.selectedIndex].value;
     var setYear = CYArray.options[CYArray.options.selectedIndex].value;
	return popUpGen(calendarLink+"setMonth="+setMonth+"&setYear="+setYear+"&prev="+isPrevShown+"&report="+isreportShown,350,400,'popupcal','resizable=yes,menubar=no,status=no,scrollbars=no,toolbar=no,directories=no,location=no');
}

function closeWin() {
	window.close();
	return true;
} 

