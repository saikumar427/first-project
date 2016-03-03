<% 
   String month=null;
   String year=null;
   String requestid=null;
   String isprevshown=null;
   String isreportshown=null;
   boolean flag=true;
   int setMonth=0;
   int setYear=0;
   int setDay=1;
   month=request.getParameter("setMonth");
   year=request.getParameter("setYear");
   requestid=request.getParameter("requestid");
   isprevshown=request.getParameter("prev");
   isreportshown=request.getParameter("report");
   java.util.Date d=new java.util.Date();
   if (month==null ||"".equals(month)){
        month=Integer.toString((d.getMonth()+1));
   }
   if (year==null || "".equals(year)){
        year=Integer.toString((d.getYear()+1900));
     }    
  String [] CurrentMonth=new String[]{"","January","February","March","April","May","June","July","August","September","October","November","December" };
   StringBuffer sb=new StringBuffer("");
   setMonth=Integer.parseInt(month);
   setYear=Integer.parseInt(year);
   if ("1".equals(requestid)){
        setMonth=setMonth+1;
       if (setMonth==13){
          setMonth=1;
          setYear=setYear+1;
       } 
    }
   if ("2".equals(requestid)){
        setMonth=setMonth-1;
       if (setMonth==0){
          setMonth=12;
          setYear=setYear-1;
       } 
    }
   sb.append(CurrentMonth[setMonth]);
   sb.append("");
   sb.append(setYear);
   if (setMonth==(d.getMonth()+1)){
       setDay=d.getDate();
    }

   if (("Yes".equals(isprevshown))&& (setMonth==(d.getMonth()+1))){
         flag=false;
   }

   if ("Yes".equals(isreportshown)){
         setDay=1;
   } 
 %>
<html>
<head> 
<title>Eventbee Calendar</title> 
<script type="text/javascript" language="JavaScript">
<!--
function clickDate(dy,mo,Yr) {
    	window.opener.selectDate(dy,mo,Yr);
	self.close();
 }

function submitForm(index){
	document.forms[0].action="/home/cal.jsp?requestid="+index;
	document.forms[0].submit();
	return true;	
}

//-->
</script>
</head> 
<body bgcolor="white"> 
<form method="post"  name="cal" action="/home/cal.jsp">
<input type="hidden" name="requestid" value="1"/>
<input type="hidden" name="setMonth" value="<%=setMonth%>"/>
<input type="hidden" name="setYear" value="<%=setYear%>"/>
<input type="hidden" name="prev" value="<%=isprevshown%>"/>
<input type="hidden" name="report" value="<%=isreportshown%>"/>
</form>
<jsp:useBean id="HtmlCal" scope="session" class="com.cj.htmlcal.HtmlCalendar"/> 
<%
  HtmlCal.setMonth(setMonth); 
  HtmlCal.setYear(setYear);
  for (int i=setDay;i<=31;i++){ 
      HtmlCal.setAction(i,"javascript:clickDate(" + i + ","+ setMonth + ","+ setYear+");",""); 
  } 
%> 

<table>
      <tr>
<td align="center">
<% if (flag){ %>
       <img src="images/cal_left.jpg" onClick="javascript:submitForm('2');"/>
<% } %>
<%=sb.toString()%>
<img onClick="javascript:submitForm('1');" src="images/cal_right.jpg"/>
</td>
      </tr>
 
  <tr><td nowrap> 
      <%=HtmlCal.getHtml()%> 
  </td></tr>
</table> 
  
<table width="160" border="0" cellpadding="0" cellspacing="0">
	<tr><td><img src="d.gif" width="1" height="12"></td></tr>
	<tr><td align="right"><a href="#" onclick="self.close();" class="close-link">Close window</a><br></td></tr>
</table>
</body> 
</html>
