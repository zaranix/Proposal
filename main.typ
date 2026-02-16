// Metadata
#let author_name = "Zahra Khodabakhshian"
#let author_email = "jov98mam@rptu.de"
#let mtrk_nr = "426198"
#let supervisor_name = "Naghmeh ghanoni"
#let prof_name = "Prof. Dr. Marius Kloft"
#let current_date = "November 2nd, 2025"
#let thesis_title = "Representation-Level Spectral Regularization for Robust Reinforcement Learning"

// Set document properties
#set document(
  title: thesis_title,
  author: author_name,
)
#set page(
  paper: "a4",
  margin: (left: 3cm, right: 3cm, top: 2.5cm, bottom: 2.5cm),
)
#set text(
  lang: "en",
  size: 12pt,
)
#set block(spacing: 1.5em)
#set heading(numbering: "1.")

// Title page
#align(center)[
  #text(10pt)[
    #smallcaps("Master Thesis")\
    Prüfer: #prof_name
  ]
  #v(2.0cm)
  #line(length: 100%)
  #text(20pt, weight: "bold")[#upper(thesis_title)]
  #line(length: 100%, stroke: 2pt)
  #v(0.5cm)
  #current_date
  #v(1fr)
  #author_name\
  Mtrk.nr.: #mtrk_nr\
  Rheinland-Pfälzische Technische Universität Kaiserslautern-Landau (RPTU)\
  #link("mailto:" + author_email)\
]

#pagebreak()

// Table of contents
#outline()

#pagebreak()
#counter(page).update(1)

= Motivation
Reinforcement learning (RL) has achieved strong empirical performance across a wide range of control and decision-making tasks. However, the generalization of learned policies beyond their training environments remains a significant challenge. In many practical settings, training environments contain correlations that are not causally related to the task objective. Agents may exploit such spurious correlations because they provide an easy path to reward maximization, even though they do not reflect the true structure of the problem. When these correlations change at test time, policies that rely on such shortcuts can fail.

Recent work in robust reinforcement learning has highlighted this issue and proposed mitigation strategies based on explicit interventions, such as state perturbations or counterfactual transition generation #cite(<Ding2023Seeing>). While these approaches can improve robustness under distribution shifts, they intervene at the level of the environment or training data and rely on additional modeling assumptions, increasing algorithmic complexity and limiting applicability in some settings.

At the same time, research in representation learning suggests that spurious correlations may also be reflected in the structure of learned representations. In high-dimensional neural feature spaces, variance can become concentrated in a small number of dominant directions associated with spurious but predictive features. Spectral regularization has been proposed to counteract this behavior by encouraging more balanced representations#cite(<Ghanooni2024Spectral>, supplement: none) . Motivated by this perspective, this thesis explores whether a representation-level intervention—applied to internal policy and value representations—can improve robustness in reinforcement learning without explicitly modifying the environment or training data.




= Related work
Robust reinforcement learning has increasingly focused on spurious correlations. A prominent example is Seeing is not Believing, which models spurious correlations as arising from unobserved confounders and proposes robustness mechanisms based on state perturbations and counterfactual transition generation @Ding2023Seeing. While this approach demonstrates improved robustness under distribution shifts, it does not explicitly analyze or constrain the internal representations learned by policy and value networks.

In parallel, representation learning research—particularly in self-supervised learning—has shown that spurious correlations can dominate the eigenspectrum of learned representations, leading to reduced robustness and poor transfer performance. Spectral regularization addresses this issue by penalizing spectral concentration and encouraging a more uniform distribution of variance across feature dimensions.

Although both lines of work aim to mitigate spurious correlations, they operate at different levels. Robust RL methods modify data or environment dynamics, while spectral regularization targets representation geometry. How these perspectives interact in reinforcement learning remains largely unexplored.

= Research Gap
Robustness to spurious correlations is essential for applying reinforcement learning in real-world settings. Existing approaches often intervene at the level of data or environment dynamics, which can increase complexity and require additional assumptions #cite(<Ding2023Seeing>, supplement: none).

In parallel, representation learning research—particularly in self-supervised learning—has studied how spurious features affect learned representations. Recent work shows that spurious correlations can dominate the eigenspectrum of feature representations, leading to reduced robustness and poor transfer performance. Spectral regularization methods address this issue by penalizing spectral concentration and encouraging a more uniform distribution of variance across feature dimensions.

Although both lines of work aim to mitigate spurious correlations, they operate at different levels. Robust RL methods focus on modifying data or environment dynamics, while spectral regularization focuses on representation geometry. The interaction between these perspectives in reinforcement learning settings has not yet been systematically studied.

= Approach
The proposed approach is empirical. Soft Actor-Critic (SAC) is used as the baseline reinforcement learning algorithm due to its stability and widespread use in continuous control tasks.

Spectral regularization is introduced as an additional loss term applied to internal representations of the policy and/or critic networks, following ideas from representation learning #cite(<Ghanooni2024Spectral>, supplement: none). Representations are extracted from selected hidden layers during training, and their spectral properties are analyzed using covariance-based measures such as eigenvalue decay and effective rank.

The method does not modify the environment, reward function, or training data. Instead, it constrains the geometry of learned representations during optimization.
= Research Questions and Expected Outcomes

This thesis addresses the following research question:

Can spectral regularization of learned representations improve the robustness of Soft Actor-Critic policies in environments with spurious correlations?

To answer this question, the thesis (i) analyzes whether SAC learns spectrally imbalanced representations under spurious correlations, (ii) studies how spectral regularization affects representation structure during training, and (iii) evaluates whether these changes reduce performance degradation under distribution shifts.

The expected outcomes are empirical and exploratory, aiming to clarify the potential and limitations of spectral regularization as a robustness mechanism in reinforcement learning.



#bibliography("bib.yaml", title: "References")
