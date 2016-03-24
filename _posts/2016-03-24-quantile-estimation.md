---
layout: post
title: Quantile Estimation
excerpt: Another argument for selecting a quantile estimation type in R
language: german
category: discussion
---



There are many different ways to estimate the quantiles of an empirical distribution. R knows 9 different types (see help page of ```quantile()```). It is clear that for high $$n$$ the differences in these approaches become negligible. It is only the low $$n$$, where they deviate. There is a lof of mathematical argumentation and justification out there for each of these methods, but apparently non of them is convincing enough, that the whole statistical community would stick to that method. Every statistic software has different defaults and some have no alternative methods to choose from like R.

Not accepting this state of unclarity I wanted to find an answer that I can understand and comprehend to the question "which quantile estimation is best".
My first Idea was to find a way to visualize the differences between these 9 types. So I thougt about, how I could create input data for the ```quantile()``` function, that is discrete, but random. What I wanted was a descrete distribution of values, that stick to a certain distribution function - say a normal distribution for the beginning. The limited $$n$$ should somehow represent the theoretical distribution in the best possible way.

What I came up with is a distribution of $$n$$ values which each are representative for an equal quantile range of the theoretical distribution like visualized by the checkerboard of gray rectangles in the following figure. From the equally distributed quantiles one can calculate the quantile values for the standard distribution like visualized by the dotted lines. While the horizontal lines are equidistant distributed, the distribution of the vertical lines follows the distribution function.


![plot of chunk theoretical-and-discrete-distribution-for-different-n](/figure/source/2016-03-24-quantile-estimation/theoretical-and-discrete-distribution-for-different-n-1.svg)

With these discrete distributions with different $$n$$ I could calculate the following graph. It shows on the y-axis the results of the execution of the ```quantile()``` function with different ```type=``` argument. On the x-axis the number ($$n$$) of values on the discrete distribution is varied. The resulting lines should end at the theretical quantiles for high $$n$$ as they apperently do, as can be seen on the secondary axis on the right. What is interesting is the differences that are apparant before $$n\approx100$$.


![plot of chunk distribution-estimation-with-different-methods](/figure/source/2016-03-24-quantile-estimation/distribution-estimation-with-different-methods-1.png)

First the very obvious, which is clear already without any calculation or plotting: For a distribution consisting only of a single value no real "distribution" can be calculated. For the case $$n=1$$ all quantiles are $$0$$. For $$n=2$$ the inner $$50\%$$ of the quantiles can already be calculated quite accurate by some methods. The spread of the outer quantiles is underestimated by all methods and becomes calculable only with higher $$n$$. The extreme low and upmost quantiles are apparently hardest to estimate from a limited $$n$$ or may even be mathematical impossible to estimate. 

In the region under $$n\approx100$$ the different types show different deviations from the theoretical quantiles. There are the methods of type 1 to 3 that are made for easy calculation in pre-computer days which jump up and down with every change in $$n$$. Type 4 underestimates all quantiles in the lower $$n$$ resulting in a rising of all estimated quantiles with rising $$n$$. Type 7 which is the R default underestimates the spread of all quantiles in the lower $$n$$. Then there are the methods 5, 6, 8 and 9 which for very low $$n$$ come to a good estimation of the inner quantiles. But they all overshoot and overestimate the spread of the outer quantiles, especially type 6. This overshoot shifts to the more outer quantiles with rising $$n$$, while simultanious the overestimation settles again for the inner quantiles.

Type 5 seems to have the best performance of all methods, since it comes to a fairly good estimation of the inner $$50\%$$ of quantiles when $$n=2$$ and for the inner $$75\%$$ when $$n=4$$. Both estimations don't change much if $$n$$ is further increased like is the case for types 8, 9 and especially 6.

### A valid approach for evaluating the performance of the different quantile estimations?

But having this informative graphic the question remains, whether the choosed discrete distribution is in any way capable of representing a theretical distribution function and therefore beeing able to evalueate the performance of the different quantile calculation types?
To justify my approach I couldn't come up with some fancy math, so I threw in bare processing power and calculated the quantiles of repeated generation of random numbers. The function ```rnorm()``` in R for example gives random numbers that stick to the probabilities of a normal function. To estimate the quantiles from a limited $$n$$ of these random numbers should lead to random deviation from the theoretical quantiles, but the mean of a high repetition of this process should equal out the statisical errors and hence result in the theoretical quantiles. Unless there is an inherent systematical error in the approach used to estimate the quantiles.

