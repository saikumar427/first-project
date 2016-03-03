<%@ page import="java.io.*,java.util.HashMap,java.util.*,com.eventbee.authentication.*,com.eventbee.useraccount.AccountDB" %>
<%@ page import="com.eventbee.general.EbeeConstantsF" %>
<%
request.setAttribute("tasktitle","Account Information");
%>
<%
	String authid="",accstatid="",role="",appname="";
	Vector v=null;
	String orgid="";
	String roletype1="",unitacctstatus="",orgacctstatus="";
        String[] disp=new String[3];
	String markunitid=EbeeConstantsF.get("defaultunitid","13579");
	//String unitid=request.getParameter("UNITID");
	Authenticate authData=(Authenticate)session.getAttribute("13579_TEMPauthData");
	if (authData!=null)
	{
		authid=authData.getUserID();
		accstatid=authData.getAcctStatusID();
		v=authData.inActiveDescription();
		role=authData.getRoleName();
		orgid=authData.getOrgID();
		roletype1=authData.getRoleTypeCode();
		orgacctstatus=authData.getOrgAcctStatus();
		unitacctstatus=authData.getUnitAcctStatus();
	}

	if((roletype1.equals("BUILT_IN")) && (role.equals("Manager")))
	{
	 appname="manager";
	 disp=getManagerStatus(accstatid,unitacctstatus,authData);
	}
        else
	{
	  /*if(role.equals("Manager"))
	  {
	 	 appname="manager";
		 disp=getSubManagerStatus(accstatid,unitacctstatus,authData);

	  }
     	  else
	  {*/
	 	 appname="portal";
	 	 disp=getMemberStatus(accstatid,markunitid,authData);
	  }
	
%>
<%!
	public String[] getManagerStatus(String accstatid,String unitacctstatus,Authenticate authData)
	{
	String[] msg=new String[3];

		msg[1]="support@beeport.com";
		if("1".equals(accstatid)){
			if(unitacctstatus.equals("7")){
				msg[0]="Pending Approval";
			}
			else if(unitacctstatus.equals("2")){
				msg[0]="Inactive";
			}
			else {
				msg[0]="Pending";
			}
		}
		else if(accstatid.equals("2")){
			msg[0]="Inactive";
		}
		else {
			msg[0]="Pending";
		}

	return msg;
	}

	public String[] getSubManagerStatus(String accstatid,String unitacctstatus,Authenticate authData)
	{
	String[] msg=new String[3];
		msg[1]=(String)authData.UnitInfo.get("mgrEmail");
		if(accstatid.equals("1")){
			msg[0]="Currently Unavailable";
		}
		else if(accstatid.equals("2")){
			msg[0]="Inactive";
		}
		else{
			msg[0]="Pending";
		}
	return msg;
	}
	public String[] getMemberStatus(String accstatid,String markunitid,Authenticate authData)
	{
	String[] msg=new String[3];

		//if("13579".equals(markunitid))
		//{
			msg[1]="support@eventbee.com";
		/*}
		else
		{
			msg[1]=(String)authData.UnitInfo.get("mgrEmail");
		}*/
		if(accstatid.equals("1")){
			msg[0]="Currently Unavailable";
		}
		else if(accstatid.equals("2")){
			msg[0]="Inactive";
		}
		else{
			msg[0]="Pending";
		}
	return msg;
	}
%>
<table width="100%">
<tr><td width="100%" height="10" colspan="2"></td></tr>
<tr><td width="30%" >Account Status:
<%=disp[0]%></td></tr>
<tr><td width="100%" height="10" colspan="2">Please contact <a href="mailto:<%=disp[1]%>"><%=disp[1]%></a> for more information.</td></tr>
<tr><td colspan="2" width="100%" height="10"></td></tr>
</table>
