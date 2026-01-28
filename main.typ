// Metadata
#let author_name = "Zahra Khodabakhshian"
#let author_email = "jov98mam@rptu.de"
#let mtrk_nr = "426198"
#let supervisor_name = "Naghmeh ghanoni"
#let prof_name = "Prof. Dr. Marius Kloft"
#let exam_nr = "xxxxxx"
#let submission_date = ""
#let current_date = "November 2nd, 2025"
#let thesis_title = "An Empirical Study of Spectral Regularization for Mitigating Spurious Correlations in Reinforcement Learning"

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
    Prüfungsnr.: #exam_nr\
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

= Introduction
Reinforcement learning (RL) has shown strong results across a wide range of control and decision-making tasks. However, ensuring that learned policies generalize beyond their training environments remains a major challenge. In particular, when training environments contain correlations that do not reflect the true structure of the task, agents may learn to rely on shortcuts. These spurious correlations can lead to policies that perform well during training but fail once the environment changes. This issue is especially common in realistic RL settings, where observations are often influenced by latent or unobserved factors that introduce non-causal correlations between state components [1].

To address this problem, recent work in robust reinforcement learning has proposed explicit mitigation strategies, often motivated by causal reasoning. A notable example is Seeing is not Believing, which models spurious correlations as the result of unobserved confounders and introduces robustness through state perturbations and counterfactual transition generation [2]. While such approaches have demonstrated promising empirical performance, they typically intervene at the level of the environment or training data and require additional modeling assumptions.

At the same time, research in representation learning suggests a complementary perspective. Studies in self-supervised learning have shown that spurious correlations can also appear in the structure of learned representations, where a small number of dominant directions capture most of the variance in high-dimensional feature spaces. Spectral regularization has been proposed as a way to counteract this effect by encouraging a more balanced eigenspectrum, leading to improved robustness and transfer performance [3]. Motivated by this representation-level view, this thesis investigates whether applying spectral regularization to the high-dimensional internal representations learned by Soft Actor-Critic can improve robustness to spurious correlations, without relying on explicit state-level interventions.




== Background
This section introduces the core concepts that motivate and support this thesis. It covers the notion of spurious correlations in reinforcement learning, the Soft Actor-Critic algorithm used in this work, and spectral regularization methods from representation learning that inspire the proposed approach.

=== Spurious Correlations in Reinforcement Learning
In reinforcement learning, spurious correlations occur when parts of the observed state are correlated due to latent or unobserved factors rather than causal relationships. Agents may exploit such correlations during training because they provide an easy path to reward maximization. However, when these correlations change at test time, the learned policies can fail. This issue has been studied in recent work that frames spurious correlations in RL through unobserved confounders and investigates robustness under distribution shifts #cite(<Ding2023Seeing>, supplement: none).
=== Soft Actor-Critic (SAC)
Soft Actor-Critic (SAC) is an off-policy actor–critic algorithm for continuous control that combines reward maximization with an entropy-based exploration objective. Due to its stability and widespread use, SAC provides a suitable baseline for studying robustness and representation-level effects in reinforcement learning.
=== Spectral Regularization in Representation Learning
Spectral regularization methods aim to control how variance is distributed across learned feature dimensions. In self-supervised learning, such methods have been shown to reduce reliance on dominant feature directions and improve robustness by encouraging more balanced representations #cite(<Ghanooni2024Spectral>, supplement: none). Whether similar representation-level effects exist in reinforcement learning, where representations are learned implicitly, remains an open question.

== Relevance
Robustness to spurious correlations is essential for applying reinforcement learning in real-world settings. Existing approaches often intervene at the level of data or environment dynamics, which can increase complexity and require additional assumptions #cite(<Ding2023Seeing>, supplement: none).

This thesis explores a complementary direction by focusing on the structure of learned representations. Its relevance lies in:

- *Simplicity:* The thesis investigates a representation-level alternative to explicit state perturbation or causal modeling.
- *Insight:* By analyzing spectral properties of RL representations, this work contributes to a better understanding of how spurious correlations affect policy learning.
- *Connection:* The thesis connects ideas from self-supervised representation learning to robustness in reinforcement learning.


