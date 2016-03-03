<%@ page import="com.eventbee.general.*"%>

<script type='text/javascript' language='JavaScript' src='/home/js/registration.js'></script>

<%

String tid=request.getParameter("id");
DbUtil.executeUpdateQuery("update event_reg_details_temp set paymentstatus=? where tid=?",new String[]{"waiting",tid});



%>


<script>
closePaypalPopUp();
</script>

