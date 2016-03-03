<%
String ipAddress  = request.getHeader("X-FORWARDED-FOR");  
        if(ipAddress == null)  
        {  
          ipAddress = request.getRemoteAddr();  
        }  
        out.println("ipAddress:"+ipAddress);  

%>