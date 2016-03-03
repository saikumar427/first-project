<%@ page import="java.io.*, java.util.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.hub.*" %>
<%@ page import="com.eventbee.customconfig.*" %>


<%!
	String MEMQUERY="select user_id,first_name,last_name from user_profile where user_id in (select userid from club_member where status ='ACTIVE' and clubid=?)";
	
	List getMembersOfHub(String hubid){
		List memberList=new ArrayList();
		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery( MEMQUERY,new String[]{hubid});
		if(statobj.getStatus() && statobj.getCount()>0 ){
			for(int i=0;i<statobj.getCount();i++){
				Map member=new HashMap();
				member.put("user_id",dbmanager.getValue(i,"user_id","00"));
				String name= (dbmanager.getValue(i,"first_name","")+" "+dbmanager.getValue(i,"last_name","") ).trim();
				//member.put("name",GenUtil.getEncodedXML(name));
				member.put("first_name",dbmanager.getValue(i,"first_name",""));
				memberList.add(member);
			}
		}
		
		
		return memberList;
	}



      String MEMBER_LOCATION_PHOTO="select uploadurl,getGenderofUser(a.user_id||'') as gender from member_photos a,member_photos_location b where a.user_id=? and a.photo_id=b.photo_id and location_code=?"
      	   + " union "  
      	   + " select 'nophoto' as uploadurl,getGenderofUser(a.user_id||'') as gender from user_profile a "
      	   + " where a.user_id =? and user_id not in (select a.user_id from member_photos_location a,member_photos b where location_code=?  and a.photo_id=b.photo_id and a.user_id is not null)";
      
                public Map getPhotos(String userid){
      	  	  		Map photomap=new HashMap();
      	  	  		DBManager dbmanager=new DBManager();
      	  	  		StatusObj statobj=dbmanager.executeSelectQuery(MEMBER_LOCATION_PHOTO,new String[]{userid,"slot2",userid,"slot2"});
      	  	  		int recount=0;
      	  	  		
      	  	  		if(statobj !=null && statobj.getStatus() && (recount=statobj.getCount())>0){
      	  	  			  		
      	  	    				photomap.put("uploadurl",dbmanager.getValue(0,"uploadurl",""));
      	  	  				//photomap.put("photo_size",dbmanager.getValue(0,"photo_size",""));
      	  	  				photomap.put("gender",dbmanager.getValue(0,"gender",""));
      	  	  
      	  	  			
      	  	  		}

      	  	  		return photomap;
	} 
%>

<%
   String imgpath=EbeeConstantsF.get("smallthumbnail.photo.image.webpath","http://www.desihub.com:8888/home/images/smallthumbnail");
        String userid=null,unitid=null;
	String groupid=null;
	String imgsrc=null,uploadurl=null,gender=null;
	Authenticate authData=AuthUtil.getAuthData(pageContext);//(Authenticate)session.getAttribute(ContextConstants.AUTH_DATA_OBJ);
	if (authData!=null){
		userid=authData.getUserID();
		
	}
	
	unitid=request.getParameter("UNITID");
	if(unitid==null)unitid="13579";
	 HashMap hm=(HashMap)session.getAttribute("groupinfo");
	 groupid=(hm!=null)?(String)hm.get("groupid"):request.getParameter("GROUPID");
if(groupid !=null){	
	List memlist=getMembersOfHub( groupid);
%>

<%= PageUtil.startContent("Members",request.getParameter("border"),request.getParameter("width"),true) %>
<table width='100%'>

	<tr>
		
		<%   int count=0;
		
		 String query="";
		 String query1="";
		 int count1=0,count3=0,count4=0;
		 String cnt="",count2="";
		 String rpoints=null;
		 int redeempts=0;
		 int totalpts=0;
		
		     int totalmem=memlist.size();
			if(!memlist.isEmpty()){
			 for(int i=0;i<totalmem;i++){
				      
				      for(int j=0;j<4;j++){
				      if(i>=memlist.size()) break;
				      	count1=0;count3=0;count4=0;totalpts=0;	      
				       Map member=(Map)memlist.get(i);
				       if (j<3) i++;
				        String memlink="/portal/editprofiles/networkuserprofile.jsp?userid="+(String)member.get("user_id"); 
					
					Map pmap=getPhotos((String)member.get("user_id"));
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
								/*  rpoints=DbUtil.getVal("select redeemed_points from promotions_master a,user_redeem_points b where a.promotion_id=b.promotion_id and a.status='active' and b.userid=?",new String [] {(String)member.get("user_id")});
								  if(rpoints==null)
								  	redeempts=0;
								  query="select sum(points) from desipoints where userid=? and status='A' group by userid";
								  cnt=DbUtil.getVal(query,new String [] {(String)member.get("user_id")});
								  query1="select sum(points) from desipoints where userid=? and status='R' group by userid";
								  count2=DbUtil.getVal(query1,new String [] {(String)member.get("user_id")});
								  try{	
								  	if(cnt!=null)
										count1=Integer.parseInt(cnt);
									if(count2!=null)
										count3=Integer.parseInt(count2);
									if(rpoints!=null)
										redeempts=Integer.parseInt(rpoints);
									}catch(Exception e){
									EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR,"/hub/logic/MemeberBeelet.jsp","error occured at desipoint counts variable",e.getMessage(),null);
									
									}
									count4=count1-count3;
									totalpts=count4-redeempts;*/
		                       out.print("<td valign='bottom' align='center'><table cellspacing='0' cellpadding='2' class='T' border='0' width=''><tr><td align='center' valign='bottom'><a href='"+memlink+"'><img border='0' src='"+imgsrc+"'/></a><br/>");
					//out.print("<font class='smallfont'><a href='"+memlink+"' >"+member.get("first_name")+"</a></font>&nbsp;<font class='smallestfont'>(<a href='javascript:popupwindow(\"/portal/lifestyle/mydesipoints.jsp?UNITID=13579\",\"Desipoints\",\"850\",\"500\")'>"+totalpts+"</a>)</font></td></tr></table></td>" );
															       
				    
				 
				 }
				 %>
				 </tr>
				 
			<% }
			}else{
				out.println("No Members");
			}
		
		%>
				
		</td>
	
	</tr>

</table>
<%=PageUtil.endContent() %>

<%}%>
