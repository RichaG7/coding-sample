library(tidyverse)
library(ggtext)
library(magrittr)
library(interactions)
library(scales)
options(scipen=999)

############################## TF ##############################
# df = read.csv("LIWC_df_results_cleaned.csv",
#               na.string = c("", "NA", "na", "NaN", "[]")) %>%
#   select(c(day, tone_pos, tone_neg, emo_pos, emo_neg)) %>%
#   mutate(year_month = gsub("^([0-9]+-[0-9]+)-[0-9]+", "\\1", day),
#          day = as.Date(day, format = "%Y-%m-%d"),
#          tone_pos = round(tone_pos/100, 5),
#          tone_neg = round(tone_neg/100, 5),
#          emo_pos = round(emo_pos/100, 5),
#          emo_neg = round(emo_neg/100, 5))
# df = df %>%
#   mutate(net_sentiment = round(tone_pos - tone_neg, 5),
#          net_emo = round(emo_pos - emo_neg, 5)) %>%
#   mutate(net_sentiment_log = ifelse(net_sentiment<0, -0.5,
#                                     ifelse(net_sentiment==0, 0, 0.5)),
#          net_emo_log = ifelse(net_emo<0, -0.5,
#                               ifelse(net_emo==0, 0, 0.5)))
# write.csv(df, "LIWC_results_clean.csv", row.names = F)

# df_plot_byday = df %>%
#   mutate(net_sentiment = round(tone_pos - tone_neg, 5)) %>%
#   mutate(net_sentiment_log = ifelse(net_sentiment<0, -0.5,
#                                     ifelse(net_sentiment == 0, 0, 0.5))) %>%
#   group_by(day, net_sentiment_log) %>%
#   summarise(no_tweets = n())
# df_plot_byday =  df_plot_byday %>%
#   spread(key = net_sentiment_log, value = no_tweets) %>%
#   rename("Negative" = "-0.5",
#          "Neutral" = "0",
#          "Positive" = "0.5")
# df_plot_byday = as.data.frame(df_plot_byday[order(df_plot_byday$day),])
# df_plot_byday = df_plot_byday %>%
#   mutate(cumulative_positive=cumsum(Positive),
#          cumulative_neutral=cumsum(Neutral),
#          cumulative_negative=cumsum(Negative))
# df_plot_byday = df_plot_byday %>%
#   gather(key = Type, value = no_tweets, Negative:cumulative_negative)
# temp1 = df_plot_byday %>%
#   filter(Type %in% c("Negative", "Neutral", "Positive")) %>%
#   mutate(Type = ifelse(Type == "Negative", -0.5,
#                        ifelse(Type == "Neutral", 0, 0.5)))
# temp2 = df_plot_byday %>%
#   filter(Type %in% c("cumulative_negative", "cumulative_neutral", "cumulative_positive")) %>%
#   mutate(Type = ifelse(Type == "cumulative_negative", -0.5,
#                        ifelse(Type == "cumulative_neutral", 0, 0.5))) %>%
#   rename("no_tweets_cumulative" = "no_tweets")
# df_plot_byday = merge(temp1, temp2, by=c("day", "Type"), all=TRUE) %>%
#   mutate(day = as.Date(day, format = "%Y-%m-%d"))
# df_plot_byday = df_plot_byday[order(df_plot_byday$day),]
# temp1 = df_plot_byday %>%
#   mutate(Type = ifelse(Type == -0.5, "Negative", 
#                        ifelse(Type == 0, "Neutral", 
#                               ifelse(Type == 0.5, "Positive", NA)))) %>%
#   select(-no_tweets_cumulative) %>%
#   spread(key=Type,value = no_tweets)
# temp2 = df_plot_byday %>%
#   mutate(Type = ifelse(Type == -0.5, "Negative", 
#                        ifelse(Type == 0, "Neutral", 
#                               ifelse(Type == 0.5, "Positive", NA)))) %>%
#   select(-no_tweets) %>%
#   spread(key=Type,value = no_tweets_cumulative)
# temp1$day_no = seq(1,nrow(temp1))
# temp2$day_no = seq(1,nrow(temp2))
# temp1 = temp1 %>%
#   gather(key = "type", value = "no_tweets", Negative:Positive)
# temp2 = temp2 %>%
#   gather(key = "type", value = "no_tweets_cumulative", Negative:Positive)
# df_plot_byday = merge(temp1, temp2, by=names(temp1)[names(temp1) %in% names(temp2)], all=TRUE) %>%
#     mutate(day = as.Date(day, format = "%Y-%m-%d"))
# df_plot_byday = df_plot_byday[order(df_plot_byday$day),] %>% distinct()
# rm(temp1, temp2)
# temp1 = df_sentiment %>%
#   select(date, positive_tone, negative_tone) %>%
#   rename(day = date)
# df_plot_byday = merge(df_plot_byday, temp1, by="day", all=TRUE) %>% distinct()
# rm(temp1)
# write.csv(df_plot_byday, "df_tweets_byday.csv", row.names = F)

