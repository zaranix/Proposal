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

This thesis follows the direction opened by the RSC-MDP framework from _Seeing is not Believing_ @Ding2023Seeing. I focus on the empirical question of how much a reinforcement learning policy depends on a shortcut when the training environment contains a controlled spurious correlation. Rather than treating robustness only as resistance to small random noise, I study a more structured shift: the relationship between two observed parts of the state changes between training and evaluation.

The goal is to build a small but clear experimental setting where this behavior can be measured. The thesis therefore asks whether a policy trained in a confounded environment still performs well when the spurious relationship is removed or reversed, and whether a robustness-oriented training procedure can improve this behavior compared with standard SAC.

= Proposed Method

Building on this direction, my proposed method adapts the empirical RSC-SAC idea to my experimental setting. The central problem is that the variable creating the spurious correlation is not something the agent can directly observe or intervene on. Because of that, I do not try to manipulate the hidden confounder itself. Instead, I approximate what such a change could look like by modifying observed states from the replay buffer and using these modified samples during training.

The method can be understood in four steps. First, the agent collects normal SAC experience in the environment. Second, during training, some states from a replay-buffer batch are perturbed using the rule from Eq. 7. The purpose of this perturbation is to change one meaningful part of the state while keeping the remaining state as close as possible to a real sample. Third, since the original next state and reward may no longer match the perturbed state, I use a learned transition model to predict a new next state and reward. This transition model includes a sparse learnable graph, which is intended to reduce unnecessary dependencies between state dimensions. Finally, SAC is updated on a mixed batch containing both real transitions and generated transitions.

This means that SAC is still the base learning algorithm. The robust part comes from changing the data distribution seen during the SAC update. Ideally, the generated transitions reduce the agent's dependence on the training-time shortcut and encourage the policy to use features that remain useful when the spurious relationship changes.

#block(inset: 8pt, stroke: 0.6pt + gray, radius: 2pt)[
  *Training procedure: RSC-SAC style update*

  *Given:* policy $pi$, replay buffer $D$, transition model $P_theta$, graph parameter $phi$, modification ratio $beta$

  *for each training step* $t$ *do*

  $quad a_t <- pi(dot | s_t)$

  $quad$ execute $a_t$ and observe $(s_(t+1), r_t)$

  $quad D <- D union {(s_t, a_t, s_(t+1), r_t)}$

  $quad$ sample a batch $B$ from $D$

  $quad$ choose a subset $I subset B$ with size controlled by $beta$

  $quad$ perturb the selected states using Eq. 7:

  $quad quad tilde(s)_j <- "Perturb"(s_j), quad j in I$

  $quad$ predict new transition targets:

  $quad quad (hat(s)'_j, hat(r)_j) <- P_theta(tilde(s)_j, a_j, G_phi)$

  $quad$ replace selected rows by $(tilde(s)_j, a_j, hat(s)'_j, hat(r)_j)$

  $quad$ train $P_theta$ and $G_phi$ with

  $quad quad L = norm(s'_j - hat(s)'_j)_2^2 + norm(r_j - hat(r)_j)_2^2 + lambda norm(G_phi)_p$

  $quad$ update the SAC actor and critics on the mixed batch

  *end for*
]

In my implementation, this algorithm is applied to a controlled robosuite task. The task-specific construction of the spurious correlation is described in the next section.

==  Perturbing Replay-Buffer States

The first RSC-specific step is to generate a perturbed version of the current state. The perturbation rule uses one state dimension $i$ and replaces it by the same dimension from another sample $k$ in the batch. The chosen sample should be different in dimension $i$, but still close in the remaining dimensions:

$
  s_t^i <- s_k^i, quad
  k = arg max frac(norm(s_t^i - s_k^i)_2^2, sum_(tilde(i)) norm(s_t^(tilde(i)) - s_k^(tilde(i)))_2^2),
  quad k in {1, dots, K}
$

In my words, this tries to create a useful counterfactual-like state: one part of the observation is changed, while the rest of the state is kept close to something that was actually seen in the replay buffer. This is the step that weakens the original spurious relationship before the transition model predicts the new next state and reward.

==  Learning the Structural Transition Model

After perturbing the current state, the original transition target is no longer fully reliable. The next state and reward in the replay buffer came from the original state, not from the perturbed one. For this reason, the method learns a transition model that can generate a new target for the modified state-action pair:

$
  (hat(s)_(t+1), hat(r)_t) <- P_theta(tilde(s)_t, a_t, G_phi)
$

The important idea from Section 4.2 is that this model is not just a standard black-box dynamics model. It also learns a sparse graph $G_phi$ between the input variables $(s_t, a_t)$ and the output variables $(s_(t+1), r_t)$. In my implementation, this graph is represented through differentiable binary-concrete edge samples. The sparsity term encourages the model to use only the dependencies that are useful for prediction, instead of freely connecting every input dimension to every output dimension.

The architecture follows the model described in Appendix D.1. Each scalar state or action dimension is encoded with a shared encoder together with a learnable position embedding. The learned graph then mixes these encoded features, and a shared decoder predicts each dimension of the next state and the reward. I use the following schematic to summarize the model:

#figure(
  image("Gemini_Generated_Image_ka1o4gka1o4gka1o.png", width: 95%),
  caption: [Schematic of the structural transition model used to generate next-state and reward targets for perturbed states.],
)

