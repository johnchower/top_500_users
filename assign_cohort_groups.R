# Assign cohort groups

user_cohort_groups <- user_to_cohort_bridges %>%
  select(-created_date_id) %>%
  left_join(cohort_to_champion_bridges) %>% 
  rename(cohort_champion_id = champion_id) %>% {
    left_join(
      select(user_createddate_champid, user_id, first_champion_id = champion_id),
      .
    )
  } %>%
  mutate(belongs_to_cohort = ifelse(is.na(cohort_id),
                                    F, T),
         champion_id = ifelse(is.na(cohort_id),
                              first_champion_id,
                              cohort_champion_id)) %>%
  select(user_id, champion_id, belongs_to_cohort) %>%
  left_join(select(champion_facts, champion_id, champion_name)) %>%
  mutate(cohort_group_name = ifelse(belongs_to_cohort,
                                    paste("Cohort", champion_name, sep = " - "),
                                    paste("No Cohort", champion_name, sep = " - ")
  ))