# df_plot_bymonth = df %>%
#   mutate(net_sentiment = round(tone_pos - tone_neg, 5)) %>%
#   mutate(net_sentiment_log = ifelse(net_sentiment<0, -0.5,
#                                     ifelse(net_sentiment == 0, 0, 0.5))) %>%
#   group_by(year_month, net_sentiment_log) %>%
#   summarise(no_tweets = n())
# df_plot_bymonth =  df_plot_bymonth %>%
#   spread(key = net_sentiment_log, value = no_tweets) %>%
#   rename("Negative" = "-0.5",
#          "Neutral" = "0",
#          "Positive" = "0.5") %>%
#   mutate(cumulative_positive=cumsum(Positive),
#          cumulative_neutral=cumsum(Neutral),
#          cumulative_negative=cumsum(Negative)) %>%
#   gather(key = Type, value = no_tweets, Negative:cumulative_negative)
# temp1 = df_plot_bymonth %>%
#   filter(Type %in% c("Negative", "Neutral", "Positive")) %>%
#   mutate(Type = ifelse(Type == "Negative", -0.5,
#                        ifelse(Type == "Neutral", 0, 0.5)))
# temp2 = df_plot_bymonth %>%
#   filter(Type %in% c("cumulative_negative", "cumulative_neutral", "cumulative_positive")) %>%
#   mutate(Type = ifelse(Type == "cumulative_negative", -0.5,
#                        ifelse(Type == "cumulative_neutral", 0, 0.5))) %>%
#   rename("no_tweets_cumulative" = "no_tweets")
# df_plot_bymonth = merge(temp1, temp2, by=c("year_month", "Type"), all=TRUE)
# df_plot_bymonth = df_plot_bymonth[order(df_plot_bymonth$year_month),]
# rm(temp1, temp2)
# temp1 = df %>% 
#     group_by(year_month) %>%
#     summarise(Positive = mean(tone_pos, na.rm=TRUE),
#               Negative = mean(tone_neg, na.rm=TRUE))
# df_plot_bymonth = merge(df_plot_bymonth, temp1, by="year_month", all=TRUE) %>% 
#   distinct() %>%
#   rename(type = Type) %>%
#   mutate(type = ifelse(type == -0.5, "Negative",
#                        ifelse(type == 0, "Neutral",
#                               ifelse(type == 0.5, "Positive", NA))))
# df_plot_bymonth = df_plot_bymonth[order(df_plot_bymonth$year_month),]
# rm(temp1)
# write.csv(df_plot_bymonth, "df_tweets_bymonth.csv", row.names = F)

df = read.csv("LIWC_results_clean.csv",
              na.string = c("", "NA", "na", "NaN", "[]"))

df_plot_byday = read.csv("df_tweets_byday.csv")

df_plot_bymonth = read.csv("df_tweets_bymonth.csv")

png("Figure1.png", units="in", width=14, height=8, res=800)
df_plot_byday %>%
  group_by(day_no) %>%
  summarise(no_tweets = sum(no_tweets, na.rm=TRUE)) %>%
  ggplot(aes(x = day_no, y = no_tweets)) +
  geom_point() +
  geom_line(aes(group = 1)) +
  scale_x_continuous(breaks=c(1, 32, 62, 93, 123, 154, 185, 215, 246, 276, 307, 338, 367, 398, 428, 459, 489, 520, 551, 581, 612, 642, 673, 704, 732, 763, 793),
                     labels=unique(df_plot_byday$day)[c(1, 32, 62, 93, 123, 154, 185, 215, 246, 276, 307, 338, 367, 398, 428, 459, 489, 520, 551, 581, 612, 642, 673, 704, 732, 763, 793)],
                     minor_breaks = NULL) +
  coord_cartesian(ylim = c(12000, 16000)) +
  scale_y_continuous(breaks = seq(12000, 16000, by = 200)) +
  labs(x = "Time", 
       y = "Number of Tweets") + 
  theme_minimal() +
  theme(axis.title.y = element_text(face = "bold", size = 22),
        axis.title.x = element_text(face = "bold", size = 22),
        axis.text.y = element_text(face = "bold", size = 14),
        axis.text.x = element_text(face="bold", size=14, angle=30),
        legend.title = element_text(face = "bold", size = 16),
        legend.text = element_text(size = 14),
        panel.grid.minor.y = element_blank())
