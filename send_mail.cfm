<cfmail to="#form.to_value#" from="#form.from_value#" subject="#form.subject_value#" server="mail.third2home.com" timeout=60>
#form.body_value#
</cfmail>
<html>
	<body onLoad="window.close()"></body>
</html>