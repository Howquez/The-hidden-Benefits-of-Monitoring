## Purpose

As I aim to do transparent and reprocible research, I try to meet the requirements propsed by Simmons et al. (2011). On top of that, I want to obviate any suspicions concerning HARKing — hypothesizing after the results are known. This is why I report information about the data collection and it's termination rule, the hypotheses and previously conducted experiments in this document.


### Data Collection

The data will be collected in several laboratory sessions at the [Centre for Experimental Economics](http://www.econ.ku.dk/cee/) in Copenhagen. We will run the first session on November 27, 2017. We ordered cash for 200 participants (or 100 independent observations) and intend to run about eight sessions in calendar week 47.


### Hypotheses

Before running the first Session, I will upload a [PDF document]() which describes behavioral predictions as well as the corresponding  empirical strategy. Both sections derive the hypotheses in detail. Interested readers, for whom the folowing section might lack precision, are invited to read and comment the posted document.

As I am investigating reciprocity, I hypothesize that the effect of monitoring on an agent's working cannot be explained pure self-interest. Instead, I want to test whether monitoring decisions are preceived as kind or undkind and whether this (un)kindness is passed back to the principal. Importantly, an agent's perception of kindness depends on her productivity. Putting these pieces together I hypothesize that:

`Unproductive agents perceive a low (high) monitoring intensity as kind (unkind) and pass this (un)kindess back by exerting a relatively high (low) level of effort. The exact opposite holds true for productive agents (i.e. they perceive a high intensity as kind and react according.`

Because the agent has another action to choose her effort provision (an agent can choose her workload) I also consider the *screenChoice* variable. Doing so, I expect a pattern such as described in this [figure](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/Figures/03_Histogram.pdf): 

`Agents who face  a low monitoring intensity chosen by the principal, and are unprodcutive, are less prone to choose a non-maximal workload than those who face the same monitoring intensity but are productive. The opposite is expected to hold true for agents facing a high monitoring intensity (a high IT chosen by the principal): unproductive agents choose a lower workload than productive agents.`


### Previous Experiments

Prior to running the experiment outlined in this repository, my supervisors ran a very similar experiment consisting of the same first stage and a similar second stage which is depicted on the second page of the [game tree .pdf](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/Figures/20170920_GameTree.pdf). They ran the experiment with the same expectations as I outlined above. The data, which I have not seen at this point, did not reject their null hypothesis. As a consequence, we changed a few elements of the game. First, the principal's decision became binary -- she can either choose a high or a low IT in out design. Second, the game added a decision knot for the agent -- she can now choose her workload prior to exerting effort. Finally, the principal is informed about the agent's productivity in Stage 1.

### Sessions 

To make sure that our sample is heterogeneous with respect to the productivity, we manipulate the difficulty of the real-effort task exogenously. Remember that the bo-clicking task consists of a series of 25 screens where each of them contains 35 randomly ordered boxes which the subjects should click away. The more boxes they click away, the more productive they are. However, each of these screens has a timer running down from 11 seconds for instance. After these 11 seconds, the screen disappears and the subsequent screen comes up. Given this, we can manipulate the difficulty of the task by manipulating the average time a screen was displayed *between* sessions. Note that we did neither change the amount of boxes per screen nor the number of screens. The following table prints the average timings of the screens for each session.

Session | Day     | Average Timing
--------|---------|---------------
1       | 27.11.17| 7 seconds
2       | 28.11.17| 11 seconds
3       | 28.11.17| 11 seconds
4       | 29.11.17| 7 seconds
5       | 29.11.17| 7 seconds
6       | 30.11.17| 11 seconds
7       | 30.11.17| 7 seconds
8       | 01.12.17| 11 seconds



### Notes

1. Remember that you can find the codebook, which lists all the generated variables [here](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/Codebook.pdf).
2. The codebook does not contain any summary statistics, nor does is provide detailed information about the structure of the data set. I'll try to upload the output of the `str()` function.

- - - -
Simmons, J. P., Nelson, L. D. and Simonsohn, U. (2011). False-positive psychology: Undisclosed flexibility in data collection and analysis allows presenting anything as significant, Psychological science 22(11): 1359–1366.
