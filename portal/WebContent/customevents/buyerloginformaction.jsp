<%@page import="com.eventbee.general.StatusObj"%>
<%@page import="com.eventbee.general.DBManager"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.eventbee.general.GenUtil"%>
<%@page import="com.eventbee.general.DateUtil"%>
<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="com.eventbee.general.EncodeNum"%>

<%!

public String generateToken(String profilekey,String accessmode){
	String token="";
	try{
		String updateOTPQuery="update buyer_att_page_visits set token=?,access_mode=?,status='Success' where profilekey=? and status='Pending'";
		String seq_buyer_login=DbUtil.getVal("select nextval('seq_buyer_login')", new String[] {});
		token = "BY"+EncodeNum.encodeNum(seq_buyer_login).toUpperCase();
		StatusObj stobj= DbUtil.executeUpdateQuery(updateOTPQuery, new String[] {token,accessmode,profilekey});
		if(stobj.getCount()==0) token="";
		return token;
	}catch(Exception e){
		return "";
	}
}

%>

<%
JSONObject json=new JSONObject();
String otp="",isExpired="",isFBLoginReg="";
String refkey = request.getParameter("refkey");
String profilekey = request.getParameter("profilekey");
String tid = request.getParameter("tid");
String accessmode = request.getParameter("accessmode");
boolean flag=true;
String statusmsg="";

if(refkey==null) refkey="";
	try{
		
		if("FB".equals(accessmode)){
			String getFBLoginRegEmailQry="select b.external_userid from event_reg_transactions a, ebee_nts_partner b where a.buyer_ntscode=b.nts_code and a.buyer_ntscode is not null and a.buyer_ntscode<>'' and a.buyer_ntscode<>'null' and a.tid=?";
			//String isFBLoginRegQry="select 'yes' from event_reg_transactions a, ebee_nts_partner b where a.buyer_ntscode=b.nts_code and a.email=b.email and a.tid=?";
			isFBLoginReg=DbUtil.getVal(getFBLoginRegEmailQry, new String[]{tid});
			if(isFBLoginReg==null) isFBLoginReg="";
			
			if("".equals(isFBLoginReg) || !isFBLoginReg.equals(refkey)){
				json.put("status","fail");
				json.put("error","Please logout your FB session and login with registered FB account");
			}else{
				String token=generateToken(profilekey,accessmode);
				if(!"".equals(token)){
					json.put("status","success");
					json.put("token",token);
				}else{
					json.put("status","fail");
					json.put("error","There is a problem. Please try back later.");
				}
			}
			
		}else{
			try{
				String checkExpiresQry="select otp, CASE WHEN COALESCE(expires_at, DATE '0001-01-01') < (select now()) THEN 'Y' ELSE 'N' END as isexpired from buyer_att_page_visits where status='Pending' and profilekey=?";
				DBManager dbmanager=new DBManager();
				if(!"".equals(refkey)){
					StatusObj stobj=dbmanager.executeSelectQuery(checkExpiresQry,new String[]{profilekey});
					if(stobj.getStatus()){
						otp=dbmanager.getValue(0,"otp","");
						isExpired=dbmanager.getValue(0,"isexpired","");
					}
					if(otp==null) otp="";
					if("Y".equals(isExpired)){
						json.put("status","fail");
						json.put("error","Access token is expired");
					}else{
						if((refkey.trim()).equals(otp)){
							String otpToken=generateToken(profilekey,accessmode);
							if(!"".equals(otpToken)){
								json.put("status","success");
								json.put("token",otpToken);
							}else{
								json.put("status","fail");
								json.put("error","There is a problem. Please try back later.");
							}
						}else{
							json.put("status","fail");
							json.put("error","Invalid access token");
						}
					}
				}else{
					json.put("status","fail");
					json.put("error","Invalid access token");
				}
				
			}catch(Exception e){
				json.put("status","fail");
				json.put("error","Invalid access token");
			}
		}
	}catch(Exception e){
		json.put("status","fail");
		json.put("error","Invalid access token");
	}
out.println(json.toString());
%>