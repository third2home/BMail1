<cfquery name="qryGetEmails" datasource="emails">
	select *
	from EmailAccounts,Users
	where UserID=EmailUserID
	order by EmailUserID,EmailID
</cfquery>
<cfinclude template="bmail_header.cfm">
<table border="1" cellpadding="2" cellspacing="0">
<cfoutput query="qryGetEmails" group="EmailUserID">
	<tr>
		<td colspan="3" align="left"><strong>#UserName#</strong></td>
	</tr>
	<cfoutput>
		<tr>
			<td>#EmailAccount#</td>
			<td><a href="bmail_edit_account.cfm?ID=#EmailID#&action=edit">Edit</a></td>
			<td><a href="bmail_edit_account.cfm?ID=#EmailID#&action=delete">Delete</a></td>
		</tr>
	</cfoutput>
</cfoutput>
</table>
<cfinclude template="bmail_footer.cfm">