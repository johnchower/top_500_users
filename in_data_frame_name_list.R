# Input: data_frame_name_list

name_list <- list(
  list(
    col.names = c("cohort_id", "champion_id"), 
    assigned_name = "cohort_to_champion_bridges"
  ),
  list(
    col.names = c("user_id", "cohort_id", "created_date_id"), 
    assigned_name = "user_to_cohort_bridges"
  ),
  list(
    col.names = c("user_id", "account_created_date_id", "champion_id"), 
    assigned_name = "user_createddate_champid"
  ),
  list(
    col.names = c("user_id", "date_id", "platform_action"), 
    assigned_name = "user_platform_action_facts"
  ),
  list(
    col.names = c("user_id"),
    assigned_name = "fake_end_users"
  ),
  list(
    col.names = c("platform_action", "group", "mode", "end_user_allowed"),
    assigned_name = "platform_action_facts"
  ),
  list(
    col.names = c("champion_id", "champion_name",	"champion_organization", "dont.exclude"),
    assigned_name = "champion_facts"
  ),
  list(
    col.names = c("user_id", "email", "first_name", "last_name"),
    assigned_name = "user_email_name"
  )
)