So I created the next figure starting with a single estimation with 10 random numbers, repeating the process up to a 1000 times and calculating the cumulative mean of the repeated estimation with ever new random numbers. Since the quantiles of most types apparently don't change much after 100 repetitions I concluded that the mean of 1000 repetitions should definitely show where this approach would end with an infinite repetition of the process. And: apparently the error is not statistical, but systematic, because for most methods the cumulative means don't end up at the theoretical quantiles (secondary axis on the right) drawn in gray.

![plot of chunk using-random-generator](/figure/source/2016-03-24-quantile-estimation/using-random-generator-1.png)

The systematic of the deviation can be seen in the next figure in red circles. And: Bingo!, they match the deviations from my first thoght experiment with the discrete theoretical distributions (black circles) quite well. This approves, that this approach was a reasonable way to investigate the systematics behind the different quantile estimation methods.

Every approach shows different deviations. Type 4 shows the already discussed overall underestimation of the quantiles, but also shows that the outer quantiles show even greater deviation than the inner. Type 7 shows overestimation of the lower quantiles and underestimation of the higher quantiles, resulting in a underestimation of the spread of the distribution. The other way around it is with type 5, 6, 8 and 9. At $$n=10$$ they overestimate the spread especially of the outermost quantiles. This effect is strongest for type 6 and the weakest for type 5 which again seems to be the most reliable way to estimate the quantiles. Type 1 to 3 show jumping deviations. Here the deviations (with our first graph in mind) should be entirely different for $$n=11$$. For all methods the deviations should disappear with high $$n$$, but some methods, show already quite accurate estimation of the inner quantiles. Type 8 and 9 show high deviations only for the $$0.125$$ and $$0.875$$ quantiles and type 5 seems to be accurate even for these quantiles.

![plot of chunk comparison-between-discrete-and-random-repetition](/figure/source/2016-03-24-quantile-estimation/comparison-between-discrete-and-random-repetition-1.png)

As further tests show (next graphics), the deviations of the random repetition test with other $$n$$ again match the deviation that our first graphic (with the discrete theretical distribution) shows. For $$n=20$$ the deviations for the $$0.125$$ and $$0.875$$ quantiles for types 8 and 9 disappear as could be estimated from the curve of the discrete theoretical distributions. For $$n=100$$ all types get to quite good estimations, the systematic errors seem to become unsignificant. This is also apparent, since the running mean of the repeated calculations doesn't change much after only $$10$$ repetitions.

For $$n=20$$ the deviations of type 2 are quite low. But this is just, because the zig-zag, apparent in the discrete distribution plot, coincidal is right at the theoretical quantile. $$n=21$$ shows again much higher deviation, so the rise of $$n$$ not necessarily results in a better estimation for the types 1 to 3. This makes them kind of unreliable: If only one additional value is taken into the calculation the quantile estimation could be significantly different just caused by the calculation method.

For other distributions there are similar deviations of the different estimation methods as they are for the normal distribution.







![plot of chunk systematic-deviation-from-theoretical-quantiles-with-variating-n](/figure/source/2016-03-24-quantile-estimation/systematic-deviation-from-theoretical-quantiles-with-variating-n-1.png)


![plot of chunk using-random-generator-with-n-100](/figure/source/2016-03-24-quantile-estimation/using-random-generator-with-n-100-1.png)

![plot of chunk comparison-between-discrete-and-random-repetition-with-n-100](/figure/source/2016-03-24-quantile-estimation/comparison-between-discrete-and-random-repetition-with-n-100-1.png)

![plot of chunk distribution-estimation-with-different-methods-lognormal](/figure/source/2016-03-24-quantile-estimation/distribution-estimation-with-different-methods-lognormal-1.png)

![plot of chunk comparison-between-discrete-and-random-repetition-lognormal-with-n-10](/figure/source/2016-03-24-quantile-estimation/comparison-between-discrete-and-random-repetition-lognormal-with-n-10-1.png)
