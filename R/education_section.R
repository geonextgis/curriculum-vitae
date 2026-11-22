education_section <- function(
  github_repo = NULL,
  branch = "main",
  page_break_after = FALSE,
  include_sections = c("description", "thesis", "awards")
) {
  education_data <- read_cv_data_remote(github_repo, "education", branch)

  # Newest first
  education_data <- rev(education_data)

  entries <- lapply(education_data, function(x) {
    body <- c(
      if ("description" %in% include_sections && !is_blank(x$description)) {
        clean_text(x$description)
      },
      if (!is_blank(x$research_focus)) {
        paste0("Research focus: ", clean_text(x$research_focus))
      },
      if (!is_blank(x$research_question)) {
        paste0("Research question: *", clean_text(x$research_question), "*")
      },
      if (!is_blank(x$supervisor)) {
        paste0("Supervisor: ", clean_text(x$supervisor))
      },
      if ("thesis" %in% include_sections && !is_blank(x$thesis)) {
        paste0("Thesis: *", clean_text(x$thesis), "*")
      },
      if ("awards" %in% include_sections && !is_blank(x$awards)) {
        paste0("Awards: *", clean_text(x$awards), "*")
      }
    )

    cv_entry(
      title = x$degree,
      org = x$university,
      location = x$city,
      start = x$start,
      end = x$end,
      body = body
    )
  })

  cv_section("education", "Education", "graduation-cap", entries, page_break_after)
}
