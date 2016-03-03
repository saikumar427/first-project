<%@ page import="java.util.*,java.sql.*,java.text.*,java.net.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.useraccount.*" %>
<%@ page import="com.eventbee.profiles.*" %>
<%@ page import="com.eventbee.nuser.*" %>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.editprofiles.*"%>
<%@ page import="com.eventbee.nuser.*"%>
<%@ page import="com.eventbee.guestbook.*"%>
<%@ page import="com.eventbee.customconfig.MemberFeatures" %>
<%@ page import="com.eventbee.hub.hubDB" %>
<%@ page import="com.eventbee.comments.*"%>
<%@ page import="com.eventbee.classifieds.*"%>
<%@ page import="com.eventbee.contentbeelet.*"%>

<%!

String regevents="select distinct a.eventid,a.eventname,c.pblview_ok,a.listtype from "
	       +"  eventinfo a,eventattendee c where a.eventid=c.eventid "
		+" and c.authid=? ";

String rsvpevents="select distinct a.eventid,a.eventname,a.listtype from "
	       +"  eventinfo a,rsvpattendee c where a.eventid=c.eventid "
		+" and c.authid=? ";

String listedevents="select distinct a.eventid,a.eventname,a.pblview_ok,a.listtype,a.status  from "
	       +"  eventinfo a  "
		+"where   a.mgr_id=? ";



Vector getEvents(String userid,String query){
Vector v=new Vector();
DBManager dbmanager=new DBManager();
	 		StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{userid});
	 		if(statobj.getStatus()){
	 			String [] columnnames=dbmanager.getColumnNames();
	 				for(int i=0;i<statobj.getCount();i++){
	 					HashMap hm=new HashMap();
	 					for(int j=0;j<columnnames.length;j++){
	 						hm.put(columnnames[j],dbmanager.getValue(i,columnnames[j],""));
	 					}
	 					v.add(hm);
	 				}
	 		}
	 		return v;
	 	}



    public String  getMemberScrName(String userid){
    		String scrname="none";
    		if(userid !=null)
    		scrname=DbUtil.getVal("select getMemberPref(?,'pref:myurl','') as scrname", new String[]{userid});
    		
    		return scrname;
    	
	}



static String PHOTOS_QUERY=
"select uploadurl,photo_size,caption,b.location_code  from member_photos a,member_photos_location b where a.user_id =? and a.photo_id=b.photo_id and status not in ('decline') " ;


// profile template method is at the bottom in the defnation block

String MEMBER_LOCATION_PHOTO="select uploadurl,'' as gender from member_photos a,member_photos_location b where a.user_id=? and a.photo_id=b.photo_id and location_code=?"
   + " union "  
   + " select 'nophoto' as uploadurl,a.gender as gender from user_profile a "
   + " where a.user_id =? and user_id not in (select a.user_id from member_photos_location a,member_photos b where location_code=?  and a.photo_id=b.photo_id and a.user_id is not null)";
	
	public Map getPhotos(String userid){
	  		Map photomap=new HashMap();
	  		DBManager dbmanager=new DBManager();
	  		StatusObj statobj=dbmanager.executeSelectQuery(MEMBER_LOCATION_PHOTO,new String[]{userid,"slot2",userid,"slot2"});
	  		int recount=0;
	  		
	  		if(statobj !=null && statobj.getStatus() && (recount=statobj.getCount())>0){
	  			  		
	    				photomap.put("uploadurl",dbmanager.getValue(0,"uploadurl",""));
	  				photomap.put("gender",dbmanager.getValue(0,"gender",""));
	  
	  			
	  		}
	  		return photomap;
	}



