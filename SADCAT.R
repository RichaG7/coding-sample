library(tidyverse)
library(ggtext)
options(scipen = 999)
############################## Term Proportion ##############################
df_tp = read.csv("df_tp.csv", stringsAsFactors = FALSE, 
                 na.string = c("", "NA", "na", "NaN", "[]")) %>%
  mutate(year_month = gsub("^([0-9]+-[0-9]+)-[0-9]+", "\\1", date),
         date = as.Date(date, "%Y-%m-%d"))
df_grouped_tp = df_tp %>% 
  group_by(date, category) %>% 
  summarize(tp = sum(proportion, na.rm = TRUE), 
            tp_se = sd(proportion, na.rm=TRUE)/sqrt(n()),
            total = mean(total, na.rm=T), 
            chinese = mean(chinese, na.rm=T), 
            asian = mean(asian, na.rm=T), 
            political = mean(political, na.rm=T))

temp1 = df_grouped_tp %>% select(-tp_se) %>% spread(category, tp) %>% distinct()
temp2 = df_grouped_tp %>% select(-tp) %>% spread(category, tp_se) %>% distinct()
temp2 = temp2 %>% select(date, Cold, Competent, Diseased, Foreign, Incompetent, Warm)
names(temp2) = c("date", "Cold_se", "Competent_se", "Diseased_se", "Foreign_se", "Incompetent_se", "Warm_se")
df_grouped_tp = merge(temp1, temp2, by="date")
rm(temp1, temp2)

df_grouped_tp = df_grouped_tp %>%
  mutate(Condition = ifelse(date < "2020-01-19", -0.5, 0.5))

day_post = seq(1:nrow(df_grouped_tp[df_grouped_tp$Condition == 0.5,]))
day_pre = seq(1:nrow(df_grouped_tp[df_grouped_tp$Condition == -0.5,]))
day_pre = day_pre - (max(day_pre)+1)
days = c(day_pre, day_post)
df_grouped_tp$day = days

df_grouped_tp = df_grouped_tp %>%
  mutate(total_cumulative = cumsum(total),
         political_cumulative = cumsum(political),
         asian_cumulative = cumsum(asian),
         chinese_cumulative = cumsum(chinese))
write.csv(df_grouped_tp, "df_grouped_tp.csv", row.names = F)

df_grouped_tp = read.csv("df_grouped_tp.csv")
############################## Pre-Post ##############################
summary(lm(Cold ~ Condition, data = df_grouped_tp))

model = lm(Warm ~ Condition, data = df_grouped_tp)
summary(model) # significant negative effect
confint(model)

png("Figure8a.png", units="in", width=14, height=10, res=800)
df_grouped_tp %>% 
  group_by(Condition) %>%
  summarise(Warmth = mean(Warm, na.rm=TRUE), SE = sd(Warm, na.rm=TRUE)/sqrt(n())) %>%
  mutate(y_lower = Warmth - SE, y_upper = Warmth + SE) %>%
  ggplot(aes(x=as.factor(Condition), y=Warmth, fill=as.factor(Condition))) + 
  geom_col(color = "#274464", alpha = 0.95, width = 0.5) +
  geom_errorbar(aes(ymin = y_lower, ymax = y_upper), width=0.25,
                linewidth=1,
                position=position_dodge(0.3)) +
  scale_fill_manual(values = c("#274464", "#274464")) +
  scale_x_discrete(labels = c("Pre-pandemic","Post-pandemic")) +
  coord_cartesian(ylim=c(0,0.0035)) +
  scale_y_continuous(breaks = seq(0, 0.0035, by = 0.0005)) +
  labs(x = "Time", 
       y = "Proportion of warm\nstereotype words") +
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

model = lm(Competent ~ Condition, data = df_grouped_tp)
summary(model) # significant positive effect
confint(model)

png("Figure8b.png", units="in", width=14, height=10, res=800)
df_grouped_tp %>% 
  group_by(Condition) %>%
  summarise(Competence = mean(Competent, na.rm=TRUE), SE = sd(Competent, na.rm=TRUE)/sqrt(n())) %>%
  mutate(y_lower = Competence - SE, y_upper = Competence + SE) %>%
  ggplot(aes(x=as.factor(Condition), y=Competence, fill=as.factor(Condition))) + 
  geom_col(color = "#274464", alpha = 0.95, width = 0.5) +
  geom_errorbar(aes(ymin = y_lower, ymax = y_upper), width=0.25,
                linewidth=1,
                position=position_dodge(0.3)) +
  scale_fill_manual(values = c("#274464", "#274464")) +
  scale_x_discrete(labels = c("Pre-pandemic","Post-pandemic")) +
  coord_cartesian(ylim=c(0,0.0009)) +
  scale_y_continuous(breaks = seq(0, 0.0009, by = 0.0001)) +
  labs(x = "Time", 
       y = "Proportion of competent\nstereotype words") +
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

