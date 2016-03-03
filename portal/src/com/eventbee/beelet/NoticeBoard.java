package com.eventbee.beelet;

import com.eventbee.event.BeeletController;
import com.eventbee.general.*;
import java.sql.*;
import java.util.*;


public class NoticeBoard implements BeeletInf{
	public String Title="Notice Board";
	int displayCount=3;
	public String GetTitle(){
		return Title;
        }

	public String DisplayContent(HashMap DataHash){
		StringBuffer sb=new StringBuffer();
		try{
			StatusObj stob=getData(DataHash);
			if(stob.getStatus()){
			HashMap notices=(HashMap)stob.getData();
		  	if(notices!=null){
			 	sb.append("<body><table class='maintable' width='100%' align='center' cellspacing='0'>");
				sb.append("<tr vAlign='top'><td class='portaltitle'>Notice Board</td></tr>");
				sb.append("<tr><td bgcolor='#EEEEE8'>");
				sb.append("<table border='0' align='center' width='100%' cellspacing='0'>");
  				Set set=notices.entrySet();
   				String base="evenbase";
   				int k=0;
   				for(Iterator i=set.iterator();i.hasNext();){
   					Map.Entry entry=(Map.Entry)i.next();
   					String noticeid=(String)entry.getKey();
   					HashMap notice=(HashMap)notices.get(noticeid);
   					k++;
   					if(k<6){
						if(k%2==0){
							base="oddbase";
						}else{
							base="evenbase";
						}
						sb.append("<tr class="+base+">");
						sb.append("<td align='left' class='data'>");
						sb.append((String)notice.get("noticetype"));
						sb.append("</td><td align='left' class='data'>");
						sb.append((String)notice.get("postedat"));
						sb.append("</td></tr><tr class=");
						sb.append(base+">");
						sb.append("<td align='left' width='100%' class='data' colspan='2'>");
						sb.append((String)notice.get("notice"));
						sb.append("</td></tr>");
	   				}
   			       }
   			sb.append("</table>");
   			if(notices.size()>5){
	   			sb.append("<table border='0' width='100%' align='center' cellspacing='0'>");
   				sb.append("<tr><td align='right'>");
				sb.append("<A HREF='/portal/noticeboard/getallnoticeinfo'>All Notices</A>");
				sb.append("</td></tr></table>");
   			}
			sb.append("</td></tr></table></body>");
		     }
	         }
	}catch(Exception e){
   EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.ERROR,"beelet.EventInfo","getEvtInfo()",e.getMessage(),e);
   }
	return sb.toString();
    }

	public StatusObj getData(HashMap DataHash){
 		StatusObj statusObj=null;
		Connection con=null;
		HashMap notices=new HashMap();
		boolean flag=false;
		java.sql.PreparedStatement pstmt=null;
		java.sql.ResultSet rs=null;
		try{
	 		String query="select noticeid,notice,noticetype,to_char(postedat,'MM/dd, HH:MI A.M') as postedat from notice where groupid=to_number(?,'9999999999999999999') order by postedat desc";
	 		if(DataHash!=null){
				HashMap groupinfo=(HashMap)DataHash.get("groupinfo");
				String groupid=(String)groupinfo.get("groupid");
				con=EventbeeConnection.getConnection();
				pstmt=con.prepareStatement(query);
				pstmt.setString(1,groupid);
				rs=pstmt.executeQuery();
				while(rs.next()){
					HashMap notice=new HashMap();
					notice.put("notice",rs.getString("notice"));
					notice.put("noticetype",rs.getString("noticetype"));
					notice.put("postedat",rs.getString("postedat"));
					notices.put(rs.getString("noticeid"),notice);
					flag=true;
				}
				if(notices.size()==0){
					notices=null;
					flag=false;
				}
				rs.close();
				pstmt.close();
				pstmt=null;
				con.close();
				if(flag){
					statusObj=new StatusObj(true,"Data retrived",notices);
				}else{
					statusObj=new StatusObj(false,"Data not found",null);
				}
			    }else{
				statusObj=new StatusObj(false,"session failed",null);
			    }
			}catch(Exception e){
				statusObj=new StatusObj(false,e.getMessage(),null);
			}
			finally{
				try{
					if (pstmt!=null) pstmt.close();
					if(con!=null) con.close();
				}catch(Exception e){
					statusObj=new StatusObj(false,e.getMessage(),null);
				}
			}
			return statusObj;
    		}

 }