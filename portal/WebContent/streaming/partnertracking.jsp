<%
String refid="";
String cpm="";
String newsession="";
boolean isnewsession=(session.getAttribute("partner_streamer_"+partnerid)==null);
String purpose="";
if(isnewsession)
{
session.setAttribute("partner_streamer_"+partnerid,"yes");
if(events!=null){
PartnerTracking pt=new PartnerTracking(events);
pt.setInsertionType("streamerimpressions");
pt.setPartnerId("partnerid");

pt.start();

}
}

%>