<%@ page import="java.lang.reflect.*" %>


<%


String classname="com.eventbee.event.ClubData";

if(request.getParameter("classname") !=null)
{
classname=request.getParameter("classname");
}else{

out.println("use classname parameter for searching class");

}
out.println("searching for classname="+classname+"<br/>");
try{


Class c=Class.forName(classname);

out.println("location of class:  "+c.getProtectionDomain().getCodeSource().getLocation()   );




Method[] metharr=c.getDeclaredMethods(); 

if(metharr !=null){

out.println("<br /> Methods:<br />");
for(int i=0;i<metharr.length;i++){

	out.println(metharr[i]+"<br />");
	
	

}


}



}catch(Exception exp){

out.println("from exception :"+exp.getMessage());

}

%>
