<%@ page import="com.eventbee.general.DbUtil"%>
<%@ page import="com.eventbee.general.EventbeeLogger"%><% // available in eventbee.jar %>
<%
	String userid = request.getParameter("userid");
	String trackcode = request.getParameter("trackcode");
	String password = request.getParameter("password");
	String dbpwd = password;
	try {
		trackcode = trackcode.toLowerCase();
		dbpwd = DbUtil.getVal("select password from accountlevel_track_partners where userid=CAST(? as BIGINT) and lower(trackname)=?",	new String[] { userid, trackcode });
		if (dbpwd == null) {
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN, EventbeeLogger.DEBUG, "validatetrackpwd.jsp", "", "Unable to get user: " + userid + " and trackcode:  " + trackcode, null);
			dbpwd = "";
		}
		if (dbpwd.equals(password)) {
			out.print("Success");
		} else {
			out.print("fail");
		}
	} catch (Exception e) {
		out.print("fail");
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN, EventbeeLogger.ERROR, "validatetrackingpwd.jsp", "", "userid: " + userid, null);
		EventbeeLogger.logException("com.eventbee.exception", EventbeeLogger.ERROR,	"validatetrackingpwd.jsp", "validating track pwd", "Exception while validation", e);
	}
%>