dev.off()

png("Figure2a.png", units="in", width=14, height=8, res=800)
df_plot_byday %>%
  group_by(day_no) %>%
  summarise(Positive = mean(positive_tone, na.rm=TRUE),
            Negative = mean(negative_tone, na.rm=TRUE)) %>%
  gather(key = "type", value = "sentiment", Positive:Negative) %>%
  ggplot(aes(x = day_no, y = sentiment, group = type, fill = type, color = type)) +
  geom_path() +
  geom_point() +
  geom_vline(xintercept = unique(df_plot_byday$day_no[which(df_plot_byday$day == "2020-01-19")]), 
             colour="red", linetype = "longdash") +
  scale_color_manual(values = c("#8E1916", "#274464"), labels=c('Negative', 'Positive')) +
  scale_x_continuous(breaks=c(1, 32, 62, 93, 123, 154, 185, 215, 246, 276, 307, 338, 367, 398, 428, 459, 489, 520, 551, 581, 612, 642, 673, 704, 732, 763, 793),
                     labels=unique(df_plot_byday$day)[c(1, 32, 62, 93, 123, 154, 185, 215, 246, 276, 307, 338, 367, 398, 428, 459, 489, 520, 551, 581, 612, 642, 673, 704, 732, 763, 793)],
                     minor_breaks = NULL) +
  expand_limits(y = c(0,0.10)) +
  labs(x = "Time", 
       y = "Proportion of words conveying sentiment",
       color = "Sentiment type") + 
  guides(fill = "none", group='none') +
  theme_minimal() +
  theme(axis.title.y = element_text(face = "bold", size = 22),
        axis.title.x = element_text(face = "bold", size = 22),
        axis.text.y = element_text(face = "bold", size = 14),
        axis.text.x = element_text(face="bold", size=14, angle=30),
        legend.title = element_text(face = "bold", size = 16),
        legend.text = element_text(size = 14),
        panel.grid.minor.y = element_blank())
dev.off()

png("Figure2b.png", units="in", width=14, height=8, res=800)
df_plot_bymonth %>%
  group_by(year_month) %>%
  summarise(Positive = mean(Positive, na.rm=TRUE),
            Negative = mean(Negative, na.rm=TRUE)) %>%
  gather(key = "type", value = "sentiment", Positive:Negative) %>%
  ggplot(aes(x = year_month, y = sentiment, group = type, fill = type, color = type)) +
  geom_path(linewidth=1) +
  #geom_point() +
  geom_vline(xintercept = "2020-01", colour="red", linetype = "longdash") +
  geom_vline(xintercept = "2020-02", colour="red", linetype = "longdash") +
  scale_color_manual(values = c("#8E1916", "#274464"), labels=c('Negative', 'Positive')) +
  coord_cartesian(ylim = c(0, 0.032)) +
  scale_y_continuous(breaks = seq(0, 0.032, by = 0.002)) +
  labs(x = "Time", 
       y = "Proportion of words conveying sentiment",
       color = "Sentiment type") + 
  guides(fill = "none", group='none') +
  theme_minimal() +
  theme(axis.title.y = element_text(face = "bold", size = 22),
        axis.title.x = element_text(face = "bold", size = 22),
        axis.text.y = element_text(face = "bold", size = 14),
        axis.text.x = element_text(face="bold", size=14, angle=30),
        legend.title = element_text(face = "bold", size = 16),
        legend.text = element_text(size = 14),
        panel.grid.minor.y = element_blank())
dev.off()

