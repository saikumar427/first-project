function checkCat1(){
var isvalid=false;
  
	
	if(document.form.alertpref[1].checked)
	{
	
		var flag1=validatecheckbox();
		if (flag1==0){
        	alert("Please select atleast one Category");
        	return false;
		}
	}
	alertsubmit();
    return false;
  }

  function validatecheckbox(){
          var flag=0;
	   if (document.form.checkCategory!=null){
     for(var counter=0;counter<document.form.checkCategory.length;counter++)
         {
           	if (document.form.checkCategory[counter].checked){
       	                 flag = 1;
        	         break;
           	}
         }
	  return flag;
     }

   }
   