The model is trained with a prediction loss for the next state and reward, together with a graph sparsity penalty:

$
  L(theta, phi) =
    norm(s_(t+1) - hat(s)_(t+1))_2^2
    + norm(r_t - hat(r)_t)_2^2
    + lambda norm(G_phi)_p
$

This generated transition is then inserted into the SAC batch. In this way, the policy and critic are trained not only on the original confounded data, but also on transitions where the spurious relationship has been weakened by perturbation.

==  Environment Design

The environment is based on robosuite Lift with a Panda robot. The observation wrapper appends the cube RGB values `[r, g, b]` to the flattened state so the spurious factor is visible to the agent and available to the perturbation mechanism.

To study spurious correlation, I modify the reset distribution of the Lift environment. The wrapper samples a left or right cube position and a green or red cube color. In `confounded` mode these two variables are tied together: left corresponds to green, and right corresponds to red. In `shifted_swapped` mode the mapping is reversed, and in `shifted_indep` mode the color is sampled independently of the cube position.

In this implementation, $s_t$ denotes the flattened robosuite observation after appending these RGB values. The `random` perturbation mode follows Eq. 7 directly, while the `rgb`, `rgb_single`, and `mixed` modes are Lift-specific ablations that perturb the appended color feature more explicitly.

The environment supports different spurious modes:

- `confounded`: cube position and cube color are correlated. This is the nominal training setting.
- `shifted_indep`: cube position and cube color are independent. This tests whether the policy still works when the shortcut is removed.
- `shifted_swapped`: the color-position mapping is swapped. This tests whether the policy fails when the shortcut becomes misleading.

==  Base RL Algorithm: SAC

The base reinforcement learning algorithm is Soft Actor-Critic. The RSC method is not a replacement for SAC; it modifies the data used during SAC updates. The final SAC update is performed on a mixed batch where some transitions are replaced by synthetic ones consisting of perturbed current state, original action, predicted next state, and predicted reward. This exposes the policy and critic to transitions where the spurious feature has been changed.


= Research Questions

This thesis investigates the following research questions:

1. Does a standard SAC agent trained in the confounded Lift environment rely on the spurious color-position correlation?

2. Can RSC-style counterfactual transition generation improve robustness under shifted test environments?

3. How important is the perturbation strategy, especially when comparing paper-faithful random perturbation with color-focused perturbation?


= Expected Outcome

The expected outcome is an empirical study of robust RL under a controlled spurious correlation. I expect to compare standard SAC with an RSC-inspired variant that uses generated transitions. The main evaluation will measure success rates in the original confounded environment and in shifted environments where the spurious relationship changes.

The contribution of the thesis will be a clear experimental analysis rather than a claim that one method solves the full problem. If the robust method improves performance under shift, the thesis can show how counterfactual transition generation helps reduce shortcut learning. If the improvement is limited, the work can still be useful by showing where the method becomes unstable or where the perturbation design matters. In both cases, the goal is to better understand how RL agents behave when misleading correlations are present in the training environment.

== Preliminary Results

The following tables show preliminary results from experiments comparing a baseline SAC agent (Base) with an RSC-SAC agent using random perturbation (Random):

*Table 1: Testing reward on shifted environments.*

#table(
  columns: 3,
  [Environment], [Base (SAC)], [Random (RSC-SAC)],
  [Shifted independent], [0.412], [0.647],
  [Shifted swapped], [0.000], [0.312],
)

*Table 2: Testing reward on nominal environments.*

#table(
  columns: 3,
  [Environment], [Base (SAC)], [Random (RSC-SAC)],
  [Confounded (nominal)], [1.000], [0.824],
)

*Note on Metrics:* The paper reports normalized rewards, while I report raw episodic returns. My raw return is the sum of shaped robosuite rewards over an episode. The paper divides each method's mean episode return by vanilla SAC's mean episode return in the nominal environment. Because I have not applied this normalization yet, my numbers show performance on my own reward scale and are mainly comparable within my experiments, not directly against the paper tables.

#bibliography("bib.yaml", title: "References")
