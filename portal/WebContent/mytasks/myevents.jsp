<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%
String userid="";
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData !=null){
	userid=authData.getUserID();
}
String mgrtokenid=request.getParameter("mgrtokenid");
if(mgrtokenid==null||"null".equals(mgrtokenid))
mgrtokenid=DbUtil.getVal("select mgr_tokenid from manager_tokenids where userid=?",new String[]{userid});

if(mgrtokenid==null){
String mgrencodedid=EncodeNum.encodeNum(userid);
DbUtil.executeUpdateQuery("insert into manager_tokenids(userid,mgr_tokenid) values(?,?)",new String[]{userid,mgrencodedid});
mgrtokenid=mgrencodedid;
}
request.setAttribute("mgrtokenid",mgrtokenid);
String accounttype=DbUtil.getVal("select accounttype from authentication where user_id=?",new String[]{userid});
request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");
request.setAttribute("layout", "CUSTOM");
request.setAttribute("CUSTOM_LEFT_WIDTH", "610");
request.setAttribute("CUSTOM_RIGHT_WIDTH", "225");

%>


<%@ include file="/templates/beeletspagetop.jsp" %>

<%

com.eventbee.web.presentation.beans.BeeletItem item;       



item= new com.eventbee.web.presentation.beans.BeeletItem();
item.setBeeletId("mylinks");
item.setResource("/myevents/mylinks.jsp");
//leftItems.add(item);
item= new com.eventbee.web.presentation.beans.BeeletItem();
item.setBeeletId("apikey");
item.setResource("/rest/getKey.jsp");
//leftItems.add(item);

item= new com.eventbee.web.presentation.beans.BeeletItem();
item.setBeeletId("mythemes");
item.setResource("/customevents/mythemes.jsp");
//leftItems.add(item);
item= new com.eventbee.web.presentation.beans.BeeletItem();
item.setBeeletId("welcome");
item.setResource("/club/MemStatistics.jsp");
//rightItems.add(item);
item= new com.eventbee.web.presentation.beans.BeeletItem();
item.setBeeletId("contentbeelet");
item.setResource("/customconfig/logic/CustomContentBeelet.jsp?portletid=EBEE_EVENTS_C1&forgroup=13579");
rightItems.add(item);


item= new com.eventbee.web.presentation.beans.BeeletItem();
item.setBeeletId("mylistedevents");
item.setResource("/myevents/listedevents.jsp");
leftItems.add(item);

if(accounttype!=null){

item= new com.eventbee.web.presentation.beans.BeeletItem();
item.setBeeletId("My Event Groups");
item.setResource("/myevents/groupevents.jsp");
leftItems.add(item);

}


item= new com.eventbee.web.presentation.beans.BeeletItem();
item.setBeeletId("myregisteredevents");
item.setResource("/myevents/registeredevents.jsp");
leftItems.add(item);
item= new com.eventbee.web.presentation.beans.BeeletItem();
item.setBeeletId("streamer");
item.setResource("/eventstreaming/eventstreamer.jsp");
leftItems.add(item);
	
%>
      		
<%@ include file="/templates/beeletspagebottom.jsp" %>