png("Figure2c.png", units="in", width=14, height=8, res=800)
df_plot_byday %>%
  ggplot(aes(x = day_no, y = no_tweets_cumulative, color = type, group = type)) +
  geom_area(aes(fill = type)) + 
  scale_color_manual(values = c("#8E1916", "#808080", "#274464")) +
  scale_fill_manual(values = c("#8E1916", "#808080", "#274464")) +
  scale_x_continuous(breaks=c(1, 32, 62, 93, 123, 154, 185, 215, 246, 276, 307, 338, 367, 398, 428, 459, 489, 520, 551, 581, 612, 642, 673, 704, 732, 763, 793),
                     labels=unique(df_plot_byday$day)[c(1, 32, 62, 93, 123, 154, 185, 215, 246, 276, 307, 338, 367, 398, 428, 459, 489, 520, 551, 581, 612, 642, 673, 704, 732, 763, 793)],
                     minor_breaks = NULL) +
  labs(x = "Time", 
       y = "Number of tweets (cumulative)",
       color = "Sentiment type",
       fill = "Sentiment type") + 
  theme_minimal() +
  theme(axis.title.y = element_text(face = "bold", size = 22),
        axis.title.x = element_text(face = "bold", size = 22),
        axis.text.y = element_text(face = "bold", size = 14),
        axis.text.x = element_text(face="bold", size=14, angle=30),
        legend.title = element_text(face = "bold", size = 16),
        legend.text = element_text(size = 14),
        panel.grid.minor.y = element_blank())
dev.off()

png("Figure2d.png", units="in", width=14, height=8, res=800)
df_plot_bymonth %>%
  filter(type %in% c("Positive", "Negative")) %>%
  ggplot(aes(x = year_month, y = no_tweets, fill = type, color = type)) +
  geom_col(position = "fill", alpha = 0.5) + 
  scale_fill_manual(values = c("#8E1916", "#274464")) +
  scale_color_manual(values = c("#8E1916", "#274464")) +
  geom_vline(xintercept = "2020-01", colour="red", linetype = "longdash") +
  geom_vline(xintercept = "2020-02", colour="red", linetype = "longdash") +
  labs(x = "Time", 
       y = "Proportion of non-neutral tweets",
       color = "Sentiment type",
       fill = "Sentiment type") + 
  theme_minimal() +
  theme(axis.title.y = element_text(face = "bold", size = 22),
        axis.title.x = element_text(face = "bold", size = 22),
        axis.text.y = element_text(face = "bold", size = 14),
        axis.text.x = element_text(face="bold", size=14, angle=30),
        legend.title = element_text(face = "bold", size = 16),
        legend.text = element_text(size = 14),
        panel.grid.minor.y = element_blank())
dev.off()

df_nyt = read.csv("df_nyt.csv", 
                  stringsAsFactors = FALSE, 
                  na.string = c("", "NA", "na", "NaN", "[]"))

df_grouped = df %>% 
  group_by(day) %>% 
  summarize(positive_tone = mean(tone_pos, na.rm=TRUE), 
            positive_tone_se = sd(tone_pos, na.rm=TRUE)/sqrt(n()),
            negative_tone = mean(tone_neg, na.rm=TRUE),
            negative_tone_se = sd(tone_neg, na.rm=TRUE)/sqrt(n())) %>%
  rename("date" = "day") %>% 
  mutate(Condition = ifelse(date < "2020-01-19", -0.5, 0.5))

# df_sentiment = merge(df_grouped, df_nyt, by="date", all.x = TRUE)
# df_sentiment[c("total", "chinese", "asian", "political")][is.na(df_sentiment[c("total", "chinese", "asian", "political")])] = 0
# 
# day_post = seq(1:nrow(df_sentiment[df_sentiment$Condition == 0.5,]))
# day_pre = seq(1:nrow(df_sentiment[df_sentiment$Condition == -0.5,]))
# day_pre = day_pre - (max(day_pre)+1)
# days = c(day_pre, day_post)
# df_sentiment$day = days
# df_sentiment = df_sentiment %>%
#   mutate(total_cumulative = cumsum(total),
#          political_cumulative = cumsum(political),
#          asian_cumulative = cumsum(asian),
#          chinese_cumulative = cumsum(chinese))
# write.csv(df_sentiment, "sentiment.csv", row.names = FALSE)

df_sentiment = read.csv("sentiment.csv")

model = lm(positive_tone ~ Condition, data = df_sentiment)
summary = summary(model) # significant reduction
coef = summary$coefficients
confint = confint(model)
possentiment_prepost_statstable = merge(coef, confint, by = "row.names", all=TRUE)

