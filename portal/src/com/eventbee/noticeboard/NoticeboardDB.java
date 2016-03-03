package com.eventbee.noticeboard;
import com.eventbee.general.EventbeeConnection;
import java.sql.*;
import java.util.*;
import com.eventbee.general.*;

public class NoticeboardDB{
  public final static String GET_NOTICES_QUERY="select noticeid,notice,noticetype,to_char(postedat,'Mon dd, HH:MI AM') as postedat1 from notice where groupid=to_number(?,'999999999999999999') order by postedat desc";
  public final static String GET_NOTICE_QUERY="select notice,noticetype from notice where noticeid=?";
  public final static String INSERT_NOTICE_QUERY="insert into notice(noticeid,notice,noticetype,groupid,grouptype,owner,postedat) values(nextval('seq_notice'),?,?,?,?,?,current_timestamp)";
  public final static String UPDATE_NOTICE_QUERY="update notice set notice=?,postedat=current_timestamp where noticeid=?";
  public final static String DELETE_NOTICE_QUERY="delete from notice where noticeid=?";

  private static final String FILE_NAME="org.eventbee.sitemap.generation.beelet.NoticeboardDB";

    public static Vector getAllNotices(String groupid){

	 	java.sql.Connection con=null;
		java.sql.PreparedStatement pstmt=null;
		java.sql.ResultSet rs=null;
                Vector v=new Vector();
		try{
			con=EventbeeConnection.getReadConnection();
			pstmt=con.prepareStatement(GET_NOTICES_QUERY);
            pstmt.setString(1,groupid);
			rs=pstmt.executeQuery();
			while(rs.next()){
				HashMap notice=new HashMap();
				notice.put("notice",rs.getString("notice"));
				notice.put("noticetype",rs.getString("noticetype"));
				notice.put("postedat1",rs.getString("postedat1"));
                notice.put("noticeid",rs.getString("noticeid"));
				v.addElement(notice);
			}
			rs.close();
			pstmt.close();
			pstmt=null;
			con.close();
		}catch(Exception e){
                        EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,FILE_NAME,"MgrNoticesBeelet()","There is an error in MgrNoticesBeelet",e);
		}finally{
			try{
				if(pstmt!=null)
					pstmt.close();
				if(con!=null)
					con.close();
			}catch(Exception ex){}
		}
		return v;
  }

  public static HashMap getNoticeInfo(String noticeid){

  	 	java.sql.Connection con=null;
  		java.sql.PreparedStatement pstmt=null;
  		java.sql.ResultSet rs=null;
         HashMap notice=new HashMap();
  		try{
  			con=EventbeeConnection.getReadConnection();
  			pstmt=con.prepareStatement(GET_NOTICE_QUERY);
              pstmt.setString(1,noticeid);
  			rs=pstmt.executeQuery();
  			while(rs.next()){
  				notice.put("notice",rs.getString("notice"));
  				notice.put("noticetype",rs.getString("noticetype"));

  			}
  			rs.close();
  			pstmt.close();
  			pstmt=null;
  			con.close();
  		}catch(Exception e){
                          EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,FILE_NAME,"MgrNoticesBeelet()","There is an error in MgrNoticesBeelet",e);
  		}finally{
  			try{
  				if(pstmt!=null)
  					pstmt.close();
  				if(con!=null)
  					con.close();
  			}catch(Exception ex){}
  		}
  		return notice;
  }

  public static int insertNotice(HashMap notice){


        int count=0;
  		try{
			StatusObj stob1=DbUtil.executeUpdateQuery(INSERT_NOTICE_QUERY,new String[]{(String)notice.get("notice"),(String)notice.get("noticetype"),(String)notice.get("groupid"),(String)notice.get("grouptype"),(String)notice.get("owner")});
			if(stob1.getStatus())
  				count=1;

  		}catch(Exception e){
                          EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,FILE_NAME,"MgrNoticesBeelet()","There is an error in MgrNoticesBeelet",e);
  		}
  		return count;
  }

   public static int updateNotice(String noticeid, String notice){

    	 	java.sql.Connection con=null;
    		java.sql.PreparedStatement pstmt=null;
    		java.sql.ResultSet rs=null;
          int count=0;
    		try{
    			con=EventbeeConnection.getWriteConnection();
    			pstmt=con.prepareStatement(UPDATE_NOTICE_QUERY);
              pstmt.setString(1,notice);
    			pstmt.setString(2,noticeid);
    			count=pstmt.executeUpdate();
    			pstmt.close();
    			pstmt=null;
    			con.close();
    		}catch(Exception e){
                            EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,FILE_NAME,"MgrNoticesBeelet()","There is an error in MgrNoticesBeelet",e);
    		}finally{
    			try{
    				if(pstmt!=null)
    					pstmt.close();
    				if(con!=null)
    					con.close();
    			}catch(Exception ex){}
    		}
    		return count;
  }

  public static int deleteNotices(String[] noticeids){

    	 	java.sql.Connection con=null;
    		java.sql.PreparedStatement pstmt=null;
    		java.sql.ResultSet rs=null;
          int count=0;
    		try{
    			con=EventbeeConnection.getWriteConnection();
    			pstmt=con.prepareStatement(DELETE_NOTICE_QUERY);
    			for(int i=0;i<noticeids.length;i++){
              		pstmt.setString(1,noticeids[i]);
    				count+=pstmt.executeUpdate();
				}
    			pstmt.close();
    			pstmt=null;
    			con.close();
    		}catch(Exception e){
                            EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,FILE_NAME,"MgrNoticesBeelet()","There is an error in MgrNoticesBeelet",e);
    		}finally{
    			try{
    				if(pstmt!=null)
    					pstmt.close();
    				if(con!=null)
    					con.close();
    			}catch(Exception ex){}
    		}
    		return count;
  }







 }
