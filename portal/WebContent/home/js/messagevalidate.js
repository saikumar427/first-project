function checkmessage(s1){
	s1=trim(s1);
      if(s1.length<=0){
	      alert("Message should not be empty");
	      return false;
      }else if (s1.length>5000){
            alert("Message should not exceed 5000 characters");
            return false; 
      }else{ 
          return true;
      }
 }  

function validatemessage(s1){
	s1=trim(s1);
      if(s1.length<=0){
	      alert("Message should not be empty");
	      return false;
      }else if (s1.length>5000){
            alert("Message should not exceed 5000 characters");
            return false; 
      }else{ 
          return true;
      }
 }  

function trim(s1)
 	{
		s1=ltrim(s1);
		s1=rtrim(s1);
		return s1;
 	}
function ltrim(s1)
 {
	for(i=0;i<s1.length;i++){
		if(s1.charAt(i)==' ' || s1.charAt(i)=='\t' || s1.charAt(i)=='\n'){

		}
		else{
			s1=s1.substr(i)
			break;
		}
		if(i==s1.length-1)
		s1="";
	}

	return s1;
 }
function rtrim(s1)
 {
	for(i=s1.length-1;i>=0;i--){
		if(s1.charAt(i)==' ' || s1.charAt(i)=='\t' || s1.charAt(i)=='\n'){
		}
		else{
			s1=s1.substring(0,i+1);
			break;
		}
		if(i==0)
		s1="";
	}
	return s1;
 }
 function reverse(s1)
 {
	 var r="";
	 for(i=s1.length-1;i>=0;i--)
	 {
		 r=r+s1.charAt(i);
	 }
	 return r;
 }
