
EXP: number of experiment (as mentioned in the manuscript Nasioulas_2024)
TYPE_FEEDBACK: 0: partial, 1: complete
BLOCK_INSTRUCTIONS: whether instructions at the beginning of each block informing about the availability of feedback in the upcoming block were present (1) or not (0)
SURETHING: whether there was a sure-thing lottery (1) or a safe low-variance 50/50 option (0)
EXPID: random unique identifier for each participant/submission
RISKYBETTER: which option (risky or sure/safe) has a higher EV | 1: risky, 0: safe, -1:equal
FEEDBACK: 1: present, 0: absent
VALENCE: 1: gain domain, 0: loss domain
MAG1: magnitude of the non-zero outcome of the risky option
P1: probability of the non-zero outcome of the risky option
EV1: Expected Value of the risky option
MAG2, P2, EV2: same values for the sure/safe option. In the case of a safe 50/50 option (Exp5-6), MAG2 is the smallest of the two possible outcomes
OPTIMAL_CHOICE: defined with respect to EV-maximization
OUT: outcome of the chosen option
CF_OUT: outcome of the unchosen option (not available in Exp7, but also not relevant as partial feedback was used)
INV: whether risky option was on the left and sure/safe on the right part of the screen (0) or the opposite (1)
RTIME: reaction time in ms
