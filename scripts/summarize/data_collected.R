### This script summarizes the data that has been collected by order of session
###
### Ellyn Butler
### December 22, 2020 - December 23, 2020

df <- read.csv('~/Documents/eext/data/eext_collected_12-23-2020.csv')
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

df <- df[, c('bblid', 'scanid', 'date', 'datatype', 'nifti', 'Tr', 'Te')]
#df$datatape <- gsub('\\*', 'star', df$datatape)

# Function to assign session order
# (assuming, within a subject, that lower number means earlier in time)
sessionOrder <- function(i) {
  bblid <- df[i, 'bblid']
  dates <- unique(df[df$bblid == bblid, 'date'])
  dates <- dates[order(dates)]
  which(df[i, 'date'] == dates)
}

df$session <- sapply(1:nrow(df), sessionOrder)


# Summarize Tr and Te for session 1 and 2, T2star sequences
ses1_Te <- table(df[df$session == 1 & df$datatype == 'T2*' & !is.na(df$datatype), 'Te'])
ses2_Te <- table(df[df$session == 2 & df$datatype == 'T2*' & !is.na(df$datatype), 'Te'])

ses1_Tr <- table(df[df$session == 1 & df$datatype == 'T2*' & !is.na(df$datatype), 'Tr'])
ses2_Tr <- table(df[df$session == 2 & df$datatype == 'T2*' & !is.na(df$datatype), 'Tr'])
