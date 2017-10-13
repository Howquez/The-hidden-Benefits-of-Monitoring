## Purpose

As I aim to do transparent and reprocible research, I try to meet the requirements propsed by Simmons et al. (2011). On top of that, I want to obviate any suspicions concerning HARKing — hypothesizing after the results are known. This is why I report information about the data collection and it's termination rule, the hypotheses and previously conducted experiments in this document.


### Data Collection

The data will be collected in several laboratory sessions at the [Centre for Experimental Economics](http://www.econ.ku.dk/cee/) in Copenhagen. We will run the first session on **DD** November 2017. Before running the sessions, we agree on the following rule to terminate the data collection: **post rule here**.


### Hypotheses

The [simulated data](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/tree/master/Simulated_Data) is generated such that it supports our hypothesis -- it includes some noise though. As a consequence, some of the [figures](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/Figures/01_Regression.pdf) I posted visualize our hypothesis nicely. Having these illustrations in mind helps to understand what we test.

First, consider the following OLS specification:

`performance = a + b productivity + c IT + d (productivity x IT) + e` 

Where *'performance'* is an agent's effort provision in Stage 2, *'productivity'* her effort provision in Stage 1 and *'IT'* a dummy variable describing the matched principal's monitoring decision.

*Hypothesis I*: Given a high IT (`IT==1`) the relation between performance and productivity is stronger (steeper) than predicted by an egoistic model of effort provision while it is weaker (flatter) for low IT decisions (`IT==0`). Given the OLS specification from above this translates into: `b < 0.25  &  b + d > 0.75`.


### Previous Experiments

Prior to running the experiment outlined in this repository, my supervisors ran a very similar experiment consisting of the same first stage and a similar second stage which is depicted on the second page of the [game tree .pdf](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/Figures/20170920_GameTree.pdf). They ran the experiment with the same expectations as I outlined above. The data, which I have not seen at this point, did not reject their null hypothesis. As a consequence, we changed a few elements of the game. First, the principal's decision became binary -- she can either choose a high or a low IT in out design. Second, the game added a decision knot for the agent -- she can now choose her workload prior to exerting effort. Finally, the principal is informed about the agent's productivity in Stage 1.


### Notes

1. Remember that you can find the codebook, which lists all the generated variables [here](https://github.com/Howquez/The-hidden-Benefits-of-Monitoring/blob/master/Codebook.pdf).
2. The codebook does not contain any summary statistics, nor does is provide detailed information about the structure of the data set. I'll try to upload the output of the `str()` function.

- - - -
Simmons, J. P., Nelson, L. D. and Simonsohn, U. (2011). False-positive psychology: Undisclosed flexibility in data collection and analysis allows presenting anything as significant, Psychological science 22(11): 1359–1366.
