// Metadata
#let author_name = "Zahra Khodabakhshian"
#let author_email = "jov98mam@rptu.de"
#let mtrk_nr = "426198"
#let supervisor_name = "Saurabh Varshneya"
#let prof_name = "Prof. Dr. Marius Kloft"
#let current_date = "November 2nd, 2025"
#let thesis_title = "Robust Reinforcement Learning against Spurious Correlations"

// Set document properties
#set document(title: thesis_title, author: author_name)
#set page(
  paper: "a4",
  margin: (left: 3cm, right: 3cm, top: 2.5cm, bottom: 2.5cm),
)
#set text(lang: "en", size: 11pt)
#set block(spacing: 1.0em)
#set par(justify: true)
#set heading(numbering: "1.")

// Title page header
#align(center)[
  #text(10pt)[
    #smallcaps("Master Thesis Proposal")\
    Prüfer: #prof_name\
    Supervisor: #supervisor_name
  ]
  #v(1.2cm)
  #line(length: 100%)
  #text(18pt, weight: "bold")[#upper(thesis_title)]
  #line(length: 100%, stroke: 1.5pt)
  #v(0.4cm)
  #current_date
  #v(0.8cm)
  #author_name\
  Mtrk.nr.: #mtrk_nr\
  Rheinland-Pfälzische Technische Universität Kaiserslautern-Landau (RPTU)\
  #link("mailto:" + author_email)\
]

#v(0.8cm)

= Motivation

Reinforcement learning (RL) agents can perform very well in the environment in which they are trained, but this performance does not always transfer to slightly different settings. One common reason is that the agent may learn a shortcut from the training data. In other words, it may rely on a feature that is correlated with success during training, although this feature is not actually needed for solving the task.

This problem is the main motivation for my thesis. In a robotic manipulation task, for example, the color of an object can be correlated with its position. The robot may then learn to use color as a cue, even though color is not what makes the lifting task succeed. If this relationship changes later, the learned policy may fail. The aim of this work is to study this kind of failure in a controlled RL setting and to investigate whether training with generated counterfactual transitions can make the policy less dependent on such misleading correlations.

= Research Direction

The project is inspired by recent work on robust reinforcement learning against spurious correlations, especially the RSC-MDP framework from _Seeing is not Believing_ @Ding2023Seeing. The paper studies cases where spurious correlations are caused by hidden confounders and proposes to generate additional transitions that break or weaken these correlations.

For this thesis, I plan to work with the Robosuite Lift task. The environment can be modified so that cube position and cube color are correlated during training. Afterwards, the trained policy can be evaluated in settings where this relationship is changed, for example where color and position become independent or swapped. This gives a simple but useful test case: if the policy learned the actual manipulation behavior, it should still work under these shifts; if it learned the shortcut, performance should drop.

= Proposed Method

The baseline method will be Soft Actor-Critic (SAC), implemented in a CleanRL-style training pipeline. The first step will be to train SAC in the confounded Lift environment and evaluate how much it depends on the color-position correlation. This baseline is important because it shows whether the spurious feature is actually being used by the agent.

As a robustness direction, I will investigate an RSC-inspired method. The main idea is to train a transition model from real replay data. This model learns to predict the next state and reward from the current state and action. After that, the current state can be perturbed, and the transition model can be used to generate a synthetic next state and reward for this perturbed state. These generated transitions are then mixed with real replay transitions during SAC training.

In simplified form, the transition model first learns from real transitions,

$
  (s_t, a_t) -> (s_(t+1), r_t),
$

and is then queried on perturbed states,

$
  (tilde(s)_t, a_t) -> (hat(s)_(t+1), hat(r)_t).
$

The exact perturbation strategy is still part of the research. The initial version will use a general Eq. 7-style perturbation, where a state dimension is selected randomly from the observation vector. Since the designed spurious feature is related to object color, I may also compare this with a more targeted version where the RGB dimensions are perturbed together as one group. I do not want to fix this choice too early, because it is not yet clear whether general perturbations are sufficient or whether the method needs to intervene more directly on the known spurious feature.

The final method will therefore be chosen based on empirical behavior: training stability, success in the original environment, and robustness when the color-position relationship changes.

= Research Questions

1. Does a SAC agent trained in the confounded Lift environment rely on the spurious color-position correlation?

2. Can RSC-style counterfactual transition generation improve robustness under shifted test environments?

3. How important is the perturbation strategy, for example random perturbation compared with color-focused perturbation?

= Expected Outcome

The expected outcome is an empirical study of robust RL under a controlled spurious correlation. I expect to compare standard SAC with an RSC-inspired variant that uses generated transitions. The main evaluation will measure success rates in the original confounded environment and in shifted environments where the spurious relationship changes.

The contribution of the thesis will be a clear experimental analysis rather than a claim that one method solves the full problem. If the robust method improves performance under shift, the thesis can show how counterfactual transition generation helps reduce shortcut learning. If the improvement is limited, the work can still be useful by showing where the method becomes unstable or where the perturbation design matters. In both cases, the goal is to better understand how RL agents behave when misleading correlations are present in the training environment.

#bibliography("bib.yaml", title: "References")
