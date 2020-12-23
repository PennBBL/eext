### This script summarizes the data that has been collected by order of session
###
### Ellyn Butler
### December 22, 2020

df <- read.csv('~/Documents/eext/data/eext_collected_12-22-2020.csv')

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

df <- df[, c('bblid', 'scanid', 'datatype', 'nifti')]

# Function to assign session order
# (assuming, within a subject, that lower number means earlier in time)
sessionOrder <- function(i) {
  bblid <- df[i, 'bblid']
  scanids <- unique(df[df$bblid == bblid, 'scanid'])
  scanids <- scanids[order(scanids)]
  which(df[i, 'scanid'] == scanids)
}

df$session <- sapply(1:nrow(df), sessionOrder)
