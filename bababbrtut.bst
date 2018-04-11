%%
%% This is file `bababbrtut.bst',
%% based on the file `bababbrv-fl.bst' v1.31 by Harald Hardeds
%%
%%   This program can be redistributed and/or modified under the terms
%%   of the LaTeX Project Public License Distributed from CTAN
%%   archives in directory macros/latex/base/lppl.txt; either
%%   version 1 of the License, or any later version.
%% 
%% 2017/10/07 v0.95d

% 0.95d: Correct French and Swedish jvolume, fix extra space before note which was messing with hyphenation

ENTRY
  { address
    annote
    annotelanguage
    author
    booktitle
    chapter
    edition
    editor
    howpublished
    institution
    isbn
    issn
    journal
    key
    language
    location %% Bibtex defines 'address' as where event was held for proceedings, so this needs to be borrowed from biblatex for publisher
    month %% Strictly taken this should always be for publication month, but it is established practice to place conference dates here, like 'dec # "5--9"'
    note
    numappendixpages %% There seems to be no suitable existing field name for this
    number
    numpages %% sees more usage than biblatex-defined pagetotal (numpages/pagetotal filetype:bst gives 8000 vs. 500 Google hits)
    organization
    pages
    pagetotal %% for compatibility with biblatex
    publisher
    school
    series
    title
    type
    url
    urldate
    venue %% for compatibility with biblatex
    volume
    year
  }
  {}
  { label }

INTEGERS
  { output.state
    before.all
    mid.sentence
    after.sentence
    after.block
    before.title
  }

STRINGS
  { s
    t
    language.state
    change.temp
    isbn.command
  }

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
  #4 'before.title :=
  "nostate" 'language.state :=
}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

FUNCTION {language.change.case}
{
  'change.temp :=
  't :=
  "\btxifchangecase {"
  t change.temp change.case$ *
  "}{" *
  t *
  "}" *
}

FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { ", " * write$ }
    { output.state after.block =
        { add.period$ write$
          newline$
          "\newblock " write$
        }
        { output.state before.all =
            'write$
            {
              output.state before.title =
                { "\btxauthorcolon\ " * write$ }
                { add.period$ " " * write$ }
              if$
            }
          if$
        }
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}

