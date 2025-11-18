
=== Nasioulas2024_data.csv ===

EXP: number of experiment, as mentioned in the manuscript Nasioulas_2024 [values: 1-7]
TYPE_FEEDBACK: 0: partial, 1: complete
BLOCK_INSTRUCTIONS: whether instructions at the beginning of each block informing about the availability of feedback in the upcoming block were present (1) or not (0)
SURETHING: whether there was a sure-thing lottery (1) or a safe low-variance 50/50 option (0)
EXPID: random unique identifier for each participant/submission

BLOCK: number of block [values: 1-24 (Exp 1-6), 1-36 (Exp7)]
TRIAL: number of trial [values: 1-10]
RISKYBETTER: which option (risky or sure/safe) has a higher EV | 1: risky, 0: safe, -1:equal
FEEDBACK: 1: present, 0: absent
VALENCE: 1: gain domain, 0: loss domain

MAG_RISKY: magnitude of the non-zero outcome of the risky option
P_RISKY: probability of the high outcome of the risky option [values: {.1, .5, .9} (Exp 1-6), {.2, .5, .8} (Exp 7)]
MAG_SURE1: high outcome of the sure/safe option
MAG_SURE2: low outcome of the sure/safe option
P_SURE: probability of the high outcome [values: 1 (Exp 1-4 & 7), .5 (Exp 5-6)]

RISKY_CHOICE: chose risky option (1) or sure/safe option (0)
OPTIMAL_CHOICE: chose the Expected Value-maximizing option (1) or not (0) [NaN values for EXP=7]
REPEAT_RISKY: chose the risky option (1) or the sure/safe option (0), conditional on having chosen the risky option in the previous trial [values include NaN when not applicable, i.e., when sure/safe was chosen on the previous trial and for TRIAL=1]

OUT: outcome of the chosen option
CF_OUT: outcome of the unchosen option (not available in Exp7, where partial feedback was used)
INV: whether the risky option was on the left and sure/safe on the right part of the screen (0) or the opposite (1)
RTIME: reaction time in ms

PREVIOUS_RISKY_CHOICE: whether in the previous trial they chose the risky option (1) or the sure/safe (0) [NaN value for TRIAL=1]
PREVIOUS_RISKY_OUT_MAX: whether in the previous trial the realized outcome of the risky option was maximum (1) or minimum (0), among its possible outcomes [NaN value for TRIAL=1 and for Exp7, where CF_OUT was not available]
PREVIOUS_OUT_POS: whether in the previous trial the realized outcome of the chosen option was positive (1) or zero (0) [NaN value for TRIAL=1]



=== Erev2017_data.csv ===
# Same as above. Some clarifications:

EXP: 8
BLOCK: as defined in the original paper, consisting of the first 5 trials with no-Feedback and then 20 trials of Feedback, for a total of 25 trials per block. Hence, it is different from our design.

MAG_RISKY1: high outcome of the risky option
MAG_RISKY2: low outcome of the risky option
P_RISKY_CAT: P_RISKY<=.25: 0; 0.25<P_RISKY<0.75: 1, P_RISKY>=.75: 2

CONDITION: "byProb" or "byFeed", see Supplementary Note 3 for their definition 