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
Reinforcement learning (RL) has achieved notable success in a variety of control and decision-making tasks. However, the generalization of learned policies remains a major challenge, particularly when training environments contain correlations that do not reflect the true structure of the task. Such spurious correlations can cause agents to rely on shortcuts that perform well during training but fail when the environment changes. This issue is especially relevant in realistic RL settings, where observations may be influenced by latent or unobserved factors.

Recent work in robust reinforcement learning has proposed explicit mechanisms to mitigate spurious correlations, often relying on state perturbations, counterfactual data generation, or causal modeling. While these approaches have shown promising results, they typically increase algorithmic complexity and require additional assumptions about the environment.

At the same time, research in representation learning has shown that spurious correlations can manifest as imbalanced feature representations, where a small number of dominant directions capture most of the variance. Spectral regularization has been proposed as a way to counteract this effect by encouraging more balanced representations. This thesis explores whether such a representation-level approach can be applied to reinforcement learning, with a focus on empirical evaluation rather than strong theoretical claims.

== Background
This section introduces the key concepts and methods that form the basis of this thesis. It provides background on spurious correlations in reinforcement learning, the Soft Actor-Critic algorithm, and spectral regularization in representation learning.

=== Spurious Correlations in Reinforcement Learning
In reinforcement learning, spurious correlations arise when parts of the observed state are correlated due to latent factors rather than causal relationships. An agent may learn to exploit these correlations during training, leading to policies that are sensitive to distribution shifts. Such failures have been observed in tasks involving visual distractions, background changes, or correlated object configurations. Addressing spurious correlations is therefore an important aspect of improving robustness in RL.

=== Soft Actor-Critic (SAC)
Soft Actor-Critic is a widely used off-policy reinforcement learning algorithm for continuous control. It combines maximum-entropy reinforcement learning with actor–critic methods to achieve stable and sample-efficient learning. Due to its robustness and popularity, SAC serves as a suitable baseline for studying the effects of spurious correlations and representation-level regularization.

=== Spectral Regularization in Representation Learning
Spectral regularization refers to techniques that control the distribution of variance in learned feature representations, often by penalizing dominance of a small number of feature directions. In self-supervised learning, such methods have been shown to improve robustness and transfer performance by encouraging more diverse representations. The potential relevance of these ideas to reinforcement learning has not yet been systematically explored.

== Relevance
Understanding and mitigating spurious correlations is critical for deploying reinforcement learning systems in real-world environments. This research is relevant to both the reinforcement learning and representation learning communities. The main contributions of this thesis are:

- *Simpler robustness mechanism:* The thesis investigates a representation-level alternative to explicit state perturbation or causal modeling.
- *Empirical insight:* By analyzing spectral properties of RL representations, this work contributes to a better understanding of how spurious correlations affect policy learning.
- *Bridging research areas:* The thesis connects ideas from self-supervised representation learning to robustness in reinforcement learning.


== Research Question
The central research question of this thesis is:

*Can spectral regularization of learned representations improve the robustness of Soft Actor-Critic policies in reinforcement learning environments that exhibit spurious correlations?*

To address this question, the following sub-questions are investigated:

- Q1: Do SAC representations show spectral imbalance under spurious correlations?
- Q2: How does spectral regularization affect the representation structure?
- Q3: Does this lead to better performance under distribution shift?

== Approach
To address the research questions, this thesis will follow a design science research methodology. The approach will consist of the following phases:

1.  *Literature Review:* A comprehensive review of the existing literature on honeynets, Infrastructure as Code, and the use of LLMs for code generation will be conducted.
2.  *System Design and Implementation:* A system will be designed and implemented that takes high-level descriptions of honeynets as input and uses an LLM to generate IaC code (e.g., Terraform) as output.
3.  *Evaluation:* The generated IaC code will be evaluated based on its functionality, plausibility from an attacker’s perspective, and maintainability. This will involve deploying the generated infrastructure and performing a series of tests.
4.  *Analysis and Discussion:* The results of the evaluation will be analyzed, and the limitations of the approach will be discussed. The findings will be used to answer the research questions and provide recommendations for future research.

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

#cite(<Srivatsa2024Survey>, supplement: none)
#bibliography("bib.yaml", title: "References")