png("Figure3a.png", units="in", width=14, height=8, res=800)
df_sentiment %>% 
  group_by(Condition) %>%
  summarise(Positive_sentiment = mean(positive_tone, na.rm=TRUE), 
            SE = sd(positive_tone, na.rm=TRUE)/sqrt(n())) %>%
  mutate(y_lower = Positive_sentiment - SE, y_upper = Positive_sentiment + SE) %>%
  ggplot(aes(x=as.factor(Condition), y=Positive_sentiment, fill=as.factor(Condition))) + 
  geom_col(color = "#274464", width = 0.5) +
  geom_errorbar(aes(ymin = y_lower, ymax = y_upper), width=0.3,
                linewidth=0.5,
                position=position_dodge(0.3)) +
  scale_fill_manual(values = c("#274464", "#274464")) +
  scale_x_discrete(labels = c("Pre-outbreak","Post-outbreak")) +
  coord_cartesian(ylim = c(0, 0.0275)) +
  scale_y_continuous(breaks = seq(0, 0.0275, by = 0.0025)) +
  labs(x = "Time", 
       y = "Proportion of positive sentiment\nwords in the average tweet") +
  guides(fill = "none") +
  theme_minimal() +
  theme(axis.title.y = element_text(face = "bold", size = 22),
        axis.title.x = element_text(face = "bold", size = 22),
        axis.text.y = element_text(face = "bold", size = 14),
        axis.text.x = element_text(face="bold", size=14),
        legend.title = element_text(face = "bold", size = 16),
        legend.text = element_text(size = 14),
        panel.grid.minor.y = element_blank())
dev.off()

summary(lm(negative_tone ~ Condition, data = df_sentiment)) # significant increase
confint(lm(negative_tone ~ Condition, data = df_sentiment))

png("Figure3b.png", units="in", width=14, height=8, res=800)
df_sentiment %>% 
  group_by(Condition) %>%
  summarise(Negative_sentiment = mean(negative_tone, na.rm=TRUE), 
            SE = sd(negative_tone, na.rm=TRUE)/sqrt(n())) %>%
  mutate(y_lower = Negative_sentiment - SE, y_upper = Negative_sentiment + SE) %>%
  ggplot(aes(x=as.factor(Condition), y=Negative_sentiment, fill=as.factor(Condition))) + 
  geom_col(color = "#8E1916", width = 0.5) +
  geom_errorbar(aes(ymin = y_lower, ymax = y_upper), width=0.25,
                linewidth=0.5,
                position=position_dodge(0.3)) +
  scale_fill_manual(values = c("#8E1916", "#8E1916")) +
  scale_x_discrete(labels = c("Pre-outbreak","Post-outbreak")) +
  coord_cartesian(ylim = c(0, 0.024)) +
  scale_y_continuous(breaks = seq(0, 0.024, by = 0.002)) +
  labs(x = "Time", 
       y = "Proportion of negative sentiment\nwords in the average tweet") +
  guides(fill = "none") +
  theme_minimal() +
  theme(axis.title.y = element_text(face = "bold", size = 22),
        axis.title.x = element_text(face = "bold", size = 22),
        axis.text.y = element_text(face = "bold", size = 14),
        axis.text.x = element_text(face="bold", size=14),
        legend.title = element_text(face = "bold", size = 16),
        legend.text = element_text(size = 14),
        panel.grid.minor.y = element_blank())
dev.off()

model = lm(positive_tone ~ total + day, data = df_sentiment %>% filter(day > 0))
summary(model) # day significant
confint(model)

model = lm(negative_tone ~ total + day, data = df_sentiment %>% filter(day > 0))
summary(model) # day significant
confint(model)

model = lm(positive_tone ~ political + day, data = df_sentiment %>% filter(day > 0))
summary(model) # political significant and negative
confint(model)

png("Figure4a.png", units="in", width=14, height=10, res=800)
df_sentiment %>% 
  filter(day > 0) %>%
  ggplot(aes(x=political, y=positive_tone, 
             ymin=positive_tone-positive_tone_se, ymax=positive_tone+positive_tone_se)) + 
  geom_point(size = 2, color = "#274464") +
  geom_smooth(method = "lm", color="#274464") +
  coord_cartesian(ylim = c(0, 0.08)) +
  scale_y_continuous(breaks = seq(0, 0.08, by = 0.01)) +
  labs(x = "Number of COVID-19 news articles\nthat also mentioned politics", 
       y = "Proportion of positive sentiment\nwords in the average tweet") +
  theme_minimal() +
  theme(axis.title.y = element_text(face = "bold", size = 22),
        axis.title.x = element_text(face = "bold", size = 22),
        axis.text.y = element_text(face = "bold", size = 14),
        axis.text.x = element_text(face="bold", size=14),
        legend.title = element_text(face = "bold", size = 16),
        legend.text = element_text(size = 14),
        panel.grid.minor.y = element_blank())
