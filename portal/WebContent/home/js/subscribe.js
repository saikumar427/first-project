function checkName(){  
   if(document.form.firstname.value==''){
  	alert("First Name should not be empty");
        return false;
  }else if(document.form.lastname.value==''){
  	alert("Last Name should not be empty");
  	return false;  	
  }else if(document.form.emailstring.value==''){
  	alert("Email should not be empty");
  	return false;
  }else if(document.form.emailstring.value!=''){
       	   var t1=document.form.emailstring.value;
       	   var t2=document.form.emailstring.value; 
        if ((t1.indexOf('@')==-1)||(t2.indexOf('.')==-1)) {
        	alert("Invalid Email Format");
                return false;
         } 
       var flag1=validatecheckbox();
        if (flag1==0){
                alert("Please select atleast one Category");
                return false;
        } 
        return true;
  }else { return true; }
 }

  function validatecheckbox(){
          var flag=0;
        if (document.form.reqctg!=null){
     for(var counter=0;counter<document.form.reqctg.length;counter++)
         {        
           	if (document.form.reqctg[counter].checked){
       	                 flag = 1;
        	         break;
           	}
         }
         return flag;
      }
   }