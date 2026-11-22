articles_section <- function(
  github_repo = NULL,
  branch = "main",
  page_break_after = FALSE,
  max_entries = NULL
) {
  publications_data <- read_cv_data_remote(github_repo, "publications", branch)
  metrics <- read_cv_data_remote(github_repo, "journals", branch)

  # Most recent first
  publications_data <- rev(publications_data)

  if (!is.null(max_entries)) {
    publications_data <- head(publications_data, max_entries)
  }

  entries <- lapply(publications_data, function(pub) {
    cv_entry(
      # BibTeX-style case protection, e.g. "({LUCC})"
      title = gsub("[{}]", "", pub$title),
      org = gsub("Halder, K\\.", "[Halder, K.]{.underline}", clean_text(pub$authors)),
      start = pub$year,
      body = paste0("*", journal_with_metrics(pub$journal, metrics), "*"),
      links = list(
        cv_link(pub$doi, "Read", "file-lines"),
        cv_link(pub$data_url, "Data", "database"),
        cv_link(pub$code_url, "Code", "code")
      )
    )
  })

  cv_section("publications", "Publications", "newspaper", entries, page_break_after)
}

#' Journal name followed by its metrics from journals.yaml
#' @description
#' "Journal (IF 2024: 7.1; Q1)". Journals missing from journals.yaml, or
#' with a blank impact_factor, are shown by name only (with a warning for
#' missing ones, so a new journal is not forgotten).
journal_with_metrics <- function(journal, metrics) {
  journal <- clean_text(journal)
  entry <- metrics$journals[[journal]]
  if (is.null(entry)) {
    warning("No metrics for journal '", journal, "' in journals.yaml")
    return(journal)
  }
  if (is_blank(entry$impact_factor)) return(journal)

  label <- if (is_blank(metrics$jcr_year)) "IF" else paste("IF", metrics$jcr_year)
  parts <- c(
    paste0(label, ": ", entry$impact_factor),
    if (!is_blank(entry$quartile)) entry$quartile
  )
  sprintf("%s (%s)", journal, paste(parts, collapse = "; "))
}
