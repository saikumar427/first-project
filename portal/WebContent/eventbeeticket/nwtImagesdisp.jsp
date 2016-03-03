<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.photos.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.event.EventDB" %>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>

<% java.util.Date date=new java.util.Date();%>
<%!
	public Vector getNwtPhoros(String eventid,String type){


	String GET_NETWORK_SELLING_USER="select refid, ref_type, url, source,image_id from network_ticketselling_images where refid=?";
		if("mgr".equals(type))
			GET_NETWORK_SELLING_USER="select refid, ref_type, url, source,image_id from mgr_participant_images where refid=?";
	 
		DBManager dbmanager=new DBManager();
	 StatusObj stobj=dbmanager.executeSelectQuery(GET_NETWORK_SELLING_USER,new String[]{eventid});
	 
	 Vector v=new Vector();
		 if(stobj.getStatus()){
			for(int i=0;i<stobj.getCount();i++){
				HashMap hm=new HashMap();
				hm.put("refid",dbmanager.getValue(i,"refid",""));
				hm.put("ref_type",dbmanager.getValue(i,"ref_type",""));
				hm.put("url",dbmanager.getValue(i,"url",""));
				hm.put("source",dbmanager.getValue(i,"source",""));
				hm.put("image_id",dbmanager.getValue(i,"image_id",""));
				v.add(hm);
			}
			
		}		
	return v;			
 }

%>


<%

	String source_type=request.getParameter("source_type");
	 String groupid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","GROUPID","groupid","gid"});

	String grouptype=request.getParameter("grouptype");
	String type=request.getParameter("type");
	String width="33";
	if(type==null || "null".equals(type)){
		type="";
		width="44";	
		}
		
	String[] int_urls=null; 
	String[] img_ids=null; 
	String[] int_imgindices =null; 
if("yes".equals(request.getParameter("isnwtImageUpload"))){
	
	String INSERT_INTERNAL_IMAGES="insert into network_ticketselling_images(refid,ref_type,source,url,image_id) values(?,?,?,?,?)";
	if("mgr".equals(type))
		INSERT_INTERNAL_IMAGES="insert into mgr_participant_images(refid,ref_type,source,url,image_id) values(?,?,?,?,?)";
	if("inernal".equals(source_type)){
		try{
			int_imgindices = request.getParameterValues("nwtimage");
			int_urls = request.getParameterValues("urls");
			img_ids =  request.getParameterValues("imageids");			
			for(int i=0;i<int_imgindices.length; i++){
			   int index=Integer.parseInt(int_imgindices[i]);
			
		
				DbUtil.executeUpdateQuery(INSERT_INTERNAL_IMAGES, new String [] {groupid,grouptype,source_type,int_urls[index],img_ids[index]});
			}
		}catch(Exception e){
		
		System.out.println("error at internal url--->"+e.getMessage());
		}
	
	}
	if("external".equals(source_type)){
		try{
			img_ids =  request.getParameterValues("imageids");			
			int_urls = request.getParameterValues("urls");			
			
		DbUtil.executeUpdateQuery(INSERT_INTERNAL_IMAGES, new String [] {groupid,grouptype,source_type,request.getParameter("url_source"),request.getParameter("imageids")});
			
		}catch(Exception e){
		
			System.out.println("error at external url--->"+e.getMessage());
		}
	
	}


}
%>
<%
   Vector v= getNwtPhoros(request.getParameter("groupid"),type);
  
	String uploadurl="";
	String source="";
	String image_id="";
	HashMap hm=(HashMap)session.getAttribute("groupinfo");
	if(hm==null){
		groupid=request.getParameter("groupid");
	}else{  
		groupid=(String)hm.get("groupid"); 
	}
	String username="";
	HashMap evthm=EventDB.getEventInfo(groupid);
	if(evthm!=null){		
		username=(String)evthm.get("username");
	}
	
	String event_groupid=request.getParameter("event_groupid");
	
	String eventurl=DbUtil.getVal("select url from event_custom_urls where eventid=?",new String[]{groupid});
	
	String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
	if(eventurl==null){
		eventurl=ShortUrlPattern.get(username)+"/event?eid="+groupid;
	}
	if("mgr".equals(type)){
		eventurl=serveraddress+"/participate.jsp?eid="+groupid;
		}	
		
	if(!"null".equals(event_groupid) && event_groupid!=null){
	username=DbUtil.getVal("select login_name from authentication where user_id =(select userid from user_groupevents where event_groupid=?)",new String[]{event_groupid});
	eventurl=DbUtil.getVal("select url from event_custom_urls where eventid=?",new String[]{event_groupid});
		if(eventurl==null)
		eventurl=ShortUrlPattern.get(username)+"/event?eventid="+event_groupid;
		
	}
	
%>
<table>
<%
	if(v.size()>0){
	 	for(int i=0;i<v.size();i++){
	 		HashMap photosmap=(HashMap)v.get(i);
	 		uploadurl=GenUtil.getHMvalue(photosmap,"url","");
	 		source=GenUtil.getHMvalue(photosmap,"source","");
	 		image_id=GenUtil.getHMvalue(photosmap,"image_id","");
	 		
%>
<tr><td >
<%
String deleteMethodName="deleteImage";
if("mgr".equals(type)){
	deleteMethodName="deleteMgrImage";
}

%>
     <a href='<%=eventurl%>'><img border='0' src='<%=uploadurl%>' width="100" height="100"/></a> </td>
<td> <span style="cursor: pointer; text-decoration: underline" onclick="<%=deleteMethodName%>('<%=image_id%>','<%=request.getParameter("groupid")%>','<%=request.getParameter("event_groupid")%>');">Remove</span>
</td></tr>
<tr><td colspan="2">Copy and paste the following code into your blog or website:</td></tr>
<tr><td colspan="2"><textarea cols="<%=width%>" rows="3" onClick='this.select()'>
<a href='<%=eventurl%>'>
<img src="<%=uploadurl%>"></img></a>
</textarea>						 

  </td></tr>
<%	 	}
 	}	
	
%>
</table>