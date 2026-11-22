#' Contact Section (Remote)
#' @description
#' Sidebar block with position, affiliation and contact links.
#' @param github_repo GitHub repository in format "owner/repo".
#' @param branch Branch name (default is "main").
#' @return A Markdown string.
contact_section <- function(github_repo = NULL, branch = "main") {
  contact_data <- read_cv_data_remote(github_repo, "contact", branch)

  # Obfuscate the visible address; the mailto: target stays usable. A
  # zero-width space after [at] lets the long label wrap in the sidebar.
  email_label <- gsub("\\.", "[dot]", sub("@", paste0("[at]", intToUtf8(0x200B)), contact_data$email))

  has <- function(field) !is_blank(contact_data[[field]])

  items <- c(
    if (has("position")) cv_item("user", contact_data$position),
    if (has("institute")) cv_item("building-columns", contact_data$institute),
    if (has("city")) cv_item("map-location-dot", contact_data$city),
    if (has("email")) cv_item(
      "envelope",
      sprintf("[%s](mailto:%s)", gsub("([][])", "\\\\\\1", email_label), contact_data$email)
    ),
    if (has("phone")) cv_item(
      "phone",
      sprintf("[%s](tel:%s)", contact_data$phone, gsub("[^+0-9]", "", contact_data$phone))
    ),
    if (has("website")) cv_item(
      "house",
      sprintf(
        "[%s](%s)",
        sub("/$", "", sub("https*://", "", contact_data$website)),
        contact_data$website
      )
    ),
    if (has("orcid")) cv_item(
      "orcid",
      sprintf("[%s](https://orcid.org/%s)", contact_data$orcid, contact_data$orcid)
    ),
    if (has("google_scholar")) cv_item(
      "google-scholar",
      sprintf("[Google Scholar](%s)", contact_data$google_scholar)
    ),
    if (has("linkedin")) cv_item(
      "linkedin",
      sprintf(
        "[%s](https://www.linkedin.com/in/%s)",
        contact_data$linkedin,
        contact_data$linkedin
      )
    ),
    if (has("github")) cv_item(
      "github",
      sprintf("[%s](https://github.com/%s)", contact_data$github, contact_data$github)
    ),
    if (has("medium")) cv_item(
      "medium",
      sprintf("[Medium](https://medium.com/@%s)", contact_data$medium)
    ),
    if (has("twitter")) cv_item(
      "x-twitter",
      sprintf("[%s](https://twitter.com/%s)", contact_data$twitter, contact_data$twitter)
    ),
    if (has("researchgate")) cv_item(
      "researchgate",
      sprintf("[ResearchGate](%s)", contact_data$researchgate)
    )
  )

  cv_block("contact", "Contact Info", items)
}