FUNCTION {output.bibitem}
{ newline$
  language empty$
    {
      language.state "nolanguage" =
        'skip$
        {
          "empty language in " cite$ * warning$
          "\expandafter\btxselectlanguage\expandafter {"
          "\btxfallbacklanguage}" *
          write$ newline$
        }
      if$
      "nolanguage" 'language.state :=
    }
    {
      language.state language =
        'skip$
        {
          "\btxselectlanguage {" language * "}" *
          write$ newline$
        }
      if$
      language 'language.state :=
    }
  if$
  "\bibitem {" write$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

% Entries with ISBN defined could potentially cause problems at the end of the entry.
% Consider entries with endings like ", 2007, 315 p.\ifbtxprintisbn{978-...-0}" and ", 2015 \ifbtxprintisbn{1234-5678}". Even if the flag is off, the add.period$ command considers the last character to be 0/8 - causing the entry to end like ", 2007, 315p.."
% If we were to print a period here, then the latter entry would be missing a period when ISBN printing is not on.
% The bibliography style does not include ISBNs anyway, so let's just arbitrarily move the ISBNs a bit upward in the entry types where they might cause problems
FUNCTION {output.isbn}
{
  'isbn.command :=
  duplicate$
  empty$
    'pop$
    {
      's :=
      output.state mid.sentence =
        {
          isbn.command * " {, " * write$
          s "}" *
        }
        { output.state after.block =
            {
              add.period$
              write$
              newline$
              "\newblock " write$
              isbn.command " {" * s * ".}" *
            }
            { output.state before.all =
                {
                  write$
                  isbn.command " {" * write$
                  s "}" *
                }
                {
                  output.state before.title =
                    {
                      "\btxauthorcolon\ " * write$
                      isbn.command " {" * write$
                      s "}" *
                    }
                    {
                      add.period$ " " * write$
                      isbn.command " {" * write$
                      s ".}" *
                    }
                  if$
                }
              if$
            }
          if$
          mid.sentence 'output.state :=
        }
      if$
    }
  if$
}

FUNCTION {fin.entry}
{ % we don't want periods for entries ending in URLs, so let's do the period adding in each entry before the URL
  write$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
        'skip$
        { after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {after.authors}
{ output.state before.all =
    'skip$
    { before.title 'output.state := }
  if$
}

FUNCTION {new.block.checka}
{ empty$
    'skip$
    'new.block
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {new.block.checkc}
{ empty$
  swap$ empty$
  and
    'skip$
    'after.authors
  if$
}

FUNCTION {new.sentence.checka}
{ empty$
    'skip$
    'new.sentence
  if$
}

FUNCTION {new.sentence.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.sentence
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {namefont}
{ duplicate$ empty$
    { pop$ "" }
    { "\btxnamefont {" swap$ * "}" * }
  if$
}

FUNCTION {lastnamefont}
{ duplicate$ empty$
    { pop$ "" }
    { "\btxlastnamefont {" swap$ * "}" * }
  if$
}
FUNCTION {titlefont}
{ duplicate$ empty$
    { pop$ "" }
    { "\btxtitlefont {" swap$ * "}" * }
  if$
}
FUNCTION {jtitlefont}
{ duplicate$ empty$
    { pop$ "" }
    { "\btxjtitlefont {" swap$ * "}" * }
  if$
}
FUNCTION {journalfont}
{ duplicate$ empty$
    { pop$ "" }
    { "\btxjournalfont {" swap$ * "}" * }
  if$
}
FUNCTION {publisherfont}
{ duplicate$ empty$
    { pop$ "" }
    { "\btxpublisherfont {" swap$ * "}" * }
  if$
}
FUNCTION {volumefont}
{ duplicate$ empty$
    { pop$ "" }
    { "\btxvolumefont {" swap$ * "}" * }
  if$
}

FUNCTION {etalfont}
{ duplicate$ empty$
    { pop$ "" }
    { "\btxetalfont {" swap$ * "}" * }
  if$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { nameptr #1 >
      {
        s nameptr
        "{f{.\btxfnamespaceshort }.~}{vv~}" format.name$
        s nameptr "{ll}" format.name$ lastnamefont *
        s nameptr "{,~jj}" format.name$ *
        't :=
          namesleft #1 >
            { ", " * t namefont * }
            {
              s nameptr "{ff~}{vv~}{ll}{, jj}" format.name$ "others" =
                { " " "\btxetalshort {.}" etalfont * * }
                { ", " * t namefont * }
              if$
            }
          if$
        }
        {
          s nameptr "{f{.\btxfnamespaceshort }.~}{vv~}" format.name$
          s nameptr "{ll}" format.name$ lastnamefont *
          s nameptr "{,~jj}" format.name$ * namefont
        }
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.nameseditors}
{ output.state mid.sentence =
    { 's :=
      #1 'nameptr :=
      s num.names$ 'numnames :=
      numnames 'namesleft :=
        { namesleft #0 > }
        { nameptr #1 >
          {
            s nameptr "{ll}" format.name$ lastnamefont
            s nameptr "{,~jj}{,~f{.\btxfnamespaceshort }.}{~vv}" format.name$ *
            't :=
              namesleft #1 >
                { ", " * t namefont * }
                {
                  s nameptr "{ff~}{vv~}{ll}{, jj}" format.name$ "others" =
                    { " " "\btxetalshort {.}" etalfont * * }
                    { ", " * t namefont * }
                  if$
                }
              if$
            }
            {
              s nameptr "{ll}" format.name$ lastnamefont
              s nameptr "{,~jj}{,~f{.\btxfnamespaceshort }.}{~vv}"
              format.name$ * namefont
            }
          if$
          nameptr #1 + 'nameptr :=
          namesleft #1 - 'namesleft :=
        }
      while$
    }
    { format.names }
  if$
}

FUNCTION {format.authors}
{ author empty$
    { "" }
    { author format.names }
  if$
}

FUNCTION {format.editors}
{ editor empty$
    { "" }
    { editor format.nameseditors
      editor num.names$ #1 >
        { "\ (\btxeditorsshort {.})" * }
        { "\ (\btxeditorshort {.})" * }
      if$
    }
  if$
}
FUNCTION {format.title}
{ title empty$
    { "" }
    { title "t" language.change.case titlefont }
  if$
}
FUNCTION {format.jtitle}
{ title empty$
    { "" }
    { title "t" language.change.case jtitlefont }
  if$
}
FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
        { t #1 #2 substring$ "--" = not
            { "--" *
              t #2 global.max$ substring$ 't :=
            }
            {   { t #1 #1 substring$ "-" = }
                { "-" *
                  t #2 global.max$ substring$ 't :=
                }
              while$
            }
          if$
        }
        { t #1 #1 substring$ *
          t #2 global.max$ substring$ 't :=
        }
      if$
    }
  while$
}

FUNCTION {format.date}
{ year empty$
    { month empty$
        { "" }
        { "there's a month but no year in " cite$ * warning$
          month
        }
      if$
    }
    { month empty$
        'year
        { "\btxprintmonthyear{.}{"
          month * "}{" * year * "}{short}" *
        }
      if$
    }
  if$
}

FUNCTION {format.btitle}
{ title titlefont
}

FUNCTION {format.booktitle}
{ booktitle titlefont
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { "\ " }
  if$
  swap$ * *
}

FUNCTION {volume.tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { "\ " }
  if$
  swap$ volumefont * *
}

FUNCTION {tie.or.space.connect.reverse}
{ swap$
  duplicate$ text.length$ #3 <
    { swap$ "~" }
    { swap$ "\ " }
  if$
  swap$ * *
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { series empty$
        { output.state after.block =
            { "\Btxvolumeshort {.}" }
            { "\btxvolumeshort {.}" }
          if$
        }
        { series titlefont }
      if$
      volume volume.tie.or.space.connect
      "volume and number" number either.or.check
    }
  if$
}

FUNCTION {format.number.series}
{ volume empty$
    { number empty$
        { series field.or.null }
        { series empty$
            { "there's a number but no series in " cite$ * warning$
              ""
            }
            { series }
          if$
          number tie.or.space.connect
        }
      if$
    }
    { "" }
  if$
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    {
      output.state mid.sentence =
        { edition "l" change.case$ }
        { edition "t" change.case$ }
      if$
      "\btxeditionnumshort {" swap$ *
      "}{.}" *
    }
  if$
}

FUNCTION {format.isbn}
{ isbn empty$
    { "" }
    { "\mbox{\btxISBN~\btxISBNfont {" isbn * "}}" * }
  if$
}

FUNCTION {format.issn}
{ issn empty$
    { "" }
    { "\mbox{\btxISSN~\btxISSNfont {" issn * "}}" * }
  if$
}

% selectlanguage adds a space after the text due to a bug in finnish.ldf, so use foreignlanguage to not get a space before the comma
FUNCTION {format.howpublished}
{ howpublished empty$
    { "" }
    { "\expandafter\foreignlanguage\expandafter {\biblanguagename}{" howpublished * "}" * }
  if$
}

FUNCTION {format.note}
{ note empty$
    { "" }
    { "\expandafter\foreignlanguage\expandafter {\btxfallbacklanguage}{" note * "}" * }
  if$
}

FUNCTION {format.urldate}
{ urldate empty$
    { "" }
    { " (\btxurldatecomment {\btxurldatefont{" urldate * "}})" * }
  if$
}

FUNCTION {format.url}
{ url empty$
    { "" }
    { "{\expandafter\selectlanguage\expandafter {\btxfallbacklanguage}\btxurlcomment{}" format.urldate * ": {\latintext \btxurlfont{" * url * "}}}" * } 
  if$
}
FUNCTION {write.annote}
{ annote empty$
  'skip$
  {
    annotelanguage empty$
    { "\btxkeywordlanguage {" }
    { "{\selectlanguage {" annotelanguage * "}" * }
    if$
    "\btxannotation {" * annote * "}}" *
    write$ newline$
  }
  if$
}
INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
        { #1 'multiresult := }
        { t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
        { "\btxpagesshort {.}" pages n.dashify tie.or.space.connect }
        { "\btxpageshort {.}" pages tie.or.space.connect }
      if$
    }
  if$
}

FUNCTION {format.numpages.numappendixpages}
{ numpages empty$
  pagetotal empty$
  and
    { numappendixpages empty$
        { "" }
        {"there's a numappendixpages but no numpages in " cite$ * warning$ }
      if$
    }
    { numpages empty$
        { pagetotal "\btxpageshort {.}" tie.or.space.connect.reverse }
        { numpages "\btxpageshort {.}" tie.or.space.connect.reverse
          "numpages and pagetotal" pagetotal either.or.check
        }
      if$
      numappendixpages empty$
        'skip$
        { " + \btxappendicesshort{.} " * numappendixpages "\btxpageshort{.}" tie.or.space.connect.reverse * }
      if$
    }
  if$
}

% The babelbib vocabulary contains no distinct word for "volume" in the "set of issues" sense, so we'll have to define our own. Patch submitted to babelbib maintainer with the new vocabulary Sep 2017
FUNCTION {format.jvolume}
{ volume empty$
    { "" }
    { output.state after.block = 
        { "\Btxjvolumeshort {.}" volume tie.or.space.connect }
        { "\btxjvolumeshort {.}" volume tie.or.space.connect }
      if$
    }
  if$
}

FUNCTION {format.jnumber}
{ number empty$
    { "" }
    { output.state after.block = 
        { "\Btxnumbershort {.}" number tie.or.space.connect }
        { "\btxnumbershort {.}" number tie.or.space.connect }
      if$
    }
  if$
}

FUNCTION {format.chapter}
{ chapter empty$
    { "" }
    { type empty$
        { output.state mid.sentence =
            { "\btxchapterlong {.}" }
            { "\Btxchapterlong {.}" }
          if$
        }
        { type }
      if$
      chapter tie.or.space.connect
    }
  if$
}

FUNCTION {format.title.chapter}
{ title empty$
    { "" }
    { chapter empty$
        { format.jtitle }
        { format.jtitle " -- " * format.chapter * }
      if$
    }
  if$
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
        { "\btxchapterlong {.}" }
        { type }
      if$
      chapter tie.or.space.connect
      pages empty$
        'skip$
        { ", " * format.pages * }
      if$
    }
  if$
}

FUNCTION {format.in}
{ output.state mid.sentence =
    { "\btxinshort {.}:\ " }
    { "\Btxinshort {.}:\ " }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { format.in
      editor empty$
        { format.booktitle * }
        { format.editors * ", " * format.booktitle * }
      if$
    }
  if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
  key empty$ not and
    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      "\expandafter\foreignlanguage\expandafter {\biblanguagename}{" type * "}" * 
    }
  if$
}

FUNCTION {format.tr.number}
{
  number empty$
  {
    type empty$
      { "\btxtechrepshort {.}" }
      { type }
    if$
  }
  {
    type empty$
      { "\Btxtechrepshort {.}" }
      { type }
    if$
    number tie.or.space.connect
  }
  if$
}

FUNCTION {format.conferenceplace}
{ venue empty$
    { address empty$
        { "" }
        { address }
      if$
    }
    { venue
      "venue and address" address either.or.check
    }
  if$
}

FUNCTION {format.title.place.date}
{
  title empty$
    { "" }
    {
      venue empty$
      address empty$
      and
        { "there's no conference place in " cite$ * warning$
          title
        }
        { title ", " * format.conferenceplace * }
      if$
      year empty$
        { "there's no year in " cite$ * warning$ }
        { ", " * format.date * }
      if$
    }
  if$
}

FUNCTION {format.title.organization.place.date}
{
  title empty$
    { "" }
    {
      organization empty$
        { title }
        { title ", " * organization * }
      if$
      venue empty$
      address empty$
      and
        { "there's no conference place in " cite$ * warning$ }
        { ", " * format.conferenceplace * }
      if$
      year empty$
        { "there's no year in " cite$ * warning$ }
        { ", " * format.date * }
      if$
    }
  if$
}

FUNCTION {format.booktitle.organization.place.date}
{
  booktitle empty$
    { "" }
    {
      organization empty$
        { booktitle }
        { booktitle ", " * organization * }
      if$
      venue empty$
      address empty$
      and
        { "there's no conference place in " cite$ * warning$ }
        { ", " * format.conferenceplace * }
      if$
      year empty$
        { "there's no year in " cite$ * warning$ }
        { ", " * format.date * }
      if$
    }
  if$
}

FUNCTION {format.in.proceedings}
{ booktitle empty$
    { "" }
    { editor empty$
        { format.in }
        { format.in format.editors * ", " * }
      if$
      format.booktitle.organization.place.date titlefont *
    }
  if$
}

FUNCTION {format.article.crossref}
{ key empty$
    { journal empty$
        { "need key or journal for " cite$ * " to crossref " * crossref *
          warning$
          ""
        }
        { format.in journal titlefont * }
      if$
    }
    { format.in key titlefont * }
  if$
  year empty$
    { " \cite{" * crossref * "}" * }
    { ", " * year * " \cite{" * crossref * "}" * }
  if$
}

FUNCTION {format.crossref.editor}
{
  editor #1 "{ll}{,~jj}{,~f.}{~vv}" format.name$ namefont
  editor num.names$ duplicate$
  #2 >
    { pop$ " " "\btxetalshort {.}" etalfont * * }
    { #2 <
        'skip$
        { editor #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
            { " " "\btxetalshort {.}" etalfont * * }
            { ", " * editor #2 "{vv~}{ll}"
              format.name$ namefont * }
          if$
        }
      if$
    }
  if$
  editor num.names$ #1 >
    { "\ (\btxeditorsshort {.})" * }
    { "\ (\btxeditorshort {.})" * }
  if$
}

FUNCTION {format.book.crossref}
{ volume empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
      "\Btxinshort {.}\ "
    }
    { output.state mid.sentence =
        { "\btxvolumeshort {.}" volume volume.tie.or.space.connect }
        { "\Btxvolumeshort {.}" volume volume.tie.or.space.connect }
      if$ 
      " \btxofseriesshort {.}\ " *
    }
  if$
  editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
        { series empty$
            { "need editor, key, or series for " cite$ * " to crossref " *
              crossref * warning$
              "" *
            }
            { series titlefont * }
          if$
        }
        { key titlefont * }
      if$
    }
    { format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.incoll.inproc.crossref}
{ editor empty$
  editor field.or.null author field.or.null =
  or
    { booktitle empty$
        { key empty$
            { "need editor, booktitle, or key for " cite$ * " to crossref " *
              crossref * warning$
              ""
            }
            { format.in key titlefont * }
          if$
        }
        { type$ "inproceedings" =
% In case we would like to enable lowercasing for book titles, we still want to skip it for conferences
            { format.in booktitle titlefont * }
            { format.in format.booktitle * }
          if$
         }
      if$
    }
    { format.in format.crossref.editor * }
  if$
  year empty$
    { " \cite{" * crossref * "}" * }
    { ", " * year * " \cite{" * crossref * "}" * }
  if$
}

FUNCTION {article}
{ output.bibitem
  format.authors "author" output.check
  after.authors
  format.jtitle "title" output.check
  crossref missing$
    { journal
      title missing$
        { titlefont }
        { journalfont }
      if$
      "journal" output.check
      format.jvolume output
      format.jnumber output
      % Notice that only for article, we print note in the entry language, not in the keyword language
      note output
      format.date "year" output.check
    }
    { format.article.crossref output.nonnull
      note output
    }
  if$
  format.issn "\ifbtxprintISSN" output.isbn
  format.pages output
  new.block
  add.period$
  urldate empty$
    {}
    {format.url output}
  if$
  fin.entry
  write.annote
}

FUNCTION {book}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  after.authors
  format.btitle "title" output.check
  crossref missing$
    { format.edition output
      format.bvolume output
      publisher "publisher" output.check publisherfont
      format.number.series output
      address output
    }
    { format.book.crossref output.nonnull
      format.edition output
    }
  if$
  format.date "year" output.check
  format.isbn "\ifbtxprintISBN" output.isbn
  format.numpages.numappendixpages "numpages" output.check
  new.block
  format.note output
  new.block
  add.period$
  format.url output
  fin.entry
  write.annote
}

FUNCTION {booklet}
{ output.bibitem
  format.authors output
  after.authors
  format.title "title" output.check
  format.howpublished output
  address output
  format.date output
  format.numpages.numappendixpages output
  new.block
  format.note output
  new.block
  add.period$
  format.url output
  fin.entry
  write.annote
}

FUNCTION {inbook}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  after.authors
  format.btitle "title" output.check
  crossref missing$
    { format.edition output
      series empty$
        { format.bvolume output
          format.chapter output
        }
        { format.chapter output
          format.bvolume output
        }
      if$
      publisher "publisher" output.check publisherfont
      format.number.series output
      address output
    }
    { format.chapter.pages "chapter and pages" output.check
      format.book.crossref output.nonnull
      format.edition output
    }
  if$
  format.date "year" output.check
  format.isbn "\ifbtxprintISBN" output.isbn
  format.pages output
  new.block
  format.note output
  new.block
  add.period$
  format.url output
  fin.entry
  write.annote
}

FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check
  after.authors
  format.title.chapter "title" output.check
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.edition output
      format.bvolume output
      publisher "publisher" output.check publisherfont
      format.number.series output
      address output
      format.date "year" output.check
    }
    { format.incoll.inproc.crossref output.nonnull }
  if$
  format.isbn "\ifbtxprintISBN" output.isbn
  format.pages output
  new.block
  format.note output
  new.block
  add.period$
  format.url output
  fin.entry
  write.annote
}

FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check
  after.authors
  format.jtitle "title" output.check
  crossref missing$
    { format.in.proceedings "booktitle" output.check
      format.bvolume output
      publisher publisherfont output
      format.number.series output
      location output
    }
    { format.incoll.inproc.crossref output.nonnull }
  if$
  format.isbn "\ifbtxprintISBN" output.isbn
  format.pages output
  new.block
  format.note output
  new.block
  add.period$
  urldate empty$
    {}
    {format.url output}
  if$
  fin.entry
  write.annote
}

FUNCTION {conference} { inproceedings }

FUNCTION {manual}
{ output.bibitem
  author empty$
    'skip$
    { format.authors output.nonnull
      after.authors
    }
  if$
  format.title "title" output.check
  format.edition output
  author empty$
    {organization "author and organization" output.check}
    {organization output}
  if$
  address output
  format.date output
  format.isbn "\ifbtxprintISBN" output.isbn
  format.numpages.numappendixpages output
  new.block
  format.note output
  new.block
  add.period$
  format.url output
  fin.entry
  write.annote
}

FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  after.authors
  series empty$
    { format.title "title" output.check }
    { format.btitle "title" output.check }
  if$
  "\btxmastthesis {}" format.thesis.type output.nonnull
  school "school" output.check
  format.number.series output
  address output
  format.date "year" output.check
  format.numpages.numappendixpages "numpages" output.check
  new.block
  format.note output
  new.block
  add.period$
  format.url output
  fin.entry
  write.annote
}

