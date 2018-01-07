<cfsetting enablecfoutputonly="Yes">

<cfquery name="qryGetEmails" datasource="emails">
	select *
	from EmailAccounts,Users
	where UserID=EmailUserID
	order by EmailUserID,EmailID
</cfquery>

<cfoutput query = qryGetEmails>
 server="#EmailServer#" username="#EmailLoginID#" password="#EmailPassword#" name="Messages">
</cfoutput>