summary = <<~TEXT
  Participate in the definition of the Pro-Ethics framework \"Tools and guidelines\" document. Add your own
  comments and vote for the comments you agree/disagree.
TEXT

process = Legislation::Process.create!(title: "Part II: Tools & Guidelines",
                                      description: "Description of the process",
                                      summary: summary,
                                      start_date: Date.current,
                                      end_date: Date.current + 1.month,
                                      draft_publication_date: Date.current,
                                      allegations_start_date: Date.current,
                                      allegations_end_date: Date.current + 1.month,
                                      result_publication_date: Date.current + 2.months,
                                      allegations_phase_enabled: true,
                                      published: true)

Legislation::DraftVersion.create!(
  process: process,
  title: "Version 1",
  changelog: "Initial version",
  status: "published",
  final_version: false,
  body: File.read(Rails.root.join("Part-II.md"))
)
