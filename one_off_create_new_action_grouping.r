# Create new_platformaction_group data frame

new_action_group_temp <- "new_action_grouping_temp.csv" %>%
  read.csv(stringsAsFactors=F)
platformaction_group_new <- data.frame()

for(i in 1:ncol(new_action_group_temp)){
  tempframe <- new_action_group_temp[,i] %>% {
    .[. != ""]
  }

  platformaction_group_new <- tempframe %>% {
    data.frame(platform_action = .)
  } %>% {
    cbind(data.frame(.,
                     group = rep(colnames(new_action_group_temp)[i], times = length(tempframe))
          ))
  } %>% 
    rbind(platformaction_group_new)

}

write.csv(platformaction_group_new, row.names = F)
