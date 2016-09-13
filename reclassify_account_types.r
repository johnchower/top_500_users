# Reclassify account types

user_createddate_champid %<>%
  mutate(
    Account_Type =
      ifelse(
        user_id %in% end_users_who_are_actually_internal_gloo_users,
        "Internal User",
        ifelse(
          account_type == "End User" & (user_id %in% users_with_champ_emails),
          "Champion User",
          ifelse(
            user_id %in% end_users_who_have_taken_a_champ_only_action,
            "Champion User",
            account_type
          )
        )
      )
  )
