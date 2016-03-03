<%@ page import="com.eventbee.general.DBManager,com.eventbee.general.EbeeCachingManager,com.eventbee.general.StatusObj,com.eventbee.general.GenUtil"%>
<%@ page import="java.util.HashMap,java.util.Random,java.util.ArrayList"%>
<html>
<head>
<script type="text/javascript" src="<%=resourceaddress%>/home/js/paging.js"></script>
<head>
  <style>
  #promotionsbox{
  font-family:Lucida Grande,Lucida Sans Unicode,sans-serif;
font-size:12px;
color: black;
line-height: 20px;
  }
  
#promotionsbox a{
color: blue;
text-decoration:none;
}

  .pg-normal {
                
                font-weight: normal;
                text-decoration: none;    
                cursor: pointer;
				background: none repeat scroll 0 0 #FFFFFF;
				border-color: #999999;
				color: #999999;
				border: 1px solid 
				margin-bottom: 5px;
				margin-right: 5px;
				min-width: 1em;
				padding: 0.3em 0.5em;
				text-align: center;
            }
            .pg-selected {
                font-weight: bold;        
                cursor: pointer;
				background: none repeat scroll 0 0 #2266BB;
				border: 1px solid #AAAAEE;
				color: #FFFFFF;
    margin-bottom: 5px;
    margin-right: 5px;
    min-width: 1em;
    padding: 0.3em 0.5em;
    text-align: center;
            }
  
 </style>
 </head>
 <body>
