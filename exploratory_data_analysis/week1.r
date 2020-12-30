# notes ####
# principals of analytic graphics
    # 1. show comparisons
        # always ask "compared to what"?
    # 2. show causality, mechanism, explanation, systematic structure
        # what is your causal framework for thinking about a question?
    # 3. show multivariate data
        # more than two variables should prove the hypothesis
    # 4. integration of evidence
    # 5. describe and document the evidence with appropriate labels, sources, etc.
        # a data graphic should tell a complete story that is credible
    # 6. content is king
        # analytical presentations ultimately stand or fall on the quality, relevance and
            # integrity of their content

# why do we use data analysis
    # to understand data properties
    # to find patterns in data
    # to suggest modeling strategies
    # to "debug" analysis
    # to communicate results

# characteristics of exploratory graphs
    # they are made quickly!
    # a large number are made!
    # the goal is personal understanding!
    # you don't care about axis and legends (they're quick and dirty)
    # colour/size are primarily used for information

# one dimension data
    # five-number summary
    # histogram
    # density plot
    # boxplot
    # barplot

# two dimensions data
    # 1 dimension
        # multiple/overlayed 1d plot (lattice/ggplot2)
        # scatterplot
        # smooth scatterplot
    # 2 dimensions
        # multiple/overlayed 2d plots (lattice/ggplot2/coplots)
        # use colour, size or shape to add dimensions
        # spinning plots

# base system
    # steps to generate the plots
        # 1. define number of plots with par()
        # 2. initializing a new plot, such as plot() or hist()
        # 3. annotating an existing plot with text, lines, axis, legend
    # with the base package, you can't go back after have started a plot

# lattice system
    # plots are created using one single function
    # return object of class 'trellis'
    # very useful for conditioning plots, e.g. looking at how y changes with x accross z levels
    # margins/spacing is set automatically
    # very good for plotting many graphs together
    # annotations are not intuitive
    # main plot functions
        # xyplot(): scatterplot
        # bwplot(): box-and-whiskers plots ("boxplots")
        # histogram()
        # stripplot: boxplots with points
        # dotplot: dots on "violins"
        # splom: scatterplot matrix

# ggplot system
    # splits the difference between base and lattice in a number of ways
    # automatically deals with spacing, text and titles, but also allows you to annotate
        # by adding information to the plot
    # superficial similarities to lattice but more intuitive to use

# some plot functions you must know
    # plot(x, y), hist(x) and boxplot(x, y) are basic initializing functions
    # plot() make a scatter plot or a different plot (depends on object's class)
        # smoothScatter() is very useful when the there too many points
    # arguments:
        # pch: symbol
        # lty: line type
        # lwd: line width
        # col: colour (colors() returns a vector with colour names)
        # xlab: x-axis label
        # ylab: y-axis label
        # type = 'n': just set up the plot without actually plotting (avoid overplotting)
    
    # lines() add lines to a plot
    # points() add points to a plot
    # text() add text labels within a using x and y coordinates
    # title() add annotations outside a plot x and y axis labels, title, subtitle...
    # mtext() add arbitrary text to the margins (inner or outer)
    # axis() add axis ticks/labels
    # legend() add legend
    # abline() add a line with the type y = a.x + b
        # a linear model fits to the first parameter
    # par() set global parameters for all base plots in an R session
    # arguments:
        # las: orientation of axis labels
        # bg: background colour
        # mar: margin size
        # oma: outer margin size
        # mfrow: number of plots per row, column (filled row-wise)
        # mfcol: number of plots per row, column (filled column-wise)
        # default values of the parameters can be found setting the name of the argument as a
            # string inside par(), like this: par('lty'), par('col'), par('pch'), etc.

    # plot devices
        # png(): good for line drawings, many points and solid colours images
        # jpeg(): good for photographs and natural scenes
        # pdf(): good for line-type plots/bad for plots with many objects/points
        # svg(): good for animate and interactive plots (web-based plots)
        # dev.cur() shows the current graphics device
        # dev.set() changes the active device
        # dev.copy() copy the actual printed plot to a device
        # dev.off() closes the decive

# plotting and colour (RColorBrewer package)
    # the main function is brewer.pal(n, name)
        # n is the number of colours
        # name is the pallet
    # there 3 types of pallets
        # sequential
          # data that are ordered from low to high (numerical data)
        # diverging
            # data that deviate from an specific point (errors, standard deviation)
        # qualitative
            # data that are not ordered (factors or categorical data)
    # brewer.pal.info shows all the pallets available
    # colorRamp and colorRampPallete packages may be useful as well

# example()
    # the function example() using the argument as the propertie can show different options,
    # e.g. example(points), example(size), example(colours)
    # example()


