author = Administrator.first.user

description = <<~TEXT
  Several RFOs experimented with the Ethics Framework for their stakeholder participation processes.
  Collective reflections on its practical use revealed difficulties and best practices that may prove
  valuable for future participatory processes. These lessons learned related to the: recruitment of
  participants; managing commitment and expectations; fostering of dialogue and equal participation;
  accommodation of vulnerable groups; creation of funding themes with participants; lack of expertise in
  participatory ethics; and planning, flexibility, and resources. In what follows, this section elaborates
  on some of the key insights that emerged from the RFOs’ experiments with the Framework.

  RFOs indicated difficulties in relation to the recruitment of participant. RFOs generally aim for a
  heterogeneous group of participants that embody the appropriate representation of stakeholders. Nevertheless,
  it remains difficult to determine what stakeholder representation is appropriate. RFOs selected stakeholders
  on various aspects, for instance, on their social background, education, age, religion, ethnicity, and gender
  (identity). But this likewise posed challenges when considering the intersectionality of participants; a
  participant may identify with multiple stakeholder groups. A possible way forward is to allow stakeholders to
  categorize themselves according to their own ideas regarding their identity. In addition, the ‘right’
  representation tends to be understood differently among stakeholders. The context-dependent nature of
  participatory processes provides that such challenges cannot be addressed in a standardized manner. However,
  RFOs can consider whether representations that reflect society are desirable, given that the politics among
  participants will then likely reflect the dynamics found in society. It may, for instance, be desirable in
  some cases to give minorities an enhanced voice to mitigate power imbalances. RFOs furthermore wrestled with
  the recruitment of the targeted stakeholders as these were not always willing to participate. RFOs therefore
  relied on feasible solutions such as snowball sampling and the support of multiplier organisations to compose
  a group of participants, while acknowledging the drawbacks of such methods (e.g. selection bias).

  Managing commitment and expectations posed challenges as stakeholders have different ideas on R&I, RFOs,
  and their participatory processes. Experiments suggest it is important to understand and accommodate the
  needs of participants. Some stakeholder may require different forms of participation, or may need financial
  compensation. It proved helpful to transparently communicate everyone’s expectations regarding the purpose,
  process, and outcomes of the participatory process. Such aspects can, for instance, be made explicit in a
  code of conduct.

  Various difficulties emerged during the participation process in relation to organizing dialogue and equal
  participation. Because stakeholder participation is frequently characterised by diverse perspectives, it
  poses the risk of misinterpreting each other. In addition, equal participation is deemed important to obtain
  all relevant values and worldviews. However, some participants dominated discussions as a result of their
  personality, knowledge, and institutional role (e.g. citizen vs. scientist). Deploying a skilled mediator
  may help to mitigate imbalances and involve less vocal participants. It may also help to reduce information
  asymmetries by either offering or withholding information.

  RFOs indicated challenges related to the accommodation of vulnerable groups. This is especially relevant as
  participatory processes in research funding often relate to solving real-life problems. The stakeholders
  affected by these problems may therefore be subject to social injustice, financial issues, or other
  disadvantages. Because vulnerability is difficult to define and understand, it can help to consider aspects
  that give rise to stakeholders’ vulnerability such as their resources, abilities, experiences, identities,
  values, and worldviews. Stakeholders generally have a better idea of their vulnerability. Hence, it can be
  beneficial to directly ask stakeholders’ perspectives on this as opposed to the RFO making this judgement by
  itself. RFOs could also help accommodate vulnerable groups based on their own suggestions, and by
  compensating for the underling aspects that give rise to disadvantages, e.g., through financial
  compensation, the use of translators, or the enhanced accessibility of meetings.

  In the case of stakeholder participation for the creation of funding themes/priorities, some RFOs
  experienced difficulties determining how to involve both conventional stakeholders (scientists and
  innovators) and non-traditional stakeholders (e.g. citizens). RFOs recognized three possible ways to involve
  them: (1) conventional stakeholders can propose themes, and non-traditional stakeholders can select and
  contextualize these; (2) non-traditional stakeholders propose themes, and conventional stakeholders select
  these; or (3) the proposition and selection is done collectively. While it remains unclear what approach is
  most meaningful, RFOs found that collective discussion can give rise to power imbalances (e.g. based on
  expertise and status). Allowing non-traditional stakeholders to propose themes provided many socially
  relevant themes, but where not always considered scientifically relevant. Allowing conventional stakeholders
  to propose themes, while non-traditional stakeholder selected them appeared most fruitful as this led to
  scientifically and socially relevant themes. Yet, the appropriate approach likely remains context-dependent.

  While skills and knowledge on ethics is believed to improve stakeholder participation, RFOs frequently
  lacked ethical expertise. It is therefore helpful to understand that organizing stakeholder participation
  benefits from a learning-by-doing type of approach that is flexible and open to feedback from it
  participants. RFOs suggested that the Ethics Framework helps, but that external support from ethicists can
  further foster the quality of participation.

  Lastly, it is important to stress that while the Ethics Framework strives for the highest ethical standards,
  this may not always be possible in practice. Organizing stakeholder participation is an uncertain process
  that tends to unfold differently than planned. One RFO mentioned that “these processes seem way more
  resource consuming than thought in the beginning”. Participatory processes are furthermore dependent on
  external factors (e.g. regulation and operational planning). All these challenges provide that it is helpful
  to have a surplus of resources available, and to have back-up plans in case flexibility is required.
TEXT

summary = <<~TEXT
  Bellow the poll you will find the "Part I: Experiences with the Ethics Framework" text, so you can read it before
  answering.
TEXT

poll = Poll.find_or_initialize_by(name: "Experiences with the Ethics Framework")
poll.description = description
poll.summary = summary
poll.starts_at = Time.current - 1.day
poll.ends_at = Time.current + 1.month
poll.author = author
poll.save!

# Question 1
title = <<TEXT
  Which of the experiences mentioned in Part I do you recognize most and how do you currently
  address related challenges?
TEXT
Poll::Question.find_or_create_by!(poll: poll, author: author, mandatory_answer: true, title: title)

# Question 2
title = <<TEXT
  Do you experience obstacles in participatory processes that are currently not or insufficiently mentioned
  in Part I?
TEXT
Poll::Question.find_or_create_by!(poll: poll, author: author, mandatory_answer: true, title: title)

# Question 3
title = "Do you have any other suggestions for how to improve this section?"
Poll::Question.find_or_create_by!(poll: poll, author: author, mandatory_answer: true, title: title)

# Question 4
title = "Enter your name or organization name"
Poll::Question.find_or_create_by!(poll: poll, author: author, mandatory_answer: false, title: title)

# Question 5
title = "Enter your email address if you want to receive updates"
Poll::Question.find_or_create_by!(poll: poll, author: author, mandatory_answer: false, title: title)
