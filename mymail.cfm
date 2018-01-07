<cfif IsDefined("form.deleteThis")>
	<cfif url.email eq "32H">
		<cfset locServer="mail.third2home.com">
		<cfset LocUser="bprice@third2home.com">
		<cfset locPassword="gocubs">
	<cfelseif url.email eq "357">
		<cfset locServer="pop-server.kc.rr.com">
		<cfset LocUser="price357">
		<cfset locPassword="olivia00">
	<cfelse>
		<cfset locServer="pop-server.kc.rr.com">
		<cfset LocUser="third2home">
		<cfset locPassword="gocubs00">
	</cfif>
	<cfpop action="DELETE" server="#locServer#" username="#LocUser#" password="#locPassword#" name="Messages" messagenumber="#form.deleteThis#">
</cfif>

<cftry>
	<cfpop action="GETHEADERONLY" server="mail.third2home.com" username="bprice@third2home.com" password="gocubs" name="Messages">
	<cfcatch type="Any">
		<cfset Messages.RecordCount=0>
	</cfcatch>
</cftry>
<cftry>
	<cfpop action="GETHEADERONLY" server="pop-server.kc.rr.com" username="third2home" password="gocubs00" name="Messages2">
	<cfcatch type="Any">
		<cfset Messages2.RecordCount=0>
	</cfcatch>
</cftry>
<cftry>
	<cfpop action="GETHEADERONLY" server="pop-server.kc.rr.com" username="price357" password="olivia00" name="Messages3">
	<cfcatch type="Any">
		<cfset Messages3.RecordCount=0>
	</cfcatch>
</cftry>
<html>
<head>
	<title>Mail, Dude</title>
	<script language="JavaScript">
	function openWin() {
		windowName = 'newwindow';
		url="new_mail.cfm";
		params = 'toolbar=0,';
		params += 'location=0,';
		params += 'directories=0,';
		params += 'status=0,';
		params += 'menubar=0,';
		params += 'scrollbars=1,';
		params += 'resizable=1,'; 
		params += 'width=500,';
		params += 'height=500';
		win = window.open(url, windowName, params);
		win.opener.name = 'opener';
		win.focus();
	}
	</script>
</head>
<body>
<a href="mymail.cfm">Refresh List</a><br>
<cfif Messages.RecordCount gt 0>
	<cfquery name="MessagesReorder" dbtype="query">
		select *
		from Messages
		order by date desc
	</cfquery>
	
	<form name="delete_messages" action="mymail.cfm?email=32H" method="post">
	<cfoutput query="MessagesReorder">
		<cftry>
			<cfset tempDate=ParseDateTime(date,"POP")>
			<cfset useParsedate=1>
			<cfcatch type="Expression">
				<cfset tempDate=date>
				<cfset useParsedate=0>
			</cfcatch>
		</cftry>
		<input type="checkbox" name="deleteThis" value="#messagenumber#">&nbsp;
		<strong><a href="mymail_view.cfm?messagenumber=#messageNumber#&total=#Messages.RecordCount#&email=32H">#subject#</a></strong>&nbsp;&nbsp;
		<a href="mymail_view.cfm?messagenumber=#messageNumber#&total=#Messages.RecordCount#&email=32H"><cfif useParseDate eq 1>#DateFormat(tempDate,"m/d/yyyy")#&nbsp;#TimeFormat(tempDate,"h:mm tt")#<cfelse>#date#</cfif></a><br>
	</cfoutput>
	<input type="Submit" value="Delete Selected">
	</form>
<cfelse>
bprice@third2home.com - No Messages
</cfif>
<br>
<br>
<cfif Messages2.RecordCount gt 0>
	<cfquery name="MessagesReorder" dbtype="query">
		select *
		from Messages2
		order by date desc
	</cfquery>
	
	<form name="delete_messages" action="mymail.cfm?email=rr" method="post">
	<cfoutput query="MessagesReorder">
		<cftry>
			<cfset tempDate=ParseDateTime(date,"POP")>
			<cfset useParsedate=1>
			<cfcatch type="Expression">
				<cfset tempDate=date>
				<cfset useParsedate=0>
			</cfcatch>
		</cftry>
		<input type="checkbox" name="deleteThis" value="#messagenumber#">&nbsp;
		<strong><a href="mymail_view.cfm?messagenumber=#messageNumber#&total=#Messages2.RecordCount#&email=rr">#subject#</a></strong>&nbsp;&nbsp;
		<a href="mymail_view.cfm?messagenumber=#messageNumber#&total=#Messages2.RecordCount#&email=rr"><cfif useParseDate eq 1>#DateFormat(tempDate,"m/d/yyyy")#&nbsp;#TimeFormat(tempDate,"h:mm tt")#<cfelse>#date#</cfif></a><br>
	</cfoutput>
	<input type="Submit" value="Delete Selected">
	</form>
<cfelse>
third2home@kc.rr.com - No Messages
</cfif>
<br>
<br>
<br>
<cfif Messages3.RecordCount gt 0>
	<cfquery name="MessagesReorder" dbtype="query">
		select *
		from Messages3
		order by date desc
	</cfquery>
	
	<form name="delete_messages" action="mymail.cfm?email=357" method="post">
	<cfoutput query="MessagesReorder">
		<cftry>
			<cfset tempDate=ParseDateTime(date,"POP")>
			<cfset useParsedate=1>
			<cfcatch type="Expression">
				<cfset tempDate=date>
				<cfset useParsedate=0>
			</cfcatch>
		</cftry>
		<input type="checkbox" name="deleteThis" value="#messagenumber#">&nbsp;
		<strong><a href="mymail_view.cfm?messagenumber=#messageNumber#&total=#Messages3.RecordCount#&email=357">#subject#</a></strong>&nbsp;&nbsp;
		<a href="mymail_view.cfm?messagenumber=#messageNumber#&total=#Messages3.RecordCount#&email=357"><cfif useParseDate eq 1>#DateFormat(tempDate,"m/d/yyyy")#&nbsp;#TimeFormat(tempDate,"h:mm tt")#<cfelse>#date#</cfif></a><br>
	</cfoutput>
	<input type="Submit" value="Delete Selected">
	</form>
<cfelse>
third2home@kc.rr.com - No Messages
</cfif>
<br>
<a href="javascript:openWin()">New Mail</a>
</body>
</html>
<cfsetting showdebugoutput="Yes">