dev.off()

model = lm(negative_tone ~ political + day, data = df_sentiment %>% filter(day > 0))
summary(model) # both significant and positive
confint(model)

png("Figure4b.png", units="in", width=14, height=10, res=800)
df_sentiment %>% 
  filter(day > 0) %>%
  ggplot(aes(x=political, y=negative_tone, 
             ymin=negative_tone-negative_tone_se, ymax=negative_tone+negative_tone_se)) + 
  geom_point(size = 2, color = "#8E1916") +
  geom_smooth(method = "lm", color="#8E1916") +
  coord_cartesian(ylim = c(0, 0.06)) +
  scale_y_continuous(breaks = seq(0, 0.06, by = 0.01)) +
  labs(x = "Number of COVID-19 news articles\nthat also mentioned politics", 
       y = "Proportion of negative sentiment\nwords in the average tweet") +
  theme_minimal() +
  theme(axis.title.y = element_text(face = "bold", size = 22),
        axis.title.x = element_text(face = "bold", size = 22),
        axis.text.y = element_text(face = "bold", size = 14),
        axis.text.x = element_text(face="bold", size=14),
        legend.title = element_text(face = "bold", size = 16),
        legend.text = element_text(size = 14),
        panel.grid.minor.y = element_blank())
dev.off()

model = lm(positive_tone ~ asian + day, data = df_sentiment %>% filter(day > 0))
summary(model) # day significant
confint(model)

model = lm(positive_tone ~ chinese + day, data = df_sentiment %>% filter(day > 0))
summary(model) # day significant
confint(model)

model = lm(negative_tone ~ asian + day, data = df_sentiment %>% filter(day > 0))
summary(model) # both significant and positive
confint(model)

png("Figure5a.png", units="in", width=14, height=10, res=800)
df_sentiment %>% 
  filter(day > 0) %>%
  ggplot(aes(x=asian, y=negative_tone, 
             ymin=negative_tone-negative_tone_se, ymax=negative_tone+negative_tone_se)) + 
  geom_point(size = 2, color = "#8E1916") +
  geom_smooth(method = "lm", color="#8E1916") +
  coord_cartesian(ylim = c(0, 0.06)) +
  scale_y_continuous(breaks = seq(0, 0.06, by = 0.01)) +
  labs(x = "Number of COVID-19 news articles\nthat also mentioned Asia or Asian people", 
       y = "Proportion of negative sentiment\nwords in the average tweet") +
  theme_minimal() +
  theme(axis.title.y = element_text(face = "bold", size = 22),
        axis.title.x = element_text(face = "bold", size = 22),
        axis.text.y = element_text(face = "bold", size = 14),
        axis.text.x = element_text(face="bold", size=14),
        legend.title = element_text(face = "bold", size = 16),
        legend.text = element_text(size = 14),
        panel.grid.minor.y = element_blank())
dev.off()

model = lm(negative_tone ~ chinese + day, data = df_sentiment %>% filter(day > 0))
summary(model) # both significant and positive
confint(model)

png("Figure5b.png", units="in", width=14, height=10, res=800)
df_sentiment %>% 
  filter(day > 0) %>%
  ggplot(aes(x=chinese, y=negative_tone, 
             ymin=negative_tone-negative_tone_se, ymax=negative_tone+negative_tone_se)) + 
  geom_point(size = 2, color="#8E1916") +
  geom_smooth(method = "lm", color="#8E1916") +
  coord_cartesian(ylim = c(0, 0.06)) +
  scale_y_continuous(breaks = seq(0, 0.06, by = 0.01)) +
  labs(x = "Number of COVID-19 news articles\nthat also mentioned China or Chinese people", 
       y = "Proportion of negative sentiment\nwords in the average tweet") +
  theme_minimal() +
  theme(axis.title.y = element_text(face = "bold", size = 22),
        axis.title.x = element_text(face = "bold", size = 22),
        axis.text.y = element_text(face = "bold", size = 14),
        axis.text.x = element_text(face="bold", size=14),
        legend.title = element_text(face = "bold", size = 16),
        legend.text = element_text(size = 14),
        panel.grid.minor.y = element_blank())
dev.off()
