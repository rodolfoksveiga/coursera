# setup environment ####
setwd('~/git/courses/exploratory_data_analysis/')
library(dplyr)
library(ggplot2)
library(RColorBrewer)

# load data ####
nei = readRDS('summarySCC_PM25.rds')
scc = readRDS('Source_Classification_Code.rds')

# plot 1 ####
t1 = tapply(nei$Emissions, as.factor(nei$year), sum)/1000
lm1 = lm(t1 ~ as.numeric(names(t1)))
pos1 = as.numeric(names(t1)) + rep(c(0.5, -0.5), times = 2)
png('plot21.png')
plot(x = names(t1), y = t1, pch = 19, main = 'Total Emissions in US',
     xlab = 'Year', ylab = expression('PM'[2.5]*' (kilotons)'), xaxt = 'n')
abline(lm1, lwd = 2, col = 'darkblue')
axis(side = 1, as.numeric(names(t1)))
legend('topright', legend = 'Linear Regression', lty = 1, col = 'blue')
text(x = pos1, y = t1, labels = as.character(round(t1)))
dev.off()

# plot 2 ####
balt = filter(nei, fips == '24510')
t2 = tapply(balt$Emissions, as.factor(balt$year), sum)/1000
lm2 = lm(t2 ~ as.numeric(names(t2)))
pos2 = as.numeric(names(t1)) + rep(c(0.2, -0.2), each = 2)
png('plot22.png')
plot(x = names(t2), y = t2, pch = 19, main = 'Total Emissions in Baltimore',
     xlab = 'Year', ylab = expression('PM'[2.5]*' (kilotons)'), xaxt = 'n')
abline(lm2, lwd = 2, col = 'darkblue')
axis(side = 1, as.numeric(names(t2)))
legend('topright', legend = 'Linear Regression', lty = 1, col = 'blue')
text(x = pos2, y = t2, labels = as.character(round(t2)))
dev.off()

# plot 3 ####
df3 = balt %>%
  group_by(year, type) %>%
  summarize(emis_sum = sum(Emissions)/1000)
colours = brewer.pal(4, 'Dark2')
png('plot23.png')
ggplot(df3, aes(x = year, y = emis_sum, fill = type)) +
  geom_bar(stat = 'identity', position = 'dodge', colour = 'black') +
  labs(title = 'Total Emissions in Baltimore (per type)',
       x = 'Year', y = expression('PM'[2.5]*' (kilotons)')) +
  geom_hline(yintercept = filter(df3, year == 1999)$emis_sum,
             alpha = 0.75, colour = colours) +
  scale_fill_manual(name = 'Legend', values = colours) +
  scale_x_continuous(breaks = unique(df3$year)) +
  theme(plot.title = element_text(size = 15, hjust = 0.5, face = 'bold'),
        legend.title = element_text(size = 13, hjust = 0.5, face = 'bold'),
        legend.text = element_text(size = 11),
        axis.title.y = element_text(size=14),
        axis.title.x = element_text(size=14),
        axis.text.x = element_text(size = 13),
        axis.text.y = element_text(size = 13))
dev.off()

# plot 4 ####
coal = nei %>%
  left_join(scc, by = 'SCC') %>%
  filter(grepl('Fuel Comb.*Coal', EI.Sector))
t4 = tapply(coal$Emissions, as.factor(coal$year), sum)/1000
lm4 = lm(t4 ~ as.numeric(names(t4)))
pos4 = as.numeric(names(t4)) + rep(c(0.4, -0.4), each = 2)
png('plot24.png')
plot(x = names(t4), y = t4, pch = 19, main = 'Total Emissions from Coal in US',
     xlab = 'Year', ylab = expression('PM'[2.5]*' (kilotons)'), xaxt = 'n')
abline(lm4, lwd = 2, col = 'darkblue')
axis(side = 1, as.numeric(names(t4)))
legend(1999, 380, legend = 'Linear Regression', lty = 1, col = 'blue')
text(x = pos4, y = t4, labels = as.character(round(t4)))
dev.off()

# plot 5 ####
vhc5 = filter(balt, type == 'ON-ROAD')
t5 = tapply(vhc5$Emissions, as.factor(vhc5$year), sum)
lm5 = lm(t5 ~ as.numeric(names(t5)))
pos5 = as.numeric(names(t5)) + rep(c(0.4, -0.4), each = 2)
png('plot25.png')
plot(x = names(t5), y = t5, pch = 19, main = 'Total Emissions from Vehicles in Baltimore',
     xlab = 'Year', ylab = expression('PM'[2.5]*' (tons)'), xaxt = 'n')
abline(lm5, lwd = 2, col = 'darkblue')
axis(side = 1, as.numeric(names(t5)))
legend('topright', legend = 'Linear Regression', lty = 1, col = 'blue')
text(x = pos5, y = t5, labels = as.character(round(t5)))
dev.off()

# plot 6 ####
df6 = nei %>%
  filter(grepl('24510|06037', fips) & type == 'ON-ROAD') %>%
  mutate(city = ifelse(fips == '24510', 'Baltimore', 'Los Angeles')) %>%
  group_by(city, year) %>%
  summarize(emis_sum = sum(Emissions))
png('plot26.png')
ggplot(df6, aes(x = year, y = emis_sum, fill = city)) +
  geom_bar(stat = 'identity', position = 'dodge', colour = 'black') +
  facet_grid(city ~ ., scales = 'free') +
  labs(title = 'Total Emissions from Vehicles (per city)',
       x = 'Year', y = expression('PM'[2.5]*' (Tons)')) +
  scale_fill_discrete(name = 'Legend') +
  scale_x_continuous(breaks = unique(df6$year)) +
  theme(plot.title = element_text(size = 15, hjust = 0.5, face = 'bold'),
        legend.title = element_text(size = 13, hjust = 0.5, face = 'bold'),
        legend.text = element_text(size = 11),
        axis.title.y = element_text(size=14),
        axis.title.x = element_text(size=14),
        axis.text.x = element_text(size = 13),
        axis.text.y = element_text(size = 13),
        strip.text = element_text(size = 13, face = 'bold'))
dev.off()

