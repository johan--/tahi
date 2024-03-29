a = DS.attr
ETahi.AdminJournal = DS.Model.extend
  logoUrl: a('string')
  name: a('string')
  paperTypes: a()
  manuscriptManagerTemplates: DS.hasMany('manuscriptManagerTemplate')
  roles: DS.hasMany('role')
  epubCoverUrl: a('string')
  epubCoverFileName: a('string')
  epubCss: a('string')
  pdfCss: a('string')
  manuscriptCss: a('string')
  description: a('string')
  paperCount: a('number')
  createdAt: a('date')
  journalTaskTypes: DS.hasMany('journalTaskType')
  doiJournalPrefix: a('string')
  doiPublisherPrefix: a('string')
  lastDoiIssued: a('number')
