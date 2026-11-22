#' Awards & Achievements section
#' @description
#' Honours and distinctions from achievements.yaml (same fields as
#' awards.yaml: name, institute, city, date, description, url, link_type).
achievements_section <- function(
  github_repo = NULL,
  branch = "main",
  page_break_after = FALSE
) {
  achievements_data <- read_cv_data_remote(github_repo, "achievements", branch)

  # Newest first
  achievements_data <- rev(achievements_data)

  entries <- lapply(achievements_data, function(x) {
    cv_entry(
      title = x$name,
      org = x$institute,
      location = x$city,
      start = x$date,
      body = if (!is_blank(x$description)) paste0("*", clean_text(x$description), "*"),
      links = list(cv_typed_link(x$url, x$link_type))
    )
  })

  cv_section("achievements", "Awards & Achievements", "award", entries, page_break_after)
}