<%!
ArrayList<HashMap<String,String>> getManagerPromotedEvents(String query,String[] param){
	ArrayList<HashMap<String,String>> list =new ArrayList<HashMap<String,String>>();
	DBManager db=new DBManager();
	StatusObj sob=db.executeSelectQuery(query,param);
	if(sob.getStatus()){
		for(int i=0;i<sob.getCount();i++){
			HashMap<String,String> promoMap=new HashMap<String,String>();
			promoMap.put("eid",db.getValue(i,"eventid",""));
			promoMap.put("eventname",db.getValue(i,"eventname",""));
			promoMap.put("extid",db.getValue(i,"extid",""));
			promoMap.put("name",db.getValue(i,"name",""));
			promoMap.put("day",db.getValue(i,"day",""));
			promoMap.put("network",db.getValue(i,"network",""));
			promoMap.put("profile_image_url",db.getValue(i,"profile_image_url",""));
			list.add(promoMap);
		}
	}
	return list;
}
public static String TruncateData(String basedata, int tsize){
	if(basedata==null) return "";
	if(basedata.length()<=tsize) return basedata;
	return basedata.substring(0,tsize-1 )+"...";
}
%>
<%
	String eid=request.getParameter("eid");
	String query="select eventname,a.eventid,external_userid as extid ,network,profile_image_url,fname||' '||lname as name,to_char(a.promoted_at,'Day') as day from nts_visit_track a,eventinfo b ,ebee_nts_partner c where a.eventid=b.eventid::varchar  and a.nts_code=c.nts_code and c.network in('facebook') and a.promoted_at is not null order by a.promoted_at desc limit 4";
	eid=(eid==null)?"":eid;
	String[] param=null;
	ArrayList<HashMap<String,String>> promolist=new ArrayList<HashMap<String,String>>();
	String extid="",eventid="",eventname="",name="",day="",network="";
	String style="border-right: 1px solid #E0E0E0;padding:5px;";	
	if("".equals(eid)){   ////// Promotions for Home Page ///////////////
		boolean isInCache=EbeeCachingManager.checkCache("recentPromos",120000);
		if(!isInCache){
			promolist=getManagerPromotedEvents(query,null);
			if(promolist!=null && promolist.size()>0)
			EbeeCachingManager.put("recentPromos",promolist);
		}
		promolist=(ArrayList)EbeeCachingManager.get("recentPromos");
		if(promolist!=null && promolist.size()>0){
			int fbcount=0,twtcount=0;
			if(!isInCache){
				for(HashMap<String,String> hm:promolist){
					if("facebook".equals(hm.get("network"))) fbcount++;
					else twtcount++;
				}
			/* 	String fq="select eventname,a.eventid,external_userid as extid ,network,profile_image_url,fname||' '||lname as name,to_char(a.promoted_at,'Day') as day from nts_visit_track a,eventinfo b ,ebee_nts_partner c where a.eventid=b.eventid::varchar  and a.nts_code=c.nts_code  and a.promoted_at is not null and c.network='twitter' order by a.promoted_at desc limit 1"; */
				String fq="select eventname,a.eventid,external_userid as extid ,network,profile_image_url,fname||' '||lname as name,to_char(a.promoted_at,'Day') as day from nts_visit_track a,eventinfo b ,ebee_nts_partner c where a.eventid=b.eventid::varchar  and a.nts_code=c.nts_code  and a.promoted_at is not null and c.network='facebook' order by a.promoted_at desc limit 1";
				ArrayList<HashMap<String,String>> al=new ArrayList<HashMap<String,String>>();
				if(fbcount==promolist.size()) al=getManagerPromotedEvents(fq,null);
				if(twtcount==promolist.size()){
					fq="select eventname,a.eventid,external_userid as extid ,network,profile_image_url,fname||' '||lname as name,to_char(a.promoted_at,'Day') as day from nts_visit_track a,eventinfo b ,ebee_nts_partner c where a.eventid=b.eventid::varchar  and a.nts_code=c.nts_code  and a.promoted_at is not null and c.network='facebook' order by a.promoted_at desc limit 1";
					al=getManagerPromotedEvents(fq,null);
				}
				if(al!=null && al.size()>0){
					Random randomGenerator = new Random();
					if(promolist.size()<4)
						promolist.add(randomGenerator.nextInt(promolist.size()),al.get(0));
					/* else
						promolist.set(randomGenerator.nextInt(promolist.size()),al.get(0)); */
				}
			}
			out.println("<table><tr>");
			for(int i=0;i<promolist.size();i++){
				extid=promolist.get(i).get("extid");
				eventid=promolist.get(i).get("eid");
				eventname=promolist.get(i).get("eventname");
				name=promolist.get(i).get("name");
				day=promolist.get(i).get("day").trim();
				String src="",profileurl="",profileimg="";
				profileimg=promolist.get(i).get("profile_image_url");
			/*
				?-network user id
				twitter profile url :"http://twitter.com/account/redirect_by_id?id=?"
				facebook profile url :"http://www.facebook.com/profile.php?id=?"
				
				twitter image url :"https://api.twitter.com/1/users/profile_image?user_id=?&size=bigger"		
				facebook image url:"https://graph.facebook.com/?/picture"
			*/
				if("facebook".equals(promolist.get(i).get("network"))){
					src=resourceaddress+"/main/images/fb_large_icon.png";
					profileurl="http://www.facebook.com/profile.php?id="+extid;
					profileimg="https://graph.facebook.com/"+extid+"/picture";
				}
				else if("twitter".equals(promolist.get(i).get("network"))){
					src=resourceaddress+"/main/images/twitter_large_icon.png";
					profileurl="http://twitter.com/account/redirect_by_id?id="+extid;
					//profileimg="https://api.twitter.com/1/users/profile_image?user_id="+extid+"&size=bigger";
				}
				int enamelen=80-(name.length()+" promoted ".length()+" on ".length()+day.length());
				enamelen=37;
				//if(enamelen<1) enamelen=30;
				if(i==promolist.size()-1)
					style="padding:5px;";
			%>
				<td width="25%" style="<%=style%>" valign="top">
			<table width="100%" cellpadding="0" cellspacing="0" valign="top" align="left">
			<tr><td valign="top"><a href='<%=profileurl%>' target='_blank'><img src='<%=profileimg%>' border='0' height='50' title='<%=name%>' alt=''> </a>
				</td><td width="5"></td><td valign="top" align="left"> <a href='<%=profileurl%>' target='_blank'><%=name%></a> promoted <a href='/event?eid=<%=eventid%>' target='_blank'><%=GenUtil.textToHtml(TruncateData(eventname,enamelen),true)%></a> <span class="smallestfont">on <%=day%>&nbsp;<a href='<%=profileurl%>' target='_blank'><img src="<%=src%>" width="15" height="15"></a></span></td>
			</tr>
			</table>
			</td>
			<%
		}
	out.println("</tr></table>");
	}
		}
		else{                            ////// Promotions for Event Page and Manager's Summary Page///////////////
		param=new String[]{eid};
			query="select eventname,a.eventid,external_userid as extid ,network,fname||' '||lname  as name,to_char(a.promoted_at,'Day') as day from nts_visit_track a,eventinfo b ,ebee_nts_partner c where a.eventid=? and CAST(a.eventid as BIGINT)=b.eventid  and a.nts_code=c.nts_code and a.promoted_at is not null order by a.promoted_at desc";
			promolist=getManagerPromotedEvents(query,param);
			out.println("<div style='height:210px' >");
			out.println("<table id='eventprotab'>");
			out.println("<tr><td></td></tr>");
			for(int i=0;i<promolist.size();i++){
			extid=promolist.get(i).get("extid");
			eventid=promolist.get(i).get("eid");
			eventname=promolist.get(i).get("eventname");
			name=promolist.get(i).get("name");
			day=promolist.get(i).get("day");
			String src="",profileurl="";
			if("facebook".equals(promolist.get(i).get("network"))){
				src="https://graph.facebook.com/"+extid+"/picture";
				profileurl="http://www.facebook.com/profile.php?id="+extid;
			}
			else if("twitter".equals(promolist.get(i).get("network"))){
				src="https://api.twitter.com/1/users/profile_image?user_id="+extid+"&size=bigger";
				profileurl="http://twitter.com/account/redirect_by_id?id="+extid;
			}

			%>
				<tr><td>
					<table width="100%" cellpadding="0" cellspacing="0" valign="top" align="left" id='promotionsbox'>
			<tr><td valign="top" width='50'><a href='<%=profileurl%>' target='_blank'><img src='<%=src%>' border='0' title='<%=name%>' alt=''></a> 
				</td><td width="5"></td><td align="left"> <a href='<%=profileurl%>' target='_blank'><%=name%></a> promoted on <%=day%></td>
			</tr>
			<tr><td style="border-bottom: 1px solid #E0E0E0;padding:5px;" colspan="3" ></td></tr>
			</table>
				</td></tr>
			<%
		}	
		out.println("</table>");
		out.println("</div>");
		}
%>
<div id='pageNavPosition'></div>
<%if(promolist!=null && promolist.size()>3){%>
<script type="text/javascript">
		if(document.getElementById("eventprotab")){
        var pager = new Pager('eventprotab',3); 
        pager.init(); 
        pager.showPageNav('pager', 'pageNavPosition'); 
        pager.showPage(1);
		}
		
    </script>
<%}%>
</body>
</html>
