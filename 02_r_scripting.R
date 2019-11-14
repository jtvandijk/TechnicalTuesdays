# examples from: https://r4ds.had.co.nz/

# libraries
library(tidyverse)

#data set -- dplyr showcase
df <- as.data.frame(mpg)
tb <- mpg
pp <- mpg

# variables used from mpg 'car dataset'
# 1. displ  --  engine size
# 2. hwy    --  efficiency 
# 3. class  --  type of car

# base R: filter, select, mutate
df <- df[df$class == 'compact',]
df <- df[,c('model', 'displ' ,'hwy')]
df$ratio <- df[,'hwy'] / df[,'displ']

# dplyr: filer, select, mutate
tb <- filter(tb,class == 'compact')
tb <- select(tb, model, displ, hwy)
tb <- mutate(tb, ratio = displ / hwy)

# dplyr: filer, select, mutate (using pipe)
pp <- pp %>% 
  filter(class == 'compact') %>% 
  select(model, displ, hwy) %>% 
  mutate(ratio = displ / hwy)

# data set -- ggplot showcase
df <- mpg

# ggplot structure
# data {raw data} +
# layers {shapes and summarised data} +
# aesthetics {making of the objects} +
# scales +
# coordinate system +
# facets +
# visual theme

# geom_point
ggplot(data = df) 

ggplot(data = df) +
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = df) +
  geom_point(mapping = aes(x = displ, y = hwy), colour = 'red')

ggplot(data = df) +
  geom_point(mapping = aes(x = displ, y = hwy, colour = class))

ggplot(data = df) +
  geom_point(mapping = aes(x = displ, y = hwy, colour = class)) +
  facet_wrap(~ class, nrow=2)

# geom_line
ggplot(data = df) +
  geom_line(mapping = aes(x = displ, y = hwy))

ggplot(data = df) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

# geom_boxplot
ggplot(data = df) +
  geom_boxplot(mapping = aes(x = class, y = hwy)) 

ggplot(data = df) +
  geom_boxplot(mapping = aes(x = class, y = hwy)) + 
  coord_flip()

# layering
ggplot(data = df) +
  geom_smooth(mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(x = displ, y = hwy, colour = class))

# theme
ggplot(data = df) +
  geom_smooth(mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(x = displ, y = hwy, colour = class)) +
  theme_minimal()

# full figure
ggplot(data = df) +
  geom_smooth(mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(x = displ, y = hwy, colour = class)) +
  ggtitle('Engine size versus efficiency') +
  xlab('Engine size') +
  ylab('Efficiency') +
  labs(colour = 'Car Type') +
  theme_minimal() +
  theme(
    axis.line = element_line(size = 0.5),
    axis.ticks = element_line(size = 0.5)
  )