FUNCTION {misc}
{ output.bibitem
  format.authors output
  format.title output
  format.howpublished output
  format.date output
  format.isbn "\ifbtxprintISBN" output.isbn
  format.issn "\ifbtxprintISSN" output.isbn
  format.numpages.numappendixpages output
  new.block
  format.note output
  new.block
  add.period$
  format.url output
  fin.entry
  write.annote
  empty.misc.check
}

FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  after.authors
  format.btitle "title" output.check
  "\btxphdthesis {}" format.thesis.type output.nonnull
  school "school" output.check
  format.number.series output
  address output
  format.date "year" output.check
  format.isbn "\ifbtxprintISBN" output.isbn
  format.numpages.numappendixpages "numpages" output.check
  new.block
  format.note output
  new.block
  add.period$
  format.url output
  fin.entry
  write.annote
}

FUNCTION {proceedings}
{ output.bibitem
  editor empty$
    { organization output }
    { format.editors output.nonnull }
  if$
  after.authors
  editor empty$
    { format.title.place.date "title" output.check titlefont }
    { format.title.organization.place.date "title" output.check titlefont }
  if$
  format.bvolume output
  publisher publisherfont output
  format.number.series output
  location output
  format.isbn "\ifbtxprintISBN" output.isbn
  format.numpages.numappendixpages output
  new.block
  format.note output
  new.block
  add.period$
  urldate empty$
    'skip$
    { format.url output }
  if$
  fin.entry
  write.annote
}

FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check
  after.authors
  format.btitle "title" output.check
  institution "institution" output.check
  format.tr.number output.nonnull
  address output
  format.date "year" output.check
  format.isbn "\ifbtxprintISBN" output.isbn
  format.numpages.numappendixpages output
  new.block
  format.note output
  new.block
  add.period$
  format.url output
  fin.entry
  write.annote
}

FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check
  after.authors
  format.title "title" output.check
  format.note "note" output.check
  format.date output
  format.numpages.numappendixpages output
  new.block
  add.period$
  format.url output
  fin.entry
  write.annote
}

FUNCTION {default.type} { misc }