# course directory ####
course_directory = '~/git/coursera/exploratory_data_analysis/'


# 13th class ####
# setup environment
setwd(course_directory)
# the graphs of this class can't be plotted because the data wasn't provided

# summary()
summary(pollution$pm25)

# boxplot()
boxplot(pollution$pm25, col = 'blue')
# creates a linear line (y = a.x + b), in this case an horizontal line on y = 12
abline(h = 12)

# histogram()
# the breaks argument describe the number of bins
histogram(pollution$pm25, col = 'green', breaks = 100)
# the rug plots all the points in the dataset along the x-axis
# it provides more information that may be hidden by the bins
rug(pollution$pm5)
# creates a vertical line 12 and a vertical line on the median
# lwd argument control the thickness of the line
abline(v = 12, lwd = 2)
abline(v = median(pollution$pm25, col = 'magenta', lwd = 4))

# barplot()
# table() was used to count the number of cases for each factor of the variable region
barplot(table(pollution$region), col = 'wheat', main = 'Number of Counties in Each Region')


# 14th calss ####
# setup environment
setwd(course_directory)
# the graphs of this class can't be plotted because the data wasn't provided

# boxplot()
boxplot(pm25 ~ region, data = pollution, col = 'red')

# multiple histograms using par()
# par has to be setup back to usual after using
par(mfrow = c(2, 1), mar = c(4, 4, 2, 1))
# first: plot on the top
hist(subset(pollution, region == 'east')$pm25, col = 'green')
# second: plot on the bottom
hist(subset(pollution, region == 'west')$pm25, col = 'blue')

# scatterplot()
# lty refers to the line type
with(pollution, plot(latitude, pm25, col = region))
abline(h = 12, lwd = 2, lty = 2)
# you can use par to separate the scatterplots, if the data is too huge and points are mixing
par(mfrow = c(1, 2), mar = c(5, 4, 2, 1))
with(subset(pollution, region == 'east'), plot(latitude, pm25, main = 'East'))
with(subset(pollution, region == 'west'), plot(latitude, pm25, main = 'West'))


# 15th class ####
# setup environment
library(datasets)
library(ggplot2)
library(lattice)
setwd(course_directory)
data(cars)
data(mpg)

# simple plot examples with base, lattice and ggplot systems
# base system
with(cars, plot(speed, dist))
# lattice system
state = data.frame(state.x77, region = state.region)
xyplot(Life.Exp ~ Income | region, data = state, layout = c(4, 1))
# ggplot system
qplot(displ, hwy, data = mpg)


# 16th class ####
# setup environment
library(datasets)
setwd(course_directory)

# simple base graphics
hist(airquality$Ozone)
with(airquality, plot(Wind, Ozone))
airquality = transform(airquality, Month = factor(Month))
boxplot(Ozone ~ Month, airquality, xlab = 'Month', ylab = 'Ozone (ppb')


# 17th class ####
# setup environment
library(datasets)
setwd(course_directory)

# base plots with annotations
# add title to base plot
with(airquality, plot(Wind, Ozone))
title(main = 'Ozone and Wind in New York City')
# you can also add the title as an argument of plot()
with(airquality, plot(Wind, Ozone, main = 'Ozone and Wind in New York City'))
# here you add a plot over the other
with(airquality, plot(Wind, Ozone, main = 'Ozone and Wind in New York City'))
with(subset(airquality, Month == 5), points(Wind, Ozone, col = 'blue'))
# you can use the argument type = 'n' to not plot the observation the observations
    # are saved in background and more information is added before plotting
with(airquality, plot(Wind, Ozone, main = 'Ozone and Wind in New York City', type = 'n'))
with(subset(airquality, Month == 5), points(Wind, Ozone, col = 'blue'))
with(subset(airquality, Month != 5), points(Wind, Ozone, col = 'red'))
legend('topright', pch = 1, col = c('blue', 'red'), legend = c('May', 'Other Months'))
# plot regression lines
with(airquality, plot(Wind, Ozone, main = 'Ozone and Wind in New York City', pch = 20))
model = lm(Ozone ~ Wind, airquality)
abline(model, lwd = 2)
# multiple plots can show different relations between variables
par(mfrow = c(1, 2))
with(airquality,{
    plot(Wind, Ozone, main = 'Ozone and Wind')
    plot(Solar.R, Ozone, main = 'Ozone and Solar Radiation')
})
par(mfrow = c(1, 3), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))
with(airquality, {
    plot(Wind, Ozone, main = 'Ozone and Wind')
    plot(Solar.R, Ozone, main = 'Ozone and Solar Radiation')
    plot(Temp, Ozone, main = 'Ozone and Temperature')
    mtext('Ozone and Weather in New York City', outer = TRUE)
})
