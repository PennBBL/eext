### This script summarizes the data that has been collected by order of session
###
### Ellyn Butler
### December 22, 2020

df <- read.csv('~/Documents/eext/data/eext_collected_12-22-2020.csv')
df$date <- as.Date(df$date, '%m/%d/%Y')

# Clean up scanid
df$scanid <- df$seslabel
df$scanid <- gsub('^0+', '', df$scanid)
df$scanid <- gsub('_MR*', '', df$scanid)
df$scanid <- gsub('^19987_+', '', df$scanid)
df$scanid <- gsub('^19989_+', '', df$scanid)

# Give temporary sensible bblids and scanids to PEP04 and PEP05
df$bblid <- df$subjlabel
df[df$subjlabel == 'PEP04', 'bblid'] <- '21000'
df[df$subjlabel == 'PEP05', 'bblid'] <- '21001'
df[df$subjlabel == 'PEP04', 'scanid'] <- '21000'
df[df$subjlabel == 'PEP05', 'scanid'] <- '21001'

# Convert type of bblid and scanid
df$bblid <- as.numeric(df$bblid)
df$scanid <- as.numeric(df$scanid)

df <- df[, c('bblid', 'scanid', 'date', 'datatype', 'nifti')]

# Function to assign session order
# (assuming, within a subject, that lower number means earlier in time)
sessionOrder <- function(i) {
  bblid <- df[i, 'bblid']
  dates <- unique(df[df$bblid == bblid, 'date'])
  dates <- dates[order(dates)]
  which(df[i, 'date'] == dates)
}

df$session <- sapply(1:nrow(df), sessionOrder)
