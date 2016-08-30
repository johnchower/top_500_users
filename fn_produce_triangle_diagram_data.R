# Function: produce triangle diagram data

produce_triangle_diagram_data <- function(up = user_platform_action_facts,
                                          pa = platform_action_facts,
                                          maxdate = as.Date(as.character(max_date), format = "%Y%m%d")){
  
  up %>%
    mutate(date = as.Date(as.character(date_id), format = "%Y%m%d")) %>%
    group_by(user_id) %>%
    mutate(min_date = min(date)) %>% 
    ungroup %>%
    filter(date < min_date + 28) %>% 
    left_join(select(pa, platform_action, mode)) %>%
    group_by(user_id) %>%
    summarise(
      number_of_actions = sum(mode %in% c("Receive.Value", "Invest.for.Self.Us", "Champion.Others"))
      , Receive.Value_pct =
        ifelse(
          number_of_actions == 0
          , 1/3
          , sum(mode == "Receive.Value")/number_of_actions
        )
      , Invest.for.Self.Us_pct =
        ifelse(
          number_of_actions == 0
          , 1/3
          , sum(mode == "Invest.for.Self.Us")/number_of_actions
        )
      , Champion.Others_pct =
        ifelse(
          number_of_actions == 0
          , 1/3
          , sum(mode == "Champion.Others")/number_of_actions
        )
      , actions_per_day_past_month = sum(date >= (maxdate - 28))/28
      , largest_pct = max(Receive.Value_pct, Invest.for.Self.Us_pct, Champion.Others_pct)
    ) %>% 
    mutate(mode = ifelse(largest_pct == Receive.Value_pct,
                     "Receive Value",
                     ifelse(largest_pct == Champion.Others_pct,
                       "Champion Others",
                       "Invest for Self/Us"))) %>%
    mutate(mode = factor(mode, levels = c("Receive Value", "Invest for Self/Us", "Champion Others"))) %>%
    ungroup %>%
    create_convex_data
}