summary(lm(Incompetent ~ Condition, data = df_grouped_tp))
# summary(lm(Foreign ~ Condition, data = df_grouped_tp)) # marginal negative effect
# summary(lm(Diseased ~ Condition, data = df_grouped_tp))

############################## As a function of news articles ##############################
summary(lm(Cold ~ total + day, data = df_grouped_tp %>% filter(day > 0)))
summary(lm(Warm ~ total + day, data = df_grouped_tp %>% filter(day > 0)))

model = lm(Competent ~ total + day, data = df_grouped_tp %>% filter(day > 0))
summary(model) # day significant and positive
confint(model)

png("Figure9a.png", units="in", width=14, height=10, res=800)
df_grouped_tp %>% 
  filter(day > 0, total < 200) %>%
  ggplot(aes(x = day, y = Competent, 
             ymin = Competent-Competent_se, ymax = Competent+Competent_se, 
             color = total)) +
  geom_point(size=2) + 
  geom_smooth(method = "lm", color="#274464") +
  scale_colour_gradient(low = "#8696A8", high = "#0A182A") +
  coord_cartesian(ylim = c(0, 0.008)) +
  scale_y_continuous(breaks = seq(0, 0.008, by = 0.001)) +
  labs(x = "Days into the post-outbreak period", 
       y = "Proportion of competence-conveying\nwords in a typical tweet",
       color = "Total number of articles\npublished on COVID-19") +
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

model = lm(Incompetent ~ total + day, data = df_grouped_tp %>% filter(day > 0))
summary(model) # day significant and negative
confint(model)

png("Figure9b.png", units="in", width=14, height=10, res=800)
df_grouped_tp %>% 
  filter(day > 0, total < 200) %>%
  ggplot(aes(x = day, y = Incompetent, 
             ymin = Incompetent-Incompetent_se, ymax = Incompetent+Incompetent_se, 
             color = total)) +
  geom_point(size=2) + 
  geom_smooth(method = "lm", color="#8E1916") +
  scale_colour_gradient(low = "#EAAC8B", high = "#65010C") +
  coord_cartesian(ylim = c(0, 0.008)) +
  scale_y_continuous(breaks = seq(0, 0.008, by = 0.001)) +
  labs(x = "Days into the post-outbreak period", 
       y = "Proportion of incompetence-conveying\nwords in a typical tweet",
       color = "Total number of articles\npublished on COVID-19") +
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

############################## As a function of political news articles ##############################
summary(lm(Cold ~ political + day, data = df_grouped_tp %>% filter(day > 0)))
summary(lm(Warm ~ political + day, data = df_grouped_tp %>% filter(day > 0))) 

model = lm(Competent ~ political + day, data = df_grouped_tp %>% filter(day > 0))
summary(model) # day significant and positive
confint(model)

png("Figure10a.png", units="in", width=14, height=10, res=800)
df_grouped_tp %>% 
  filter(day > 0) %>%
  ggplot(aes(x = day, y = Competent, 
             ymin = Competent-Competent_se, ymax = Competent+Competent_se, 
             color = political)) +
  geom_point(size=2) + 
  geom_smooth(method = "lm", color="#274464") +
  scale_colour_gradient(low = "#8696A8", high = "#0A182A") +
  coord_cartesian(ylim = c(0, 0.008)) +
  scale_y_continuous(breaks = seq(0, 0.008, by = 0.001)) +
  labs(x = "Days into the post-outbreak period", 
       y = "Proportion of competence-conveying\nwords in a typical tweet",
       color = "Number of COVID-19 news articles\nthat also mentioned politics") +
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

model = lm(Incompetent ~ political + day, data = df_grouped_tp %>% filter(day > 0))
summary(model) # day significant and negative
confint(model)