== Research Question
The central research question of this thesis is:

*Can spectral regularization of learned representations improve the robustness of Soft Actor-Critic policies in reinforcement learning environments that exhibit spurious correlations?*

To address this question, the following sub-questions are investigated:

- Q1: Do SAC representations show spectral imbalance under spurious correlations?
- Q2: How does spectral regularization affect the representation structure?
- Q3: Does this lead to better performance under distribution shift?

== Approach


== Methods
// This research will employ a mixed-methods approach, combining design science with experimental evaluation. The following methods and tools will be used:

// - *Systematic Literature Review:* A systematic literature review will be conducted to identify the state-of-the-art in honeynet design, IaC generation, and the use of LLMs for code generation. This will inform the requirements for the system.
// - *Prototyping:* A prototype system will be developed in Python to orchestrate the generation process. This system will interface with a state-of-the-art LLM (e.g., GPT-4 or a similar model).
// - *Experimental Comparison:* We will design and conduct experiments to compare different approaches for generating IaC with LLMs and different LLM models. This will include:
//   - *Template-based generation:* Using LLMs to fill in predefined Terraform templates.
//   - *Single-shot generation:* Generating the entire IaC configuration from a single, detailed prompt.
//   - *Conversational generation:* Using a series of prompts and responses to iteratively refine the IaC code.
// - *Infrastructure as Code:* Terraform will be used as the primary IaC tool for defining and deploying the honeynet infrastructure on a public cloud platform (e.g., AWS or GCP).

== Evaluation
// The evaluation of the system will be conducted in three parts, each addressing one or more of the research questions Q1–Q3:

// 1.  *Functionality (Q2, Q3):* The generated IaC will be deployed to a cloud environment to verify that it successfully creates the specified honeynet infrastructure. This will be tested with a set of predefined honeynet scenarios of varying complexity.
// 2.  *Plausibility and Attacker Perception (Q1, Q2):* The generated honeynets will be assessed for how plausible they appear to an attacker, including cognitive load (e.g., amount and distribution of realistic vulnerabilities, configuration details, and services) and whether an attacker is likely to suspect a trap.
// 3.  *Quality (Q2, Q3):* The quality of the generated IaC will be evaluated based on metrics such as code complexity, maintainability, and adherence to best practices. This will be compared across the different generation approaches (template-based, single-shot, and conversational).

= Outline
// This is a preliminary outline of the thesis. It is subject to change as the research progresses.

// + Introduction
// + Background
//   + Honeynets and Honeypots
//   + Infrastructure as Code (IaC)
//   + Large Language Models (LLMs) for Code Generation
// + Related Work
// + System Design and Architecture
//   + High-Level Honeynet Description Language
//   + LLM-based IaC Generation Engine
//   + Plausibility and Validation Module
// + Implementation
//   + Prototype Development
//   + Integration with Cloud APIs
// + Evaluation
//   + Experimental Setup
//   + Results and Analysis
// + Discussion
//   + Limitations
//   + Future Work
// + Conclusion

= Schedule
#import "@preview/timeliney:0.4.0"

#timeliney.timeline(
  show-grid: true,
  {
    import timeliney: *
    headerline(..range(6).map(n => group("W" + str(4*n+1) + "-W" + str(4*n+4), span: 4)), unit: 1)
    taskgroup(
      title: [*Thesis Schedule*],
      {
        task("Literature Review", (from: 0, to: 1))
        task("System Design", (from: 1, to: 2))
        task("Implementation", (from: 2, to: 4))
        task("Evaluation", (from: 4, to: 5))
        task("Writing", (from: 5, to: 6))
      },
    )
    milestone(
      at: 1,
      style: (stroke: (dash: "dashed")),
      align(center, [
        *Proposal*\
        January 1st
      ])
    )
    milestone(
      at: 6,
      style: (stroke: (dash: "dashed")),
      align(center, [
        *Final Submission*\
        #submission_date
      ])
    )
  }
)



= Supervisor

Who is your supervisor? (#supervisor_name) Have you discussed your proposal with them? What do you still need to clear up?

#bibliography("bib.yaml", title: "References")
