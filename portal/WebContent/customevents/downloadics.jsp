<%@page import="com.eventbee.general.EbeeConstantsF"%>
<%@page import="java.io.BufferedOutputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.net.URLConnection"%>
<%@page import="java.net.URL"%>
<%@page language="java" trimDirectiveWhitespaces="true"%>
<%
String eventid=request.getParameter("event_id");
String type=request.getParameter("type");
eventid=eventid==null?"":eventid;
type=type==null?"":type;
try{
	String icalLocation=EbeeConstantsF.get("vcal.webpath","http://images.eventbee.com/images/vcal")+"/vcal_event_"+eventid+".ics";
	System.out.println("the ical Location::"+icalLocation);
			URL url = new URL(icalLocation);
			response.setContentType("application/x-download"); 
            response.setHeader("Content-Disposition", "attachment; filename="+type+".ics");
            URLConnection connection = url.openConnection();
            InputStream stream = connection.getInputStream();
            BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream());
            int len;
            byte[] buf = new byte[1024];
            while ((len = stream.read(buf)) > 0) {
                outs.write(buf, 0, len);
            }
            outs.close();
}catch(Exception e){
System.out.println("Exception Occured while downloading ics file:"+e.getMessage());	
}
 %>