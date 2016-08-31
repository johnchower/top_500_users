/* user_to_cohort_bridges */ 
select uc.user_id, uc.cohort_id, uc.created_date_id
from user_to_cohort_bridges uc
join user_dimensions u
on u.id = uc.user_id
where u.email is not null 
and u.email NOT SIMILAR TO '%(test|tester|gloowizard|tangogroup|gloo|cru|example|lauderdale|10|doe|tango|singularity-interactive)%'
and u.account_type='End User'

/* user_to_champion_bridges */
select upa.user_id, upa.date_id account_created_date_id, uch.champion_id
from user_platform_action_facts upa
join user_dimensions u
on u.id = upa.user_id
join user_connected_to_champion_bridges uch
on u.id=uch.user_id
where u.email is not null 
and u.email NOT SIMILAR TO '%(test|tester|gloowizard|tangogroup|gloo|cru|example|lauderdale|10|doe|tango|singularity-interactive)%'
and u.account_type='End User'
and upa.platform_action='Account Created'
and uch.sequence_number=1

/* user_platform_action_facts */
select up.user_id, up.date_id, up.platform_action
from user_platform_action_facts up
join user_dimensions u
on u.id = up.user_id
where u.email is not null
and u.email NOT SIMILAR TO '%(test|tester|gloowizard|tangogroup|gloo|cru|example|lauderdale|10|doe|tango|singularity-interactive)%'
and u.account_type='End User'

/* cohort_to_champion_bridges */
select * from cohort_to_champion_bridges

/* user_email_name */
select id user_id, email, first_name, last_name
from user_dimensions u
where u.email is not null 
and u.email NOT SIMILAR TO '%(test|tester|gloowizard|tangogroup|gloo|cru|example|lauderdale|10|doe|tango|singularity-interactive)%'
