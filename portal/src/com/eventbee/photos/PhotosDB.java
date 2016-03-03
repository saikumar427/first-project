package com.eventbee.photos;

import java.sql.*;
import java.util.*;
import com.eventbee.general.*;

  public class PhotosDB{

	 static final String PHOTO_SEQ_GET="select nextval('seq_imageid') as photoid;";
	 static final String UNIT_PHOTOS_INSERT="insert into unit_photos (groupid,photoid,photoserver,uploadurl,onclickurl,width,height,caption)"
						+"values(?,?,?,?,?,?,?,?)";
	static final String EVT_PHOTOS_INSERT="insert into event_photo(groupid,photoid) values(?,?)";
	static final String EVT_PHOTO_GET="select a.photoid,a.caption,a.uploadurl,a.onclickurl,a.width,a.height from unit_photos a,event_photo b"
						+" where a.photoid=b.photoid and b.groupid=?";
	static final String UNIT_PHOTO_DELETE="delete from unit_photos where photoid=?";

	public static final String MEMBER_PHOTO_SELECT="select photo_id,uploadurl ,caption ,absoluteurl ,onclickurl, "
				+" height,width from member_photos where user_id =?";


    public static HashMap getEvtPhotoInfo(String groupid){
		java.sql.Connection con=null;
		java.sql.PreparedStatement pstmt=null;
		HashMap hm=null;
		try{
			con=EventbeeConnection.getConnection();
			pstmt=con.prepareStatement(EVT_PHOTO_GET);
			pstmt.setString(1,groupid);
			ResultSet rs=pstmt.executeQuery();
			if(rs.next()){
				hm=new HashMap();
				hm.put("imageurlold",rs.getString("uploadurl"));
				hm.put("caption",rs.getString("caption"));
				hm.put("curl",rs.getString("onclickurl"));
				hm.put("photoid",rs.getString("photoid"));
			}
			rs.close();
			pstmt.close();
			con.close();
		}catch(Exception e){
			hm=null;
			System.out.println("Error in getEvtPhototInfo()"+e.getMessage());
		}
		return hm;
	}

     public static int evtPhotoDelete(String photoid){
		java.sql.Connection con=null;
		java.sql.PreparedStatement pstmt=null;
		int rcount=0;
		 try{
			con=EventbeeConnection.getConnection();
			pstmt=con.prepareStatement(UNIT_PHOTO_DELETE);
			pstmt.setString(1,photoid);
			rcount=pstmt.executeUpdate();
			pstmt.close();
			con.close();
			System.out.println("delete photo--photodelete"+rcount);
		}catch(Exception e){
			rcount=0;
			System.out.println("exception at delete photo--photodelete"+e.getMessage());
		}
		return rcount;
       }

	public static int evtPhotoInsert(HashMap hm){
		java.sql.Connection con=null;
		java.sql.PreparedStatement pstmt=null;
		int rcount=0;
		String photoid=null;
		try{
			 con=EventbeeConnection.getConnection();
			 con.setAutoCommit(false);
			 pstmt=con.prepareStatement(PHOTO_SEQ_GET);
			 ResultSet rs2=pstmt.executeQuery();
			 if(rs2.next()){
				rcount=1;
			 	photoid=rs2.getString("photoid");
			 }
			 rs2.close();
			 pstmt.close();

			 if(rcount>0){
				rcount=0;
				pstmt=con.prepareStatement(UNIT_PHOTOS_INSERT);
				pstmt.setString(1,(String)hm.get("groupid"));
				pstmt.setString(2,photoid);
				pstmt.setString(3,"HOSTING");
				pstmt.setString(4,(String)hm.get("imageurl"));
				pstmt.setString(5,(String)hm.get("onclickurl"));
				pstmt.setString(6,"300");
				pstmt.setString(7,"400");
				pstmt.setString(8,(String)hm.get("caption"));

				rcount=pstmt.executeUpdate();
				pstmt.close();

 				if(rcount>0){
					rcount=0;
					pstmt=con.prepareStatement(EVT_PHOTOS_INSERT);
					pstmt.setString(1,(String)hm.get("groupid"));
					pstmt.setString(2,photoid);

					rcount=pstmt.executeUpdate();
					pstmt.close();
					pstmt=null;
				}
			}
			if(rcount==0){
				con.rollback();
			}else{
				con.setAutoCommit(true);
				con.close();
				con=null;
			}
		}catch(Exception e1){
			rcount=0;
			System.out.println("Exception during insertion at photos--photoinsert : "+e1.getMessage());
		}finally{
		      try{
				if(pstmt!=null) pstmt.close();
				if(con!=null) con.close();
		  	}catch(Exception e){ 	}
		}
		return rcount;
	}


/******start*****/

public static int evtPhotoInsert(HashMap hm,String shareorclone){

	int rcount=0;
	if("clone".equals(shareorclone)){
		return evtPhotoInsert( hm);
	}else
	if("share".equals(shareorclone)){
		java.sql.Connection con=null;
		java.sql.PreparedStatement pstmt=null;

		String photoid=(String)hm.get("photoid");

		try{
			 if(photoid != null){
				con=EventbeeConnection.getConnection();
				pstmt=con.prepareStatement(EVT_PHOTOS_INSERT);
				pstmt.setString(1,(String)hm.get("groupid"));
				pstmt.setString(2,photoid);
				rcount=pstmt.executeUpdate();
				pstmt.close();
				pstmt=null;
				con.close();
				con=null;
			}
		}catch(Exception e1){
			rcount=0;
			System.out.println("Exception during insertion at photos--photoinsert : "+e1.getMessage());
		}finally{
		      try{
				if(pstmt!=null) pstmt.close();
				if(con!=null) con.close();
		  	}catch(Exception e){ 	}
		}
	}
		return rcount;
	}


/******end*/

/********start*/

String getMonth(int i)
{
String[] months=new String[]{"January","February","March","April","May","June","July","August","September","October","November","December"};
String str=months[i];
return str;
}
public HashMap getPhotoInfo(String photoid)
{
 String query="select photoname,user_id,getMemberName(user_id||'') as username,getMemberPref(user_id||'','pref:myurl','') as loginname, "
  +" to_char(created_at,'Month dd, yyyy  HH12:MI AM') as posted_dt1,uploadurl,caption from member_photos where encrypt_photoid=?";
DBManager dbmanager=new DBManager();
		StatusObj statobj=null;
		HashMap photoMap=new HashMap();
		statobj=dbmanager.executeSelectQuery(query,new String [] {photoid});
		if(statobj.getStatus()){
			String [] columnnames=dbmanager.getColumnNames();
			for(int i=0;i<statobj.getCount();i++){

			for(int j=0;j<columnnames.length;j++){
					photoMap.put(columnnames[j],dbmanager.getValue(i,columnnames[j],""));
			}
			}
		}
		String firstname=DbUtil.getVal("select first_name from user_profile where user_id=(select user_id::varchar from member_photos where encrypt_photoid=?)",new String [] {photoid});
		photoMap.put("firstname",firstname);
		return photoMap;

}



 }