png("Figure11a.png", units="in", width=14, height=10, res=800)
df_grouped_tp %>% 
  filter(day > 0) %>%
  ggplot(aes(x = day, y = Incompetent, 
             ymin = Incompetent-Incompetent_se, ymax = Incompetent+Incompetent_se, 
             color = political)) +
  geom_point(size=2) + 
  geom_smooth(method = "lm", color="#8E1916") +
  scale_colour_gradient(low = "#EAAC8B", high = "#65010C") +
  coord_cartesian(ylim = c(0, 0.008)) +
  scale_y_continuous(breaks = seq(0, 0.008, by = 0.001)) +
  labs(x = "Days into the post-outbreak period", 
       y = "Proportion of incompetence-conveying\nwords in a typical tweet",
       color = "Number of COVID-19 news articles\nthat also mentioned politics") +
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

############################## As a function of news articles mentioning Asians ##############################
summary(lm(Cold ~ asian + day, data = df_grouped_tp %>% filter(day > 0))) # day trend
summary(lm(Warm ~ asian + day, data = df_grouped_tp %>% filter(day > 0)))

model = lm(Competent ~ asian + day, data = df_grouped_tp %>% filter(day > 0))
summary(model) # day significant and positive
confint(model)

png("Figure10b.png", units="in", width=14, height=10, res=800)
df_grouped_tp %>% 
  filter(day > 0) %>%
  ggplot(aes(x = day, y = Competent, 
             ymin = Competent-Competent_se, ymax = Competent+Competent_se, 
             color = asian)) +
  geom_point(size=2) + 
  geom_smooth(method = "lm", color="#274464") +
  scale_colour_gradient(low = "#8696A8", high = "#0A182A") +
  coord_cartesian(ylim = c(0, 0.008)) +
  scale_y_continuous(breaks = seq(0, 0.008, by = 0.001)) +
  labs(x = "Days into the post-outbreak period", 
       y = "Proportion of competence-conveying\nwords in a typical tweet",
       color = "Number of COVID-19\nnews articles that also\nmentioned Asia or\nAsian people") +
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

model = lm(Incompetent ~ asian + day, data = df_grouped_tp %>% filter(day > 0))
summary(model) # day significant and negative
confint(model)

png("Figure11b.png", units="in", width=14, height=10, res=800)
df_grouped_tp %>% 
  filter(day > 0) %>%
  ggplot(aes(x = day, y = Incompetent, 
             ymin = Incompetent-Incompetent_se, ymax = Incompetent+Incompetent_se, 
             color = asian)) +
  geom_point(size=2) + 
  geom_smooth(method = "lm", color="#8E1916") +
  scale_colour_gradient(low = "#EAAC8B", high = "#65010C") +
  coord_cartesian(ylim = c(0, 0.008)) +
  scale_y_continuous(breaks = seq(0, 0.008, by = 0.001)) +
  labs(x = "Days into the post-outbreak period", 
       y = "Proportion of incompetence-conveying\nwords in a typical tweet",
       color = "Number of COVID-19\nnews articles that also\nmentioned Asia or\nAsian people") +
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

############################## As a function of news articles mentioning China ##############################
summary(lm(Cold ~ chinese + day, data = df_grouped_tp %>% filter(day > 0)))
summary(lm(Warm ~ chinese + day, data = df_grouped_tp %>% filter(day > 0))) 
summary(lm(Competent ~ chinese + day, data = df_grouped_tp %>% filter(day > 0)))

model = lm(Incompetent ~ chinese + day, data = df_grouped_tp %>% filter(day > 0))
summary(model) # day significant and negative
confint(model)

png("Figure11c.png", units="in", width=14, height=10, res=800)
df_grouped_tp %>% 
  filter(day > 0) %>%
  ggplot(aes(x = day, y = Incompetent, 
             ymin = Incompetent-Incompetent_se, ymax = Incompetent+Incompetent_se, 
             color = chinese)) +
  geom_point(size=2) + 
  geom_smooth(method = "lm", color="#8E1916") +
  scale_colour_gradient(low = "#EAAC8B", high = "#65010C") +
  coord_cartesian(ylim = c(0, 0.008)) +
  scale_y_continuous(breaks = seq(0, 0.008, by = 0.001)) +
  labs(x = "Days into the post-outbreak period", 
       y = "Proportion of incompetence-conveying\nwords in a typical tweet",
       color = "Number of COVID-19\nnews articles that also\nmentioned China or\nChinese people") +
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