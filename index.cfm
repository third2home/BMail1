<cfquery name="qryGetAccounts" datasource="Emails">
	select EmailID,EmailAccount,EmailServer,EmailLoginID,EmailPassword
	from EmailAccounts
	order by EmailUserID,EmailID
</cfquery>
<cfif IsDefined("form.deleteThis")>
	<cfquery name="qryGetDeleteAccount" dbtype="query">
		select *
		from qryGetAccounts
		where EmailID=#url.email#
	</cfquery>
	<cfpop action="DELETE" server="#qryGetDeleteAccount.EmailServer#" username="#qryGetDeleteAccount.EmailLoginID#" password="#qryGetDeleteAccount.EmailPassword#" name="Messages" messagenumber="#form.deleteThis#">
</cfif>
<cfset EmailHeader=ArrayNew(2)>
<cfoutput query="qryGetAccounts">
	<cftry>
		<cfpop action="GETHEADERONLY" server="#EmailServer#" username="#EmailLoginID#" password="#EmailPassword#" name="Messages#CurrentRow#">
		<cfset EmailHeader[CurrentRow][1]=EmailAccount>
		<cfset EmailHeader[CurrentRow][2]=0>
		<cfcatch type="Any">
			<cfset "Messages#CurrentRow#.RecordCount"=0>
			<cfset EmailHeader[CurrentRow][2]=1>
		</cfcatch>
	</cftry>
</cfoutput>
<cfinclude template="bmail_header.cfm">
	<cfhtmlhead text="
	<script>
	function openWin() {
		windowName = 'newwindow';
		url='new_mail.cfm';
		params = 'toolbar=0,';
		params += 'location=0,';
		params += 'directories=0,';
		params += 'status=0,';
		params += 'menubar=0,';
		params += 'scrollbars=1,';
		params += 'resizable=1,'; 
		params += 'width=550,';
		params += 'height=550';
		win = window.open(url, windowName, params);
		win.opener.name = 'opener';
		win.focus();
	}
	
	function CheckAll(form_num){
		locForm=eval('document.delete_messages' + form_num);
		loopVar=locForm.deleteThis.length;
		for (i=0;i<loopVar;i++){
			locForm.deleteThis[i].checked=true;
		}
	}
	</script>
	">
<br>
<cfset locLoop=1>
<table cellpadding="2" cellspacing="0" border="0" align="center" width="80%">
	<tr>
		<td colspan="4"><a href="index.cfm">Refresh List</a></td>
	</tr>
	<tr>
		<td colspan="4"><hr></td>
	</tr>
<cfoutput query="qryGetAccounts">
	<cfif evaluate("Messages" & locLoop & ".RecordCount") gt 0>
		<cfquery name="Messages#locLoop#Reorder" dbtype="query">
			select *
			from Messages#locLoop#
			order by messageNumber desc
		</cfquery>
		<cfset locRecordCount=evaluate("Messages" & locLoop & ".RecordCount")>
		<cfset locEmailID=EmailID>
		<tr>
			<td colspan="4"><strong>#EmailHeader[locLoop][1]#</strong></td>
		</tr>
		
		<form name="delete_messages#CurrentRow#" action="index.cfm?email=#EmailID#" method="post">
		<cfloop query="Messages#locLoop#Reorder">
			<cftry>
				<cfset tempDate=ParseDateTime(date,"POP")>
				<cfset useParsedate=1>
				<cfcatch type="Expression">
					<cfset tempDate=date>
					<cfset useParsedate=0>
				</cfcatch>
			</cftry>
			<tr>
				<td width="3%" align="right"<cfif (CurrentRow mod 2) eq 0> bgcolor="##eeeeee"</cfif>><input type="checkbox" name="deleteThis" value="#messagenumber#"></td>
				<td width="50%"<cfif (CurrentRow mod 2) eq 0> bgcolor="##eeeeee"</cfif>><!--- <strong> ---><a href="bmail_view.cfm?messagenumber=#messageNumber#&total=#locRecordCount#&email=#locEmailID#"><cfif Len(subject) gt 50>#left(subject,50)#...<cfelse>#subject#</cfif></a><!--- </strong> ---></td>
				<td width="25%"<cfif (CurrentRow mod 2) eq 0> bgcolor="##eeeeee"</cfif>><a href="bmail_view.cfm?messagenumber=#messageNumber#&total=#locRecordCount#&email=#locEmailID#">#from#</a></td>
				<td width="22%"<cfif (CurrentRow mod 2) eq 0> bgcolor="##eeeeee"</cfif>><strong><cfif useParseDate eq 1>#DateFormat(tempDate,"m/d")#&nbsp;#TimeFormat(tempDate,"h:mm tt")#<cfelse>#date#</cfif></strong></td>
			</tr>
		</cfloop>
		<tr>
			<td colspan="3" align="left"><a href="javascript:CheckAll(#CurrentRow#)"><strong>Check All</strong></a></td>
		</tr>
		<tr>
			<td colspan="3" align="left"><input type="Submit" value="Delete Selected" class="button_submit"></td>
		</tr>
		</form>
	<cfelse>
		<tr>
			<td colspan="4"><strong>#EmailHeader[locLoop][1]#</strong> - <cfif EmailHeader[locLoop][2]>Error!<cfelse>No Messages</cfif></td>
		</tr>
	</cfif>
	<tr>
		<td colspan="4"><hr></td>
	</tr>
	
	<cfset locLoop=locLoop+1>
</cfoutput>
<tr>
	<td colspan="4"><a href="javascript:openWin()">New Mail</a></td>
</tr>
</table>
<br>

<cfinclude template="bmail_footer.cfm">
<cfsetting showdebugoutput="Yes">