MACRO {jan} {"1"}
MACRO {feb} {"2"}
MACRO {mar} {"3"}
MACRO {apr} {"4"}
MACRO {may} {"5"}
MACRO {jun} {"6"}
MACRO {jul} {"7"}
MACRO {aug} {"8"}
MACRO {sep} {"9"}
MACRO {oct} {"10"}
MACRO {nov} {"11"}
MACRO {dec} {"12"}
MACRO {acmcs} {"ACM Comput.\ Surv.{}"}
MACRO {acta} {"Acta Inf.{}"}
MACRO {cacm} {"Commun. ACM"}
MACRO {ibmjrd} {"IBM J.~Res.\ Dev.{}"}
MACRO {ibmsj} {"IBM Syst.~J.{}"}
MACRO {ieeese} {"IEEE Trans.\ Softw.\ Eng.{}"}
MACRO {ieeetc} {"IEEE Trans.\ Comput.{}"}
MACRO {ieeetcad}
 {"IEEE Trans.\ Comput.-Aided Design Integrated Circuits"}
MACRO {ipl} {"Inf.\ Process.\ Lett.{}"}
MACRO {jacm} {"J.~ACM"}
MACRO {jcss} {"J.~Comput.\ Syst.\ Sci.{}"}
MACRO {scp} {"Sci.\ Comput.\ Programming"}
MACRO {sicomp} {"SIAM J.~Comput.{}"}
MACRO {tocs} {"ACM Trans.\ Comput.\ Syst.{}"}
MACRO {tods} {"ACM Trans.\ Database Syst.{}"}
MACRO {tog} {"ACM Trans.\ Gr.{}"}
MACRO {toms} {"ACM Trans.\ Math.\ Softw.{}"}
MACRO {toois} {"ACM Trans.\ Office Inf.\ Syst.{}"}
MACRO {toplas} {"ACM Trans.\ Prog.\ Lang.\ Syst.{}"}
MACRO {tcs} {"Theoretical Comput.\ Sci.{}"}

READ

FUNCTION {sortify}
{ purify$
  "l" change.case$
}

INTEGERS { len }

FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}