public String getProfile(Map hm, boolean displaycontent){
StringBuffer sb=new StringBuffer();
if(displaycontent){


sb.append(" <table width='100%' class='block' height='100%'> ") ;
sb.append(" 	<tr><td valign='top'> ");
			
sb.append(" 	<table width='100%'> " );
			
		sb.append("<tr>" );
		if(!GenUtil.getEncodedXML((String)hm.get("companyname")).equals("")){
			sb.append(" <td class='userprofilelabel' width='15%' valign='top'>Company</td> " );
			sb.append(" <td class='userprofilevalue' width='35%'>"+GenUtil.getEncodedXML((String)hm.get("companyname"))+"</td> ");
			}
		if(!GenUtil.getEncodedXML((String)hm.get("title")).equals("")){	
			sb.append(" 	<td class='userprofilelabel' width='15%' valign='top'>Title</td> " );
			sb.append(" 	<td class='userprofilevalue' width='35%'>"+GenUtil.getEncodedXML((String)hm.get("title"))+"</td>" );
			}
		sb.append("</tr>" );

		sb.append("<tr>" );
		if(!GenUtil.getEncodedXML((String)hm.get("city")).equals("")){
		sb.append(" 	<td class='userprofilelabel' valign='top'>City</td> ");
		sb.append(" 	<td class='userprofilevalue'>"+GenUtil.getEncodedXML((String)hm.get("city"))+"</td> " );
		}
		if(!GenUtil.getEncodedXML((String)hm.get("state")).equals("")){
		sb.append(" 	<td class='userprofilelabel' valign='top'>State</td>" );
		sb.append(" 	<td class='userprofilevalue'>"+GenUtil.getEncodedXML( ("-1".equals( (String)hm.get("state")))?"Outside USA":(String)hm.get("state")     )+"</td> ");
		}
		sb.append("</tr>" );
		
			
		sb.append("<tr>" );
		if(!GenUtil.getEncodedXML((String)hm.get("country")).equals("")){
		sb.append(" 	<td class='userprofilelabel' valign='top'>Country</td>" );
		sb.append(" 	<td class='userprofilevalue'>"+GenUtil.getEncodedXML((String)hm.get("country"))+"</td>" );
		}
		if(!GenUtil.getEncodedXML((String)hm.get("zip")).equals("")){
		sb.append(" 	<td class='userprofilelabel' valign='top'>Zip</td>" );
		sb.append(" 	<td class='userprofilevalue'>"+GenUtil.getEncodedXML((String)hm.get("zip"))+"</td> ");
		}
		sb.append("</tr>" );

		String compurldis=GenUtil.getEncodedXML((String)hm.get("companyurl"));
		String perurldis=GenUtil.getEncodedXML((String)hm.get("personalurl"));
				
			
		sb.append("<tr>" );
		if(!compurldis.equals("")){
		sb.append(" 	<td class='userprofilelabel' valign='top'>Company URL</td>" );
		
		sb.append(" 	<td class='userprofilevalue'> ");
		sb.append( 	( (compurldis !=null) && (compurldis.length()>10) && ( compurldis.startsWith("http://") )  )?"<a href='"+compurldis+"'>"+compurldis+"'</a>" :  ""+compurldis );  
		sb.append(" 	</td>");
		}
		
		if(!perurldis.equals("")){
		sb.append(" 	<td class='userprofilelabel' valign='top'>Personal URL</td>");
		sb.append(" 	<td class='userprofilevalue'>");
		sb.append( ( (perurldis !=null) && (perurldis.length()>10) && ( perurldis.startsWith("http://") )  )?"<a href='"+perurldis+"' >"+perurldis+"</a>" :  ""+perurldis );
		sb.append(" 	</td>");
		}
		sb.append("</tr>" );

		sb.append("<tr>" );
		if(!GenUtil.getEncodedXML((String)hm.get("industry")).equals("")){
		sb.append(" 	<td class='userprofilelabel' valign='top'>Industry</td> ");
		sb.append(" 	<td class='userprofilevalue'>"+GenUtil.getEncodedXML((String)hm.get("industry"))+"</td> ");
		}
		if(!GenUtil.getEncodedXML((String)hm.get("interests")).equals("")){
		sb.append(" 	<td class='userprofilelabel' valign='top'>Interests</td> ");
		sb.append(" 	<td class='userprofilevalue'>"+GenUtil.getEncodedXML((String)hm.get("interests"))+"</td>");
		}
		sb.append("</tr>" );

		sb.append("<tr>" );
		if(!GenUtil.getEncodedXML((String)hm.get("education")).equals("")){
		sb.append(" 	<td class='userprofilelabel' valign='top'>Education</td> ");
		sb.append(" 	<td class='userprofilevalue'>"+GenUtil.getEncodedXML((String)hm.get("education"))+"</td>" );
		}
		if(!GenUtil.getEncodedXML((String)hm.get("eduarea")).equals("")){
		sb.append(" 	<td class='userprofilelabel' valign='top'>Major</td>" );
		sb.append(" 	<td class='userprofilevalue'>"+GenUtil.getEncodedXML((String)hm.get("eduarea"))+"</td>");
		}
		sb.append("</tr>" );


sb.append("<tr>" );

if((!GenUtil.getEncodedXML((String)hm.get("university1")).equals(""))||(!GenUtil.getEncodedXML((String)hm.get("university2")).equals(""))){
sb.append(" 	<td class='userprofilelabel' valign='top'> University</td>");
sb.append(" 	<td class='userprofilevalue'>");

				sb.append(" 	<table class='userprofilevalue' cellspacing='0' cellpadding='0' border='0'>");
				
				if(!("".equals(hm.get("university1"))))
				{
				
					sb.append(" 	<tr><td>"+GenUtil.getEncodedXML((String)hm.get("university1"))+"</td>");
					
					if(!("".equals(hm.get("univyear1"))))
					sb.append(" 	<td>("+GenUtil.getEncodedXML((String)hm.get("univyear1"))+")</td>");
					sb.append("</tr>");
				}
				if(!("".equals(hm.get("university2"))))
				{
				
					sb.append(" 	<tr><td>"+GenUtil.getEncodedXML((String)hm.get("university2"))+"</td>");
					
					if(!("".equals(hm.get("univyear2"))))
					sb.append(" 	<td>("+GenUtil.getEncodedXML((String)hm.get("univyear2"))+")</td>");
					sb.append(" 	</tr>");
				}
				
				sb.append(" 	</table>");


sb.append(" 	</td>");
}
sb.append("</tr>" );


			
	sb.append(" 	<tr>");
	if((!GenUtil.getEncodedXML((String)hm.get("company1")).equals(""))||(!GenUtil.getEncodedXML((String)hm.get("company2")).equals(""))||(!GenUtil.getEncodedXML((String)hm.get("company3")).equals(""))){
	sb.append(" 	<td class='userprofilelabel' valign='top'>Previous Companies</td>");

		sb.append(" 	<td class='userprofilevalue'>");
		sb.append(" 	<table  cellspacing='0' cellpadding='0' border='0'>");
		
		if(!("".equals(hm.get("company1"))))
		{
		
			sb.append(" 	<tr><td >"+GenUtil.getEncodedXML((String)hm.get("company1"))+"</td><td>" );
		
		if(!("".equals(hm.get("fromyear1"))))
			sb.append("("+GenUtil.getEncodedXML((String)hm.get("fromyear1")) );
		else if(!("".equals(hm.get("toyear1"))))
			sb.append(("(") );
		


			if(!("".equals(hm.get("fromyear1")))&&!("".equals(hm.get("toyear1"))))
			sb.append("-");
			if(!("".equals(hm.get("toyear1"))))
				sb.append(""+GenUtil.getEncodedXML((String)hm.get("toyear1"))+"  )" );
			else if(!("".equals(hm.get("fromyear1"))))
				sb.append(")");
			sb.append("</td>");
			sb.append("</tr>");
		}//end of comp
		
		if(!("".equals(hm.get("company2"))))
		{
			sb.append( "<tr>");
			sb.append( "<td >"+GenUtil.getEncodedXML((String)hm.get("company2"))+"</td><td>");
			
			if(!("".equals(hm.get("fromyear2"))))
				sb.append("("+GenUtil.getEncodedXML((String)hm.get("fromyear2")));
			else if(!("".equals(hm.get("toyear2"))))
				sb.append("(");
			
			if(!("".equals(hm.get("fromyear2")))&&!("".equals(hm.get("toyear2"))))
			sb.append("-");
			
	
			if(!("".equals(hm.get("toyear2"))))
				sb.append(""+GenUtil.getEncodedXML((String)hm.get("toyear2"))+")" );
			else if(!("".equals(hm.get("fromyear2")))){
				sb.append(")");
			}
			
			sb.append("</td>");
			sb.append("</tr>");
		}// end of comp2
		
		
		if(!("".equals(hm.get("company3"))))
		{
		
			sb.append("<tr><td >"+GenUtil.getEncodedXML((String)hm.get("company3"))+"</td>");
			sb.append("<td>");
			if(!("".equals(hm.get("fromyear3"))))
				sb.append("("+GenUtil.getEncodedXML((String)hm.get("fromyear3")) );
			else if(!("".equals(hm.get("toyear3"))))
				sb.append("(");
			
			if(!("".equals(hm.get("fromyear3")))&&!("".equals(hm.get("toyear3"))))
			sb.append("-");
			
			
			if(!("".equals(hm.get("toyear3"))))
			sb.append(""+GenUtil.getEncodedXML((String)hm.get("toyear3"))+")" );
			
			else if(!("".equals(hm.get("fromyear3")))){
				sb.append(")");
			}
			
			sb.append("</td>");
			sb.append("</tr>");

		}//end ofcomp3
		
		
		sb.append("</table>");
	sb.append("</td>");
	}
	sb.append("</tr>");


			   sb.append("</table>");
			   
		sb.append("</td>");
	sb.append("</tr>");
	   

			   sb.append("</table>");

			}//else noshare
			else{

				sb.append("<table width='100%' class='block' height='100%'>");					
					sb.append("<tr><td valign='center' align='left'>Profile Hidden</td></tr>");
				sb.append("</table>");

			}//yes share else end
			
			
			
			//out.println(sb.toString());
			return sb.toString();
}
%>