FUNCTION {sort.format.names}
{ 's :=
  #1 'nameptr :=
  ""
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { nameptr #1 >
        { "   " * }
        'skip$
      if$
      s nameptr "{ll{ }}{  f{ }}{vv{ } }{  jj{ }}" format.name$ 't :=
      nameptr numnames = t "others" = and
        { "et al" * }
        { t sortify * }
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {sort.format.title}
{ 't :=
  "A " #2
    "An " #3
      "The " #4 t chop.word
    chop.word
  chop.word
  sortify
  #1 global.max$ substring$
}

FUNCTION {author.sort}
{ author empty$
    { key empty$
        { title empty$
            { "to sort, need author, key or title in " cite$ * warning$
              ""
            }
            { title sort.format.title }
            if$
        }
        { key sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.editor.sort}
{ author empty$
    { editor empty$
        { key empty$
            { title empty$
                { "to sort, need author, editor, key or title in " cite$ * warning$ 
                  ""
                }
                { title sort.format.title }
              if$
            }
            { key sortify }
          if$
        }
        { editor sort.format.names }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {editor.organization.sort}
{ editor empty$
    { organization empty$
        { key empty$
            { title empty$
                { "to sort, need editor, organization, or key in " cite$ * warning$
                  ""
                }
                { title sort.format.title }
              if$
            }
            { key sortify }
          if$
        }
        { "The " #4 organization chop.word sortify }
      if$
    }
    { editor sort.format.names }
  if$
}

FUNCTION {journal.sort}
{ journal empty$
    { key empty$
        { "to sort, need author, title or journal in " cite$ * warning$
          ""
        }
        { key sortify }
      if$
    }
    { journal sort.format.title }
  if$
}

FUNCTION {presort}
{
  type$ "book" =
  type$ "inbook" =
  or
    'author.editor.sort
    { type$ "proceedings" =
        'editor.organization.sort
        { author empty$
          title empty$
          and
          type$ "article" =
          and
            'journal.sort
            'author.sort
          if$
        }
      if$
    }
  if$
  "    "
  *
  year field.or.null sortify
  *
  "    "
  *
  title field.or.null
  sort.format.title
  *
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {presort}

SORT

STRINGS { longest.label }

INTEGERS { number.label longest.label.width }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #1 'number.label :=
  #0 'longest.label.width :=
}

FUNCTION {longest.label.pass}
{ number.label int.to.str$ 'label :=
  number.label #1 + 'number.label :=
  label width$ longest.label.width >
    { label 'longest.label :=
      label width$ 'longest.label.width :=
    }
    'skip$
  if$
}

EXECUTE {initialize.longest.label}

ITERATE {longest.label.pass}

FUNCTION {begin.bib}
{
  preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{"  longest.label  * "}" * write$ newline$
  "  \providebibliographyfont{name}{}%" write$ newline$
  "  \providebibliographyfont{lastname}{}%" write$ newline$
  "  \providebibliographyfont{title}{}%" write$ newline$
  "  \providebibliographyfont{jtitle}{}%" write$ newline$
  "  \providebibliographyfont{etal}{\emph}%" write$ newline$
  "  \providebibliographyfont{journal}{}%" write$ newline$
  "  \providebibliographyfont{volume}{}%" write$ newline$
  "  \providebibliographyfont{ISBN}{\MakeUppercase}%" write$ newline$
  "  \providebibliographyfont{ISSN}{\MakeUppercase}%" write$ newline$
  "  \providebibliographyfont{url}{\url}%" write$ newline$
  "  \providebibliographyfont{urldate}{\tformatdate}%" write$ newline$
  "  \providebibliographyfont{numeral}{}%" write$ newline$

  "  \renewcommand\btxauthorcolon{,}%" write$ newline$

  "  \def\tformatdate#1{\@tformatdate #1\stopmark}%" write$ newline$
  "  \def\@tformatdate #1-#2-#3\stopmark{\number#3\relax.\number#2\relax.#1}%" write$ newline$

  "  \let\oldprintmonthyear\btxprintmonthyear%" write$ newline$
  "  \def\btxprintmonthyear#1#2#3#4{\ifnumber{#2}{\oldprintmonthyear{#1}{#2}{#3}{#4}}{#2,\ #3}}%" write$ newline$

  "  \expandafter\btxselectlanguage\expandafter {\btxfallbacklanguage}%" write$ newline$

% Something strange happens with arguments inside the addto depending on whether the babelbib language is loaded, so we will wrap the language definitions in conditional blocks

  "  \ifx\datefinnish\undefined\else\addto\bibsfinnish{%" write$ newline$
  % The Finnish translation has some typos and poor style. Patch submitted to maintainer Sep 2017
  "    \renewcommand{\Btxvolumeshort}[1]{\protect\foreignlanguage{\biblanguagename}{Nide}}%" write$ newline$
  "    \renewcommand{\btxnumbershort}[1]{\protect\foreignlanguage{\biblanguagename}{nro}}%" write$ newline$
  "    \renewcommand{\Btxnumbershort}[1]{\protect\foreignlanguage{\biblanguagename}{Nro}}%" write$ newline$
  "    \let\btxpagesshort\btxpageshort%" write$ newline$
  "    \let\Btxpagesshort\Btxpageshort%" write$ newline$
  "    \renewcommand{\btxmastthesis}[1]{\protect\foreignlanguage{\biblanguagename}{pro gradu -ty\" write$ quote$ write$ "o}}%" write$ newline$
  "    \renewcommand{\btxurldatecomment}[1]{\protect\foreignlanguage{\biblanguagename}{viitattu #1}}%" write$ newline$
  "    \def\btxjvolumeshort#1{\protect\foreignlanguage{\biblanguagename}{vsk#1{}}}%" write$ newline$
  "    \def\Btxjvolumeshort#1{\protect\foreignlanguage{\biblanguagename}{Vsk#1{}}}%" write$ newline$
  "    \def\btxappendicesshort#1{\protect\foreignlanguage{\biblanguagename}{liitt#1{}}}%" write$ newline$
  "    \def\btxurlcomment#1{\protect\foreignlanguage{\biblanguagename}{Saatavissa}}%" write$ newline$
  "  }\fi%" write$ newline$

  "  \ifx\dateenglish\undefined\else\addto\bibsenglish{%" write$ newline$
  "    \let\btxvolumeshort\Btxvolumeshort%" write$ newline$
  "    \renewcommand{\btxnumbershort}[1]{\protect\foreignlanguage{\biblanguagename}{Iss#1{}}}%" write$ newline$
  "    \let\Btxnumbershort\btxnumbershort%" write$ newline$
  "    \let\btxchapterlong\Btxchapterlong%" write$ newline$
  "    \renewcommand{\btxmastthesis}[1]{\protect\foreignlanguage{\biblanguagename}{master's thesis}}%" write$ newline$
  "    \renewcommand{\btxphdthesis}[1]{\protect\foreignlanguage{\biblanguagename}{dissertation}}%" write$ newline$
  "    \renewcommand{\btxurldatecomment}[1]{\protect\foreignlanguage{\biblanguagename}{accessed on #1}}%" write$ newline$
  "    \let\btxjvolumeshort\Btxvolumeshort%" write$ newline$
  "    \let\Btxjvolumeshort\Btxvolumeshort%" write$ newline$
  "    \def\btxappendicesshort#1{\protect\foreignlanguage{\biblanguagename}{app#1{}}}%" write$ newline$
  "    \def\btxurlcomment#1{\protect\foreignlanguage{\biblanguagename}{Available}}%" write$ newline$
  "  }\fi%" write$ newline$

  "  \ifx\dateafrikaans\undefined\else\addto\bibsafrikaans{\renewcommand{\btxandshort}[1]{\protect\foreignlanguage{\biblanguagename}{\&}}%" write$ newline$
  "    \renewcommand{\btxmastthesis}[1]{\protect\foreignlanguage{\biblanguagename}{magistertesis}}%" write$ newline$
  "    \def\btxjvolumeshort#1{\protect\foreignlanguage{\biblanguagename}{jg#1{}}}\def\Btxjvolumeshort#1{\protect\foreignlanguage{\biblanguagename}{Jg#1{}}}%" write$ newline$
  "    \def\btxappendicesshort#1{\protect\foreignlanguage{\biblanguagename}{byl#1{}}}}\fi%" write$ newline$

  "  \ifx\datebahasa\undefined\else\addto\bibsbahasa{\renewcommand{\btxandshort}[1]{\protect\foreignlanguage{\biblanguagename}{\&}}%" write$ newline$
  "    \let\btxjvolumeshort\btxvolumeshort\let\Btxjvolumeshort\Btxvolumeshort%" write$ newline$
  "    \def\btxappendicesshort#1{\protect\foreignlanguage{\biblanguagename}{lamp#1{}}}}\fi%" write$ newline$

  "  \ifx\datecatalan\undefined\else\addto\bibscatalan{\renewcommand{\btxandshort}[1]{\protect\foreignlanguage{\biblanguagename}{\&}}%" write$ newline$
  "    \renewcommand{\btxmastthesis}[1]{\protect\foreignlanguage{\biblanguagename}{tesis de m\'{a}ster}}\renewcommand{\btxphdthesis}[1]{\protect\foreignlanguage{\biblanguagename}{tesis doctoral}}%" write$ newline$
  "    \let\btxjvolumeshort\btxvolumeshort\let\Btxjvolumeshort\Btxvolumeshort%" write$ newline$
  "    \def\btxappendicesshort#1{\protect\foreignlanguage{\biblanguagename}{ap#1{}}}}\fi%" write$ newline$

  "  \ifx\datecroatian\undefined\else\addto\bibscroatian{\renewcommand{\btxandshort}[1]{\protect\foreignlanguage{\biblanguagename}{\&}}%" write$ newline$
  "    \renewcommand{\btxmastthesis}[1]{\protect\foreignlanguage{\biblanguagename}{magistarski rad}}\renewcommand{\btxphdthesis}[1]{\protect\foreignlanguage{\biblanguagename}{disertacija}}%" write$ newline$
  "    \def\btxjvolumeshort#1{\protect\foreignlanguage{\biblanguagename}{god#1{}}}\def\Btxjvolumeshort#1{\protect\foreignlanguage{\biblanguagename}{God#1{}}}%" write$ newline$
  "    \def\btxappendicesshort#1{\protect\foreignlanguage{\biblanguagename}{dod#1{}}}}\fi%" write$ newline$

  "  \ifx\dateczech\undefined\else\addto\bibsczech{\renewcommand{\btxandshort}[1]{\protect\foreignlanguage{\biblanguagename}{\&}}%" write$ newline$
  "    \def\btxjvolumeshort#1{\protect\foreignlanguage{\biblanguagename}{ro\v{c}#1{}}}\def\Btxjvolumeshort#1{\protect\foreignlanguage{\biblanguagename}{Ro\v{c}#1{}}}%" write$ newline$
  "    \def\btxappendicesshort#1{\protect\foreignlanguage{\biblanguagename}{dod#1{}}}}\fi%" write$ newline$

  "  \ifx\datedanish\undefined\else\addto\bibsdanish{\renewcommand{\btxandshort}[1]{\protect\foreignlanguage{\biblanguagename}{\&}}%" write$ newline$
  "    \renewcommand{\btxmastthesis}[1]{\protect\foreignlanguage{\biblanguagename}{speciale}}%" write$ newline$
  "    \def\Btxjvolumeshort#1{\protect\foreignlanguage{\biblanguagename}{\AA rg#1{}}}\def\Btxjvolumeshort#1{\protect\foreignlanguage{\biblanguagename}{\aa rg#1{}}}%" write$ newline$
  "    \def\btxappendicesshort#1{\protect\foreignlanguage{\biblanguagename}{bil#1{}}}}\fi%" write$ newline$

  "  \ifx\datedutch\undefined\else\addto\bibsdutch{\renewcommand{\btxandshort}[1]{\protect\foreignlanguage{\biblanguagename}{\&}}%" write$ newline$
  "    \def\btxjvolumeshort#1{\protect\foreignlanguage{\biblanguagename}{jrg#1{}}}\def\Btxjvolumeshort#1{\protect\foreignlanguage{\biblanguagename}{Jrg#1{}}}%" write$ newline$
  "    \def\btxappendicesshort#1{\protect\foreignlanguage{\biblanguagename}{b\ijl#1{}}}}\fi%" write$ newline$

  "  \ifx\dateesperanto\undefined\else\addto\bibsesperanto{\renewcommand{\btxandshort}[1]{\protect\foreignlanguage{\biblanguagename}{\&}}%" write$ newline$
  "    \let\btxjvolumeshort\btxvolumeshort\let\Btxjvolumeshort\Btxvolumeshort%" write$ newline$
  "    \def\btxappendicesshort#1{\protect\foreignlanguage{\biblanguagename}{ap#1{}}}}\fi%" write$ newline$

  "  \ifx\datefrench\undefined\else\addto\bibsfrench{\renewcommand{\btxandshort}[1]{\protect\foreignlanguage{\biblanguagename}{\&}}%" write$ newline$
  "    \renewcommand{\btxmastthesis}[1]{\protect\foreignlanguage{\biblanguagename}{m\'emoire de ma\^itrise}}\renewcommand{\btxphdthesis}[1]{\protect\foreignlanguage{\biblanguagename}{th\`ese de doctorat}}%" write$ newline$
  "    \def\btxjvolumeshort#1{\protect\foreignlanguage{\biblanguagename}{vol#1{}}}\def\Btxjvolumeshort#1{\protect\foreignlanguage{\biblanguagename}{Vol#1{}}}%" write$ newline$
  "    \def\btxappendicesshort#1{\protect\foreignlanguage{\biblanguagename}{ann#1{}}}}\fi%" write$ newline$

  "  \ifx\dategalician\undefined\else\addto\bibsgalician{\renewcommand{\btxandshort}[1]{\protect\foreignlanguage{\biblanguagename}{\&}}%" write$ newline$
  "    \renewcommand{\btxmastthesis}[1]{\protect\foreignlanguage{\biblanguagename}{tese de licenciatura}}\renewcommand{\btxphdthesis}[1]{\protect\foreignlanguage{\biblanguagename}{tese de doutoramento}}%" write$ newline$
  "    \let\btxjvolumeshort\btxvolumeshort\let\Btxjvolumeshort\Btxvolumeshort%" write$ newline$
  "    \def\btxappendicesshort#1{\protect\foreignlanguage{\biblanguagename}{ap#1{}}}}\fi%" write$ newline$

  "  \ifx\dategerman\undefined\else\addto\bibsgerman{\renewcommand{\btxandshort}[1]{\protect\foreignlanguage{\biblanguagename}{\&}}%" write$ newline$
  "    \renewcommand{\btxinshort}[1]{\protect\foreignlanguage{\biblanguagename}{in}}\renewcommand{\Btxinshort}[1]{\protect\foreignlanguage{\biblanguagename}{In}}%" write$ newline$
  "    \def\btxjvolumeshort#1{\protect\foreignlanguage{\biblanguagename}{Jg#1{}}}\def\Btxjvolumeshort#1{\protect\foreignlanguage{\biblanguagename}{Jg#1{}}}%" write$ newline$
  "    \def\btxappendicesshort#1{\protect\foreignlanguage{\biblanguagename}{Anh#1{}}}}\fi%" write$ newline$

  "  \ifx\dategreek\undefined\else\addto\bibsgreek{\renewcommand{\btxandshort}[1]{\protect\foreignlanguage{\biblanguagename}{\kai}}%" write$ newline$
  "    \renewcommand{\btxmastthesis}[1]{\protect\foreignlanguage{\biblanguagename}{metaptuqiak'h ergas'ia}}\renewcommand{\btxphdthesis}[1]{\protect\foreignlanguage{\biblanguagename}{didaktorik'h diatrib'h}}%" write$ newline$
  "    \def\btxjvolumeshort#1{\protect\foreignlanguage{\biblanguagename}{'et#1{}}}\def\Btxjvolumeshort#1{\protect\foreignlanguage{\biblanguagename}{'Et#1{}}}%" write$ newline$
  "    \def\btxappendicesshort#1{\protect\foreignlanguage{\biblanguagename}{par#1{}}}}\fi%" write$ newline$

  "  \ifx\dateitalian\undefined\else\addto\bibsitalian{\renewcommand{\btxandshort}[1]{\protect\foreignlanguage{\biblanguagename}{\&}}%" write$ newline$
  "    \let\btxjvolumeshort\btxvolumeshort\let\Btxjvolumeshort\Btxvolumeshort%" write$ newline$
  "    \def\btxappendicesshort#1{\protect\foreignlanguage{\biblanguagename}{app#1{}}}}\fi%" write$ newline$

  "  \ifx\datenorsk\undefined\else\addto\bibsnorsk{\renewcommand{\btxandshort}[1]{\protect\foreignlanguage{\biblanguagename}{\&}}%" write$ newline$
  "    \renewcommand{\btxmastthesis}[1]{\protect\foreignlanguage{\biblanguagename}{masteroppgave}}%" write$ newline$
  "    \def\btxjvolumeshort#1{\protect\foreignlanguage{\biblanguagename}{vol#1{}}}\def\Btxjvolumeshort#1{\protect\foreignlanguage{\biblanguagename}{Vol#1{}}}%" write$ newline$
  "    \def\btxappendicesshort#1{\protect\foreignlanguage{\biblanguagename}{till#1{}}}}\fi%" write$ newline$

  "  \ifx\dateportuguese\undefined\else\addto\bibsportuguese{\renewcommand{\btxandshort}[1]{\protect\foreignlanguage{\biblanguagename}{\&}}%" write$ newline$
  "    \renewcommand{\btxmastthesis}[1]{\protect\foreignlanguage{\biblanguagename}{tese de mestrado}}\renewcommand{\btxphdthesis}[1]{\protect\foreignlanguage{\biblanguagename}{tese de doutoramento}}%" write$ newline$
  "    \let\btxjvolumeshort\btxvolumeshort\let\Btxjvolumeshort\Btxvolumeshort%" write$ newline$
  "    \def\btxappendicesshort#1{\protect\foreignlanguage{\biblanguagename}{ap#1{}}}}\fi%" write$ newline$

  "  \ifx\dateromanian\undefined\else\addto\bibsromanian{\renewcommand{\btxandshort}[1]{\protect\foreignlanguage{\biblanguagename}{\&}}%" write$ newline$
  "    \renewcommand{\btxmastthesis}[1]{\protect\foreignlanguage{\biblanguagename}{tez\~{a} de masterat}}\renewcommand{\btxphdthesis}[1]{\protect\foreignlanguage{\biblanguagename}{tez\~{a} de doctorat}}%" write$ newline$
  "    \def\btxjvolumeshort#1{\protect\foreignlanguage{\biblanguagename}{an}}\def\Btxjvolumeshort#1{\protect\foreignlanguage{\biblanguagename}{An}}%" write$ newline$
  "    \def\btxappendicesshort#1{\protect\foreignlanguage{\biblanguagename}{an#1{}}}}\fi%" write$ newline$

  "  \ifx\daterussian\undefined\else\addto\bibsrussian{%" write$ newline$
  "    \renewcommand{\btxmastthesis}[1]{\protect\foreignlanguage{\biblanguagename}{\IeC {\cyrd }\IeC {\cyri }\IeC {\cyrp }\IeC {\cyrl }\IeC {\cyro }\IeC {\cyrm } \IeC {\cyrm }\IeC {\cyra }\IeC {\cyrg }\IeC {\cyri }\IeC {\cyrs }\IeC {\cyrt }\IeC {\cyrr }\IeC {\cyra }}}%" write$ newline$
  "    \renewcommand{\btxphdthesis}[1]{\protect\foreignlanguage{\biblanguagename}{\IeC {\cyrk }\IeC {\cyra }\IeC {\cyrn }\IeC {\cyrd }\IeC {\cyri }\IeC {\cyrd }\IeC {\cyra }\IeC {\cyrt }\IeC {\cyrs }\IeC {\cyrk }\IeC {\cyra }\IeC {\cyrya } \IeC {\cyrd }\IeC {\cyri }\IeC {\cyrs }\IeC {\cyrs }\IeC {\cyre }\IeC {\cyrr }\IeC {\cyrt }\IeC {\cyra }\IeC {\cyrc }\IeC {\cyri }\IeC {\cyrya }}}%" write$ newline$
  "    \let\btxjvolumeshort\btxvolumeshort\let\Btxjvolumeshort\Btxvolumeshort%" write$ newline$
  "    \def\btxappendicesshort#1{\protect\foreignlanguage{\biblanguagename}{\cryp\cyrr#1{}}}}\fi%" write$ newline$

  "  \ifx\dateserbian\undefined\else\addto\bibsserbian{renewcommand{\btxandshort}[1]{\protect\foreignlanguage{\biblanguagename}{\&}}%" write$ newline$
  "    \renewcommand{\btxinshort}[1]{\protect\foreignlanguage{\biblanguagename}{u}}\renewcommand{\Btxinshort[1]{\protect\foreignlanguage{\biblanguagename}{U}}}%" write$ newline$
  "    \renewcommand{\btxmastthesis}[1]{\protect\foreignlanguage{\biblanguagename}{tez\~{a} de masterat}}\renewcommand{\btxphdthesis}[1]{\protect\foreignlanguage{\biblanguagename}{tez\~{a} de doctorat}}%" write$ newline$
  "    \def\btxjvolumeshort#1{\protect\foreignlanguage{\biblanguagename}{god#1{}}}\def\Btxjvolumeshort#1{\protect\foreignlanguage{\biblanguagename}{God#1{}}}%" write$ newline$
  "    \def\btxappendicesshort#1{\protect\foreignlanguage{\biblanguagename}{dod#1{}}}}\fi%" write$ newline$

  "  \ifx\datespanish\undefined\else\addto\bibsspanish{\renewcommand{\btxandshort}[1]{\protect\foreignlanguage{\biblanguagename}{\&}}%" write$ newline$
  "    \renewcommand{\btxmastthesis}[1]{\protect\foreignlanguage{\biblanguagename}{tesis de maestr\'ia}}\renewcommand{\btxphdthesis}[1]{\protect\foreignlanguage{\biblanguagename}{tesis doctoral}}%" write$ newline$
  "    \let\btxjvolumeshort\btxvolumeshort\let\Btxjvolumeshort\Btxvolumeshort%" write$ newline$
  "    \def\btxappendicesshort#1{\protect\foreignlanguage{\biblanguagename}{ap#1{}}}}\fi%" write$ newline$

  "  \ifx\dateswedish\undefined\else\addto\bibsswedish{\renewcommand{\btxandshort}[1]{\protect\foreignlanguage{\biblanguagename}{\&}}%" write$ newline$
  "    \let\btxjvolumeshort\btxvolumeshort\let\Btxjvolumeshort\Btxvolumeshort%" write$ newline$
  "    \def\btxappendicesshort#1{\protect\foreignlanguage{\biblanguagename}{bil#1{}}}}\fi%" write$ newline$

  "  \ifbbbbfixlanguage\selectbiblanguage{\biblanguagename}\fi%" write$ newline$ % we added to the language definitions, but we need to do a reload to ensure the additions are in effect
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}