<%

//String imgpath=EbeeConstantsF.get("smallthumbnail.photo.image.webpath","http://www.desihub.com:8888/home/images/smallthumbnail");

String uploadurl=null;
String gender=null;
String imgsrc="";

String userid=(String)request.getAttribute("userid");        //(request.getParameter("userid")!=null)?request.getParameter("userid") :"12370";


//String unitid=request.getParameter("UNITID");      //"13579";
int displayLimit=10;
//userid="14809";

//userid="-1";
//userid="14829";
//swapna 14829
String appname="portal";


String userunitid="13579";
String userfirstname="";
String userlastname="";
String userfullname="";
String username=" ";
String userprofilename="";


String pitch="";


String userActive=DbUtil.getVal("select acct_status from authentication where user_id=?",new String[]{userid});


if("1".equals(userActive)  ||  userid=="-1" ){

%>

<%

String fromuserid="";
Authenticate authData=(Authenticate)com.eventbee.general.AuthUtil.getAuthData(pageContext);
		if(authData!=null){
			fromuserid=authData.getUserID();
			
		}


UserInfo usrInfo=AccountDB.getUserProfile(userid);

HashMap hm=new HashMap();
if(usrInfo!=null || userid=="-1"){


	if(usrInfo!=null){
	hm.put("statement",usrInfo.getStatement());
					hm.put("processedstatement",usrInfo.getProcessedStatement());
					hm.put("gender",usrInfo.getGender());
					hm.put("loginname",usrInfo.getLoginName());
					hm.put("photourl",usrInfo.getPhotoURL());
					hm.put("personalurl",usrInfo.getPersonalURL());
					hm.put("blogurl",usrInfo.getBlogURL());
					hm.put("companyname",usrInfo.getCompany());
					hm.put("title",usrInfo.getTitle());
					hm.put("companyurl",usrInfo.getCompanyURL());
					hm.put("city",usrInfo.getCity());
					hm.put("state",usrInfo.getState());
					hm.put("country",usrInfo.getCountry());
					hm.put("zip",usrInfo.getZip());
					hm.put("education",usrInfo.getEducation());
				        hm.put("eduarea",usrInfo.getEduArea());
					hm.put("university",usrInfo.getUniversity());
					hm.put("industry",usrInfo.getIndustry());
					hm.put("interests",usrInfo.getInterests());
					hm.put("unitid","13579");
					hm.put("company1",usrInfo.getCompany1());
					
					hm.put("company2",usrInfo.getCompany2());
					hm.put("company3",usrInfo.getCompany3());
					hm.put("fromyear1",usrInfo.getFromyear1());
					hm.put("fromyear2",usrInfo.getFromyear2());
					hm.put("fromyear3",usrInfo.getFromyear3());
					hm.put("toyear1",usrInfo.getToyear1());
					hm.put("toyear2",usrInfo.getToyear2());
					hm.put("toyear3",usrInfo.getToyear3());
					hm.put("university1",usrInfo.getUniversity1());
					
					hm.put("university2",usrInfo.getUniversity2());
					
					hm.put("univyear1",usrInfo.getUnivyear1());
					hm.put("univyear2",usrInfo.getUnivyear2());

					if(!userid.equals(fromuserid)){


						HashMap visitHash=new HashMap();
						visitHash.put("userid",userid);
						visitHash.put("fromuserid",fromuserid);
						visitHash.put("sid",session.getId());
						int rcount=ProfileDB.insertProfileVisitor(visitHash);
					}
	
	}


	userunitid=(usrInfo!=null)?usrInfo.getUnitId():userunitid;
	userfirstname=(usrInfo!=null)?usrInfo.getFirstName().trim():userfirstname;
	userlastname=(usrInfo!=null)?usrInfo.getLastName().trim():userlastname;
	userfullname=(userfirstname+" "+userlastname).trim();
	userprofilename=(usrInfo!=null)?usrInfo.getLoginName().trim():userprofilename;
	 request.setAttribute("USERUNITID","13579");
	request.setAttribute("USERFIRSTNAME",userfirstname);
	request.setAttribute("USERLASTNAME",userlastname);
	request.setAttribute("USERFULLNAME",userfullname);
	request.setAttribute("USERPROFILENAME",userprofilename);
	if(usrInfo !=null)
	 	pitch=(usrInfo.getProcessedStatement()!=null)?usrInfo.getProcessedStatement():"";
	 
	request.setAttribute("PITCH",pitch);


String Bloglink="<a href='"+ShortUrlPattern.get(userprofilename)+"/blog'>Blog Page</a>";
String photoslink="<a href='"+ShortUrlPattern.get(userprofilename)+"/photos'>Photos Page</a>";
String communitylink="<a href='"+ShortUrlPattern.get(userprofilename)+"/community'>Community Page</a>";
String eventslink="<a href='"+ShortUrlPattern.get(userprofilename)+"/events'>Events Page</a>";


request.setAttribute("BLOGLINK",Bloglink);
request.setAttribute("PHOTOSLINK",photoslink);
request.setAttribute("COMMUNITYLINK",communitylink);
request.setAttribute("EVENTSLINK",eventslink);
	



response.sendRedirect(ShortUrlPattern.get(userprofilename)+"/events");



%>


	<%
	
	
		com.eventbee.general.StatusObj stobj=DbUtil.getKeyValues("select pref_name,pref_value from member_preference where user_id=? ",new String[]{userid});
		Map prefMap=new HashMap();
		if(stobj.getCount()>0)
		prefMap=(HashMap) stobj.getData();
		
		MemberFeatures featuresofunitreq=new MemberFeatures( "13579");
		List featuresofunit=new ArrayList();
	
	
	%>
	
	
	<%
	if(!"yes".equals(request.getParameter("signup"))){
	
	if(featuresofunitreq.isFeatureConfigured("network")){
		if("Yes".equals(GenUtil.getHMvalue(prefMap,"network.allowcontacts","Yes"))){
			featuresofunit.add("<a href='"+"/"+appname+"/auth/listauth.jsp?purpose=mycontact&amp;tofriendid="+userid+"'>Add as Friend</a>");
		}
	}
	
	if("Yes".equals(GenUtil.getHMvalue(prefMap,"network.allowsendmessage","Yes"))){
		featuresofunit.add("<a href='"+"/"+appname+"/auth/listauth.jsp?purpose=sendsms&amp;msgto="+userid+"'>Send Message</a>" );
	}

				
	
	
		if(("Yes".equals(GenUtil.getHMvalue(prefMap,"network.allowinviteevent","Yes")))){ 
			if("yes".equalsIgnoreCase(DbUtil.getVal("select getMemberPref(?,'gok','yes')",new String[]{userid}))) { 
			featuresofunit.add( "<a href='"+"/"+appname+"/auth/listauth.jsp?invitedid="+userid+"&amp;purpose=invitetoevent"+"' >Invite to Event</a>" );
			}
		}
		
			String club_title=EbeeConstantsF.get("club.label","Community"); 
			featuresofunit.add("<a href='"+"/"+appname+"/auth/listauth.jsp?invitedid="+userid+"&amp;purpose=invitetohub"+"' >Invite to "+EventbeeStrings.getDisplayName(club_title,"Community")+"</a>" );
		
		}
		
		
		request.setAttribute("FEATURESOFUNIT",featuresofunit);
		
	%>
	
	
	

<%--="features of unit based on pref:"+featuresofunit+"<br />" --%>
<%--end of unit feature req --%>


<%-- profile --%>
<%
String shareprofile="No";
if(usrInfo !=null){
shareprofile=(usrInfo.getShareProfile()!=null)?usrInfo.getShareProfile():"No";
}
//out.println("shareprofile"+shareprofile);

if("Yes".equalsIgnoreCase(shareprofile) ){
request.setAttribute("PROFILECONTENT",  getProfile(hm,true)  );

}else{
request.setAttribute("PROFILECONTENT",  getProfile(hm,false)  ); 

}

%>

<%--end of  profile --%>



<%-- friends --%>
<%

if(featuresofunitreq.isFeatureConfigured("network")){

Map userpref=NUserDb.getUserPref(userid);

String imgpath=EbeeConstantsF.get("smallthumbnail.photo.image.webpath","http://www.desihub.com:8888/home/images/smallthumbnail");

String dissharefrien=(userpref.get("network.sharefriends")==null)?"Yes":(String)userpref.get("network.sharefriends");

List friendslst=new ArrayList();
List imglst=new ArrayList();
//
if("Yes".equalsIgnoreCase(dissharefrien)){
	//out.println("dissharefrien"+dissharefrien+"<br />");
	List nuser=NUserDb.getFriends(userid);
	
	Map pmap=null;
	if(nuser !=null){
		for(Iterator friendsiter=nuser.iterator();friendsiter.hasNext(); ){
			NUser nusr=(NUser)friendsiter.next();
			if(nusr !=null){
			
			    pmap=getPhotos(nusr.getUserId());
			    		
			    uploadurl=(String)pmap.get("uploadurl");
			    gender=(String)pmap.get("gender");
			     			
			    if("nophoto".equals(uploadurl)){
			    if("male".equalsIgnoreCase(gender))
			    imgsrc="/home/images/male_thumb.gif";
			    if("female".equalsIgnoreCase(gender))
			    imgsrc="/home/images/female_thumb.gif";
			    
			    }
			    
			    else 
			    imgsrc=imgpath+"/"+uploadurl;


			    Map imap=new HashMap();
			    String name="<a href='"+"/"+appname+"/editprofiles/networkuserprofile.jsp?userid="+nusr.getUserId()+"'>"+GenUtil.getEncodedLT(nusr.getUserName())+"</a>";
			    imgsrc="<a href='"+"/"+appname+"/editprofiles/networkuserprofile.jsp?userid="+nusr.getUserId()+"'>"+"<img border='0' src="+imgsrc+" /></a>" ;
			    imap.put("imgsrc",imgsrc);
			    imap.put("name",name);
			    //friendslst.add("<a href='"+"/"+appname+"/editprofiles/networkuserprofile.jsp?userid="+nusr.getUserId()+"&amp;UNITID="+userunitid+"'>"+"<img border='0' src="+imgsrc+" /><br/>"+GenUtil.getEncodedLT(nusr.getUserName())+"</a>";
			    friendslst.add(imap);
			    //friendslst.add("<a href='"+"/"+appname+"/editprofiles/networkuserprofile.jsp?userid="+nusr.getUserId()+"&amp;UNITID="+userunitid+"'>"+imap+"</a>" );
			}
			
		}
	}
	
	
	
	
	
	
}
//System.out.println("friendslst="+friendslst);
//request.setAttribute("IMGLIST",imglst);
request.setAttribute("FRIENDSLIST",friendslst);


}
%>

<jsp:include page='/main/Themebeeheader.jsp' />
<jsp:include page='/main/eventfooter.jsp' />






<%-- end of friends --%>

<%--guestbook  --%>
<%
if(featuresofunitreq.isFeatureConfigured("guestbook")){
	Map pref=PreferencesDB.getUserPref(userid,"guestbook.%");
	Vector guestdetail=GuestBookDB.getMyGuestBook(userid);
	int limit=displayLimit;
	String guestbooksignuplink="";
	
	if(!"No".equalsIgnoreCase((String)pref.get("guestbook.allowsignup"))){
		guestbooksignuplink="<a href='"+"/portal/auth/listauth.jsp?userid="+userid+"&purpose=guestbook"+"'>Sign  Guestbook</a>";
	}

	//out.println("guestbooksignuplink="+guestbooksignuplink);
	request.setAttribute("GUESTBOOKSIGNUPLINK",guestbooksignuplink);




 if((guestdetail!=null) && (guestdetail.size()>0)){

 	List guestbooklist=new ArrayList();

	boolean isshown=true;

	if(limit>guestdetail.size())	limit=guestdetail.size();
	for(int i=0;i<limit;i++){
		HashMap guest=(HashMap)guestdetail.elementAt(i);   
		String clazz="";
		if(("Reference".equals((String)guest.get("type"))) && ("No".equals((String)pref.get("guestbook.references.show")))){
			isshown=false;
			
		}
		if(("Feel Good".equalsIgnoreCase((String)guest.get("type")))&& ("No".equalsIgnoreCase((String)pref.get("guestbook.feelgood.show")))){
		
		isshown=false;
		}
		
		if(isshown){
			Map guestcontentmap=new HashMap();
			String guestbiiokmessage=GenUtil.textToHtml((String)guest.get("message"), true);
			guestcontentmap.put("message",guestbiiokmessage);
			guestcontentmap.put("type",(String)guest.get("type") );
			
			clazz=("Feel Good".equalsIgnoreCase((String)guest.get("type")))?"guestbookreference":"guestbookfeelgood";
			guestcontentmap.put("class",clazz);
			
			guestcontentmap.put("msgdate",(String)guest.get("msgdate") );
			String userlink="<a href='/portal/editprofiles/networkuserprofile.jsp?userid="+(String)guest.get("userid")+"' >"+(String)guest.get("firstname")+" "+ (String)guest.get("lastname")+"</a>";
			guestcontentmap.put("userlink",userlink);
			
			
			guestbooklist.add(guestcontentmap);
			
		}//end if isshoen
	     
	}//end for
 
	//out.println("<br />start of guest book messages:"+guestbooklist+"<br/> -- end of <br/>");
	
	
	request.setAttribute("GUESTBOOKLIST",guestbooklist);

    }//end if guest details size>0
    
    
    }// confiqured for unit
%>

<%--end of guestbook  --%>











<%-- lifestyle photos --%>

<%
DBManager dbmanager=new DBManager();
		StatusObj statobj1=dbmanager.executeSelectQuery( PHOTOS_QUERY,new String[]{userid} );
		int recordcount=0;
		if(statobj1 != null) recordcount=statobj1.getCount();
		Map slotphototmap=new HashMap();
		if(recordcount>0){
			for(int i=0;i<recordcount;i++){
				String locationcode=dbmanager.getValue(i,"location_code",null);
				if(locationcode !=null)
				slotphototmap.put(locationcode,""+i);
			}

		}


%>
<%

Map lifestylephoto=new HashMap();
String photocaption="";
String photolink="";
if(slotphototmap.get("slot2") !=null){
	String index=slotphototmap.get("slot2").toString() ;
	int intindex=-1;
	try{
		intindex=Integer.parseInt(index);
	}catch(Exception exp){
	}
	
	if(intindex != -1){
		String tempimgdisp=dbmanager.getValue(intindex,"uploadurl","");
		String imgpath=dbmanager.getValue(intindex,"photo_size","big.photo.image.webpath");
		
		if(! ("".equals(tempimgdisp)) ){
			tempimgdisp=EbeeConstantsF.get(imgpath,"thumbnail.photo.image.webpath")+"/"+tempimgdisp;
			
			photolink="<img src='"+tempimgdisp+"' alt='No Photo Available'/>";
			 
			 photocaption=GenUtil.getEncodedXML(dbmanager.getValue(intindex,"caption","") );
		
		}
	}//!=-1
	
}//!=null

lifestylephoto.put("photolink",photolink);
lifestylephoto.put("photocaption",photocaption);
request.setAttribute("LIFESTYLEPHOTO",lifestylephoto);

%>
<%-- lifestyle photos end--%>
<% /* ######## YAHOO AND GOOGLE ADS FOR EVENTS PAGE 04/04/2007  added by rajesh #######*/
String content="";
HashMap customcontent_yahooad=null;
customcontent_yahooad=CustomContentDB.getCustomContent("THEME_YAHOO_AD", "13579");
if(customcontent_yahooad!=null){
 content=GenUtil.getHMvalue(customcontent_yahooad,"desc" );
}
if(content==null)content="";
request.setAttribute("YAHOOADS",content);


HashMap customcontent_ad=null;
customcontent_ad=CustomContentDB.getCustomContent("THEME_GOOGLE_AD", "13579");
if(customcontent_ad!=null){
content=GenUtil.getHMvalue(customcontent_ad,"desc" );
}
if(content==null)content="";
request.setAttribute("GEOOGLEADS",content);
/*####### END OF YAHOO AND GOOGLE ADS CONTENT ############*/


%>













<%-- rsvpd events --%>


<%
//http://www.desihub.com:8888/portal/eventdetails/eventdetails.jsp?UNITID=13579&GROUPID=15461
request.setAttribute("LABELEVENTSRSVPD","Events RSVPd");
List rsvpdevents=new ArrayList();
if("Yes".equalsIgnoreCase(GenUtil.getHMvalue(prefMap,"mypage.rsvpevents.show","Yes"))){ 
                      
			Vector myevts=getEvents(userid,rsvpevents);
			
			int limit=displayLimit;
			if(myevts!=null){
				int esize=myevts.size();
				if(limit>esize)	limit=esize;
				if(limit>0){
				String viewalleventsrsvpd="";
		  		if(limit<esize){
				
					viewalleventsrsvpd="<a href='"+"/portal/guesttasks/pagersvpevents.jsp?userid="+userid+"'>View All ("+esize+")</a>";
				}
				
				request.setAttribute("VIEWALLEVENTSRSVPD",viewalleventsrsvpd);
				
				
				for(int z=0;z<limit;z++){
					HashMap evthm=(HashMap)myevts.elementAt(z);	
					String evtname=(String)evthm.get("eventname");
					String listtype=(String)evthm.get("listtype");
						String refer="/"+appname+"/eventdetails/eventdetails.jsp?GROUPID="+(String)evthm.get("eventid");

					String rsvpdevent="<a href='"+GenUtil.getEncodedXML(refer)+"'>"+GenUtil.getEncodedXML(evtname)+"</a>";
					
					if("PBL".equals(listtype))
					rsvpdevents.add(rsvpdevent);
					
				
				}//end for
				
						

				}//limit>0
			   }//endif events =null

}

request.setAttribute("RSVPDEVENTS",rsvpdevents);

%> 


<%-- rsvpd events end--%>




<%-- events registered --%>

<%
request.setAttribute("LABELEVENTSREGISTERED","Events Registered");

List eventsregistered=new ArrayList();
if("Yes".equalsIgnoreCase(GenUtil.getHMvalue(prefMap,"mypage.registeredevents.show","Yes"))){
                       
			Vector myevts=getEvents(userid,regevents);
			
			int limit=displayLimit;
			if(myevts!=null){
				int esize=myevts.size();
				String viewalleventsregistered="";
				if(limit>esize){
					limit=esize;
				}
				
				if(limit>0){
					if(limit<esize){
						viewalleventsregistered="<a href='"+"/portal/guesttasks/pageregisteredevents.jsp?userid="+userid+"'>View All ("+esize+")</a>";
					
					}
				request.setAttribute("VIEWALLEVENTSREGISTERED",viewalleventsregistered);

				for(int z=0;z<limit;z++){
					HashMap evthm=(HashMap)myevts.elementAt(z);	
					
					String evtname=(String)evthm.get("eventname");
					String view=(String)evthm.get("pblview_ok");
					String listtype=(String)evthm.get("listtype");
					
					if(("".equals(view)||"yes".equals(view))&&"PBL".equals(listtype)){
					String refer="/"+appname+"/eventdetails/eventdetails.jsp?GROUPID="+(String)evthm.get("eventid");

					String eventreg="<a href='"+GenUtil.getEncodedXML(refer)+"' >"+GenUtil.getEncodedXML(evtname)+"</a>";
					
					
					eventsregistered.add(eventreg);
					}
				}		

				}
			   }



}

request.setAttribute("EVENTSREGISTERED",eventsregistered);

%>
 

<%-- events registered  end--%>





<%--events listed --%>

<%


request.setAttribute("LABELEVENTSLISTED","Events Listed");

List eventslisted=new ArrayList();

if("Yes".equalsIgnoreCase(GenUtil.getHMvalue(prefMap,"mypage.listedevents.show","Yes"))){
	
	Vector mylistedevts=getEvents(userid,listedevents);
	
	int limit=displayLimit;
	
	if(mylistedevts!=null){
		int esize=mylistedevts.size();
		
		String viewalleventslisted="";
		if(limit>esize){
			limit=esize;
		}
		
		if(limit>0){
			if(limit<esize){
				viewalleventslisted=  "<a href='"+"/portal/guesttasks/pagelistedevents.jsp?userid="+userid+"'>View All ("+esize+")</a>";
			}
			
			
			request.setAttribute("VIEWALLEVENTSLISTED",viewalleventslisted);
			for(int z=0;z<limit;z++){
				HashMap evthm=(HashMap)mylistedevts.elementAt(z);
				String listview=(String)evthm.get("pblview_ok");
				String listtype=(String)evthm.get("listtype");
				String status=(String)evthm.get("status");	
				if(("".equals(listview)||"yes".equals(listview))&&("PBL".equals(listtype))&&("ACTIVE".equals(status)||"CLOSED".equals(status))){

				String refer="/"+appname+"/eventdetails/eventdetails.jsp?GROUPID="+GenUtil.getHMvalue(evthm,"eventid","",false);
		                
				String listedevent="<a href='"+GenUtil.getEncodedXML(refer)+"' >"+GenUtil.getHMvalue(evthm,"eventname","",true)+"</a>";
				eventslisted.add(listedevent);
				}
			}//end for		
		}//edf if limit>0
	   }// !=null
}

request.setAttribute("EVENTSLISTED",eventslisted);

%>


<%--events listed  end--%>


<%-- moderated hubs --%>

<%

String club_title=EbeeConstantsF.get("club.label","Community");
String labelmoderatedhubs="Moderated "+EbeeConstantsF.get("club.label1","Communities");

request.setAttribute("LABELMODERATEDHUBS",labelmoderatedhubs);
List moderatedhubs=new ArrayList();
if("Yes".equalsIgnoreCase(GenUtil.getHMvalue(prefMap,"mypage.moderatedhubs.show","Yes"))){

			String Query="select cm.clubid from club_member cm,clubinfo c where userid=? and ismgr='true' "
				+" and cm.status in ('ACTIVE','PENDING') and cm.clubid=c.clubid and c.status in ('ACTIVE')";
			Vector myListedHubs=hubDB.getHubs(Query,new String[]{userid});
			int limitdisplay=displayLimit;
			if(myListedHubs!=null){
				int esize=myListedHubs.size();
				
				String viewallmoderatedhubs="";
				
				if(limitdisplay>esize){
					limitdisplay=esize;
				}
				if(limitdisplay>0){
					
			   
				if(limitdisplay<esize){
					viewallmoderatedhubs= " <a href='"+"/portal/guesttasks/pagemoderatorhubs.jsp?userid="+userid+"'>View All ("+esize+")</a>";
				
				}
				request.setAttribute("VIEWALLMODERATEDHUBS",viewallmoderatedhubs);

				for(int z=0;z<limitdisplay;z++){
					HashMap hubMap=(HashMap)myListedHubs.elementAt(z);
						String refer="/"+appname+"/hub/clubview.jsp?GROUPID="+GenUtil.getHMvalue(hubMap,"clubid");

					String moderatedhub="<a href='"+GenUtil.getEncodedXML(refer)+"' >"+GenUtil.getHMvalue(hubMap,"clubname","",true)+"</a>";
					moderatedhubs.add(moderatedhub);
				 }//endfor
		

				}//end of limit
			   }//modhubs !=null
}//moderated hubs show

request.setAttribute("MODERATEDHUBS",moderatedhubs);

%>


<%-- moderated hubs end --%>

<%--member hubs --%>
<%

//String club_title=EbeeConstantsF.get("club.label","Bee Hive");
String labelmemberhubs="Member "+EbeeConstantsF.get("club.label1","Communities");
List memberhubs=new ArrayList();
request.setAttribute("LABELMEMBERHUBS",labelmemberhubs);
if("Yes".equalsIgnoreCase(GenUtil.getHMvalue(prefMap,"mypage.memberhubs.show","Yes"))){

			String Query="select cm.clubid from club_member cm,clubinfo c where userid=? and ismgr<>'true' "
				+" and cm.status in ('ACTIVE') and cm.clubid=c.clubid and c.status in ('ACTIVE')";
				
			Vector myRegisterHubs=hubDB.getHubs(Query,new String[]{userid} );
			int limitdisplay=displayLimit;
			if(myRegisterHubs!=null){
			
				String viewallmemberhubs="";
				int esize=myRegisterHubs.size();
				if(limitdisplay>esize){
					limitdisplay=esize;
				}
				if(limitdisplay>0){
					if(limitdisplay<esize){
						viewallmemberhubs="<a href='"+"/portal/guesttasks/pagememberhubs.jsp?userid="+userid+"'>View All ("+esize+")</a>";
					}
					request.setAttribute("VIEWALLMEMBERHUBS",viewallmemberhubs);
					for(int z=0;z<limitdisplay;z++){
						HashMap hubMap=(HashMap)myRegisterHubs.elementAt(z);	
							String refer="/"+appname+"/hub/clubview.jsp?GROUPID="+GenUtil.getHMvalue(hubMap,"clubid");
	
						String memberhub="<a href='"+GenUtil.getEncodedXML(refer)+"' >"+GenUtil.getHMvalue(hubMap,"clubname","",true)+"</a>";
						memberhubs.add(memberhub);
	
					}//end for		

				}//limitdisplay>0
			   }// reghubs !=null


}
request.setAttribute("MEMBERHUBS",memberhubs);
%> 

<%--member hubs end--%>

<%
}//valid user
%>


<%
}// user is active

%>





<%
String content="";
HashMap customcontent_ad=CustomContentDB.getCustomContent("G_AD_LIFESTYLE_DETAILS", "13579");
if(customcontent_ad!=null&&GenUtil.getHMvalue(customcontent_ad,"desc")!=null)
content=GenUtil.getHMvalue(customcontent_ad,"desc");
else
content="";
%>
<%
request.setAttribute("LIFESTYLEDETAILSGOOGLEAD",content);
%>




