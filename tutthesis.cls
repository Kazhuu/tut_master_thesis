%%
%% Document class for TUT theses
%% According to the Thesis Writing Guide 2017-01-09
%% Author: Timo Kalliomaki
%% Based on the standard LaTeX report.cls v1.4h and some parts of the older thesis class by Sami Paavilainen and Erno Salminen
%%
%% This document class is in no way normative and any clear contradictions
%% with the guide should be considered mistakes in this class.
%% --------------------------------------------------------------
%% 
%% It may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either version 1.3c
%% of this license or (at your option) any later version.
%% The latest version of this license is in
%%    http://www.latex-project.org/lppl.txt
%% and version 1.3c or later is part of all distributions of LaTeX
%% version 2005/12/01 or later.

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{tutthesis}
              [2017/10/16 v0.98b
 TUT thesis document class]

% 0.98b: fix translated keywords

% Document class options
% ---------------------


\newif\if@draftfooter
\@draftfooterfalse

\newif\if@numperchapter
\@numperchaptertrue

\newif\if@centeredcaptions
\@centeredcaptionsfalse

\DeclareOption{a4paper}
   {\ClassWarning{tutthesis}{Page size always A4. Option ignored.}}
\DeclareOption{a5paper}
   {\ClassWarning{tutthesis}{Unsupported paper size a5paper}}
\DeclareOption{b5paper}
   {\ClassWarning{tutthesis}{Unsupported paper size b5paper}}
\DeclareOption{letterpaper}
   {\ClassWarning{tutthesis}{Unsupported paper size letterpaper}}
\DeclareOption{legalpaper}
   {\ClassWarning{tutthesis}{Unsupported paper size legalpaper}}
\DeclareOption{executivepaper}
   {\ClassWarning{tutthesis}{Unsupported paper size executivepaper}}
\DeclareOption{landscape}
   {\ClassWarning{tutthesis}{Unsupported paper size landscape}}

\DeclareOption{10pt}{\ClassWarning{tutthesis}{Unsupported font size 10pt}}
\DeclareOption{11pt}{\ClassWarning{tutthesis}{Unsupported font size 11pt}}
\DeclareOption{12pt}{\ClassWarning{tutthesis}{Main font size always 12pt. Option ignored.}}

\DeclareOption{draft}{\@draftfootertrue\PassOptionsToClass{draft}{report}}
\DeclareOption{final}{\@draftfooterfalse\PassOptionsToClass{final}{report}}

\DeclareOption{titlepage}{\ClassWarning{tutthesis}{Title page always used. Option ignored.}}
\DeclareOption{notitlepage}{\ClassWarning{tutthesis}{Title page always used.}}
\DeclareOption{openright}{\ClassWarning{tutthesis}{Forcing chapters to start on right page is unsupported.}}
\DeclareOption{openany}{\ClassWarning{tutthesis}{Chapters always permitted to start on left page. Option ignored.}}
\DeclareOption{onecolumn}{\ClassWarning{tutthesis}{Layout always one-column. Option ignored.}}
\DeclareOption{twocolumn}{\ClassWarning{tutthesis}{Two-column layout unsupported.}}

\DeclareOption{leqno}{\ClassWarning{tutthesis}{Equation numbers on the left unsupported.}}
\DeclareOption{fleqn}{\ClassWarning{tutthesis}{Equations always on left. Option ignored.}}

\DeclareOption{draftfooter}{\@draftfootertrue}
\DeclareOption{globalnumbering}{\@numperchapterfalse}
\DeclareOption{centeredcaptions}{\@centeredcaptionstrue}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}

\ProcessOptions

\LoadClass[a4paper,12pt,titlepage,openany,onecolumn,fleqn]{report}

\newcommand{\g@prepto@macro}[2]{%
  \begingroup
    \@temptokena{#2}%
    \toks@\expandafter{#1}%
    \xdef#1{\the\@temptokena\the\toks@}%
  \endgroup}

% EndPreamble from etoolbox will precede this if used
\let\@preambleendhook\@empty
\@onlypreamble{\@preambleendhook}
\g@prepto@macro{\document}{%
  \endgroup
  \let\@AtPreambleEnd\@firstofone
  \@preambleendhook
  \global\let\@preambleendhook\@undefined
  \begingroup}
\newcommand*{\@AtPreambleEnd}{\g@addto@macro{\@preambleendhook}}
\@onlypreamble{\@AtPreambleEnd}

\RequirePackage{ifpdf}
\let\@ifpdf\ifpdf % pdfx bug (reported Sep 2017): it will leave ifpdf as false for luatex
\RequirePackage{ifluatex}

% Dates and PDF metadata
% -----------------

% When pdfx is loaded, this file needs to exist. We don't know yet whether the user will load pdfx, so let's just always write this
\newwrite\xmpdatafile
\immediate\openout\xmpdatafile=\jobname.xmpdata
\immediate\write\xmpdatafile{%
  \noexpand\if@author@given\noexpand\Author{\noexpand\@author}\noexpand\fi
  \noexpand\if@title@given\noexpand\Title{\noexpand\@title}\noexpand\fi
  \noexpand\if@keywords@given\noexpand\Keywords{\noexpand\@XMPKeywords}\noexpand\fi
  \noexpand\if@subjectcomplete\noexpand\Subject{\noexpand\@Subject}\noexpand\fi
  \noexpand\@metadatawritehook
  \noexpand\pdfxEnableCommands{\noexpand\let\noexpand\NoCaseChange\noexpand\@firstofone}
}
\newcommand*{\@fixifpdf}{\noexpand\global\noexpand\let\noexpand\ifpdf\noexpand\@ifpdf}%\noexpand\if... breaks inside an untaken if switch
\ifluatex
  \immediate\write\xmpdatafile{\noexpand\pdfxEnableCommands{\@fixifpdf}}
\fi
\immediate\closeout\xmpdatafile


\newcommand*{\@InitializeField}[1]{
  \expandafter\newif\csname if@#1@given\endcsname
  \csname @#1@givenfalse\endcsname
  \expandafter\newcommand\expandafter*\csname @#1@givenhook\endcsname{\relax} % run once, for the main language
}
\@onlypreamble{\@InitializeField}

\newcommand*{\@@DeclareField}[1]{%
  \expandafter\newcommand\expandafter*\csname @#1\endcsname{\ClassWarning{tutthesis}{No #1 given}}
  \@InitializeField{#1}
}
\@onlypreamble{\@@DeclareField}

\newcommand*{\@DeclareField}[1]{%
  \@@DeclareField{#1}
  \expandafter\newcommand\expandafter*\csname #1\endcsname[1]{%
    \expandafter\renewcommand\expandafter*\csname @#1\endcsname{##1}%
    \csname @#1@giventrue\endcsname%
    \csname @#1@givenhook\endcsname%
  }
}
\@onlypreamble{\@DeclareField}

\newcommand*{\@DeclareDateField}[1]{
  \@@DeclareField{#1}
  \expandafter\newcommand\expandafter*\csname #1\endcsname[3]{%
    \ifnum ##1<1970 \ClassError{tutthesis}{Invalid year in #1}{}%
    \else\ifnum ##1>9999 \ClassError{tutthesis}{Invalid year in #1}{}%
    \else\ifnum ##2<1 \ClassError{tutthesis}{Invalid month in #1}{}%
    \else\ifnum ##2>12 \ClassError{tutthesis}{Invalid month in #1}{}%
    \else\ifnum ##3<1 \ClassError{tutthesis}{Invalid day in #1}{}%
    \else\ifnum ##3>31 \ClassError{tutthesis}{Invalid day in #1}{}%
    \else%
      \edef\@tempdate{##1-\ifnum ##2<10 0\fi\number##2-\ifnum ##3<10 0\fi\number##3}%
      \expandafter\let\csname @#1\endcsname\@tempdate%
      \csname @#1@giventrue\endcsname%
      \csname @#1@givenhook\endcsname%
    \fi\fi\fi\fi\fi\fi%
  }
}
\@onlypreamble{\@DeclareDateField}

\newcommand*{\@Conflict}[2]{
  \expandafter\g@addto@macro\csname #1@givenhook\endcsname{%
    \expandafter\renewcommand\expandafter*\csname#2\endcsname[1]{\ClassError{tutthesis}{Can not mix #1 and #2}{}}%
  }
}
\@onlypreamble{\@Conflict}

\let\@metadatawritehook\@empty

\newcommand*{\@SimpleMetadata}[1]{
  % pdfx evaluates the xmpdata inside a group, so we need to define globally
  \g@addto@macro\@metadatawritehook{\expandafter\gdef\csname #1\endcsname##1{\ClassWarning{tutthesis}{Attempted to give #1 when metadata has already been written}}}
  \expandafter\@onlypreamble\csname#1\endcsname
}
\@onlypreamble{\@SimpleMetadata}

\newcommand*{\@DateMetadata}[1]{
  \g@addto@macro\@metadatawritehook{\expandafter\gdef\csname #1\endcsname##1##2##3{\ClassWarning{tutthesis}{Attempted to give #1 when metadata has already been written}}}
  \expandafter\@onlypreamble\csname#1\endcsname
}
\@onlypreamble{\@DateMetadata}

\newcommand*{\@abstractwritehook}{\@empty}
\newcommand*{\@TranslatedMetadata}[1]{
  \g@addto@macro\@metadatawritehook{\expandafter\gdef\csname #1\endcsname##1{\ClassWarning{tutthesis}{Attempted to give #1 when metadata has already been written. Give any translations inside otherlanguage after the first abstract}}}
  \g@addto@macro\@abstractwritehook{
    \expandafter\gdef\csname @#1\endcsname{\ClassWarning{tutthesis}{No translation for #1 given}}
    \expandafter\gdef\csname #1\endcsname##1{\expandafter\renewcommand\expandafter*\csname @#1\endcsname{##1}}
  }
}
\@onlypreamble{\@TranslatedMetadata}

% Not changing the core-defined title and author too much, as there might be packages that depend on them behaving a certain way

\@InitializeField{title}
\@InitializeField{titleB}
\renewcommand*{\title}[1]{\gdef\@title{#1}\@title@giventrue\@title@givenhook}
\g@addto@macro\@metadatawritehook{\gdef\title#1{\gdef\@title{#1}\ClassWarning{tutthesis}{Redefined \noexpand\title when metadata has already been written. Give any translations inside otherlanguage after the first abstract}}}
\g@addto@macro\@abstractwritehook{\gdef\@titleB{\ClassWarning{tutthesis}{No translation for title given}}\gdef\title#1{\gdef\@titleB{#1}}}

\@InitializeField{author}
\renewcommand*{\author}[1]{\gdef\@author{#1}\@author@giventrue\@author@givenhook}
\g@addto@macro\@metadatawritehook{\gdef\author#1{\gdef\@author{#1}\ClassWarning{tutthesis}{Redefined \noexpand\author when metadata has already been written}}}

\renewcommand*{\and}{\sep} % Pdfx expects \sep in metadata, we can redefine this locally

\def\@dropseparators#1-#2-#3\relax{#1#2#3}
\newcommand*{\SetPdfdate}[1]{%
  \newcommand*{\@pdfdate}{\relax}%
  \edef\@tempdate{\expandafter\@dropseparators#1\relax120000Z}% there's no date-only concept; 12 o'clock UTC is always the correct date
  \let\@pdfdate\@tempdate
}
\@DeclareDateField{datesubmitted}
\g@addto@macro{\@datesubmitted@givenhook}{\SetPdfdate{\@datesubmitted}}
\@Conflict{datesubmitted}{datetopicapproved}
\@Conflict{datesubmitted}{datethesisapproved}
\@DateMetadata{datesubmitted}

\@DeclareDateField{datetopicapproved}
\@Conflict{datetopicapproved}{datesubmitted}

\@DeclareDateField{datethesisapproved}
\g@addto@macro{\@datethesisapproved@givenhook}{\SetPdfdate{\@datethesisapproved}}
\@Conflict{datethesisapproved}{datesubmitted}
\@DateMetadata{datethesisapproved}

\newif\if@subjectcomplete
\@subjectcompletefalse
\newcommand*{\@trySetSubject}{%
  \if@thesistype@given\if@programme@given\if@major@given%
    \newcommand*{\@Subject}{\@thesistype, \@lowercasemajor. \@programme.}%
    \@subjectcompletetrue%
  \fi\fi\fi}

\@DeclareField{thesistype}
\@SimpleMetadata{thesistype}
\g@addto@macro{\@thesistype@givenhook}{\@trySetSubject}

\DeclareRobustCommand*\@DefineLowercasemajor{\gdef\@lowercasemajor}
\@DeclareField{major}
\@TranslatedMetadata{major}
\g@addto@macro{\@major@givenhook}{\MakeLowercase{\@DefineLowercasemajor{\@major}}\@trySetSubject}

\@DeclareField{programme}
\@TranslatedMetadata{programme}
\g@addto@macro{\@programme@givenhook}{\@trySetSubject}

\def\@DefineKeywords#1,#2\relax{%
  % For XMP, we want to trim spaces so we don't get <rdf:li> keyword</rdf>
  % We can do that by expanding the keyword as a roman number.
  % However, with PDFLatex, UTF-8 letters are active and expanding them yields the primitives used for printing.
  % Changing the inputenc to 8bit makes the letters expand to UTF bytes. The result is valid for XMP, but not for hyperref or printing
  % (With only LuaTeX this all would be a lot simpler, since non-ASCII letters are just letters)
  \newif\if@changeencoding\@changeencodingfalse%
  \ifluatex\else\ifxetex\else{\ifnum\catcode`^^c0 = 13\relax\aftergroup\@changeencodingtrue\fi}\fi\fi%
  \if@changeencoding\inputencoding{8bit}\fi%
  \newcommand*{\@Keywords}{#1}%
  \xdef\@XMPKeywords{#1}%
  \@for\kw:=#2\do{%
    \g@addto@macro\@Keywords{\sep}%
    \g@addto@macro\@XMPKeywords{\sep}%
    \expandafter\g@addto@macro\expandafter\@Keywords\expandafter{\kw}% we preserve the space here, so no space for \sep definition
    \edef\next{\noexpand\g@addto@macro\noexpand\@XMPKeywords{\romannumeral-`.\kw}}% we strip the space here
    \next%
  }%
  \if@changeencoding\inputencoding{utf8}\fi}
\@DeclareField{keywords}
\@TranslatedMetadata{keywords}
\g@addto@macro{\@keywords@givenhook}{\expandafter\@DefineKeywords\@keywords\relax}

% Defer hypersetup until after preamble since we don't yet have the infos available
\@AtPreambleEnd{%
  \ltx@ifpackageloaded{hyperref}{%
     % some options might be nicer to set in \PassOptionsToPackage, but that is broken by pdfx
     \edef\@langcode{\ltx@ifpackageloaded{babel}{\iflanguage{finnish}{fi}{\iflanguage{swedish}{sv}{en}}}{en}}% there is no support in babel for getting the ISO 639 code?
    \hypersetup{
      bookmarksnumbered=true,
      bookmarksdepth=2, % we're setting tocdepth=0 for the appendix, so explicitly set bookmarks depth to always make bookmarks for sections as well
      unicode=true, % is this implied by usage of pdfx and/or luatex?
      pdflang = \@langcode % pdfx should implement this... also, there's the different-language abstract, but no LaTeX tool supports setting multiple languages in PDFs
     }%
     \if@twoside\hypersetup{pdfpagelayout=TwoColumnRight}\fi%
     \ifdraft{\hypersetup{
       draft=false,
       linkbordercolor=[rgb]{1,0.7,0.7}, citebordercolor=[rgb]{0.7,1,0.7}, urlbordercolor=[rgb]{0.7,1,1},
       pdfborderstyle={/S/U/W 1}, pdfborder={0 0 0.5}
     }}{\hypersetup{hidelinks}}%
     \ltx@ifpackageloaded{pdfx}{}{%
       \hypersetup{pdfdisplaydoctitle=true} % pdfx bug (reported Sep 2017): it sets this but does nothing about hyperref, so the dict entry would be in the PDF twice if we weren't careful
       \hypersetup{psdextra}%
       \begingroup%
         \renewcommand*{\and}{; }%
         \newcommand*{\sep}{;}% careful with spaces
         % Not using pdfusetitle since the support for \and there is too recent (v6.86a) to be present in distributions
         \if@author@given\hypersetup{pdfauthor=\@author}\fi%
         \if@keywords@given\hypersetup{pdfkeywords=\@Keywords}\fi%
       \endgroup% we want the separators to be local, while the link color options are group-scoped
       \if@title@given\hypersetup{pdftitle=\@title}\fi%
       \if@subjectcomplete\hypersetup{pdfsubject=\@Subject}\fi%
       \ifx\@pdfdate\@undefined\else\hypersetup{pdfcreationdate={\@pdfdate}, pdfmoddate={\@pdfdate}}\fi%
      }%
    }{\ClassError{tutthesis}{Please load the package hyperref at the end of your preamble}{The package hyperref is required for links and metadata in PDFs. For compatibility reasons, the class can't require it, you must do it as the last package in your preamble.}}%

    \@metadatawritehook%
}


% Margins
% -------

% cancel out the core 1in margins
\setlength{\voffset}{-1in}
\setlength{\hoffset}{-1in}

% redefine what's set in the .clo

\setlength{\topmargin}{1.1cm}\setlength{\headheight}{5.5mm}\setlength{\headsep}{8.5mm}
\setlength{\textheight}{24.7cm}
\setlength{\skip\footins}{24\p@ \@plus 2\p@ \@minus 2\p@}
\setlength{\footskip}{8mm}

\setlength{\oddsidemargin}{4cm}\setlength{\evensidemargin}{2cm}
\setlength{\textwidth}{15cm}
\setlength{\marginparsep}{2mm}\setlength{\marginparwidth}{1.4cm}

\newlength{\@leadings}
\newcommand*{\@titlemargins}{%
  % normally, LaTeX will (subject to topskip) attempt to place the ascender on top of the text area, but trying to just put some vspace in there is messed up due to topskip
  \vspace*{-\topskip}% "baseline of first line is \baselineskip below top of text area"
  \setlength{\@leadings}{\baselineskip}\addtolength{\@leadings}{-\f@size pt}% this is why the font size needs to be set before the command
  \vspace*{-\@leadings}% "ascender of the first line is flush top of the text area" - and now further vspace works as expected
  \setlength{\parskip}{\z@}% normally parskip wouldn't be issued before first line on the page, but the vspace is treated as if a paragraph was already ended
  % even after all this, the vskips produced differ slightly from the corresponding Word settings - maybe to do with the fact that line height is defined separately for each font size in LaTeX
}


% Paragraphs and lines
% --------------------

\renewcommand\baselinestretch{1.142} % The guide gives line spacing as 1.2 in MS Office terms. In Office, the default "single" line spacing means a line skip of 1.15 times font size - meaning a line spacing of 1.2 results in line skip of 1.15*1.2*12pt=16.56pt. In size12.clo, lineskip is 14.5pt, so a stretch of 1.142 results in line skip of 1.142*14.5pt=16.56pt.
\@currsize
\newlength\@normalparskip \setlength\@normalparskip{12 \p@ \@plus 3\p@ \@minus 3\p@}
\setlength\parskip{\@normalparskip}
\newlength\@noparskip \setlength\@noparskip{0\p@ \@plus \p@}
\setlength\parindent{0\p@} % Override what's set in size12.clo

% Simply setting the linespacing would lead to an incorrect position of the line. This is especially visible when e.g. comparing the first lines of the bibliographic information and preface.
% On the other hand, where there is already topskip (captions), vskip would mess things up
\newcommand*{\@singlespacing}{\linespread{0.952}\selectfont}
\newcommand*{\@correctedsinglespacing}{%
  \vskip \baselineskip\relax%
  \@singlespacing%
  \vskip -\baselineskip\relax}

% With the default settings, LaTeX will easily produce overfull lines. This makes the line breaks behave a bit more like DTP solutions which will allow any amount of spacing rather than allowing lines to overflow
\newcommand*{\@titlelines}{%
    \setlength{\spaceskip}{.3600em \@plus .3600em \@minus .0167em}% default is .3333em plus .1667em, which is a tad tight for capitalized titles. Setting the default to be closer to the middle of the range also decreases the variance (although the distribution is probably not normal)
    \hyphenpenalty=75% increase penalty a bit, as hyphens in titles do not look that good (keep it the default for words that already have a hyphen)
}

\@AtPreambleEnd{%
  \providecommand{\setstretch}[1]{\def\baselinestretch{#1}\@currsize}%
  \providecommand{\setspace@singlespace}{0.952}%
  \ltx@ifpackageloaded{setspace}{\SetSinglespace{0.952}}%

  \ifpdf\else\ifxetex\else\ltx@ifpackageloaded{breakurl}{}{\ClassWarning{tutthesis}{If you're not using pdflatex, you should load the package breakurl to format URLs properly}}\fi\fi%
% with pdflatex the URLs are automatically broken to multiple lines, but with dvips/ps2pdf we need an extra package

}

% Font size commands
% ------------------

% Redefine size12.clo so that changing font does not mess up line spacing

% Displayskips not used as we are using fleqno

% It is possible that e.g. \small is issued inside a float or some other parskip-zeroing environment, and then we don't want to set the corresponding parskip
\newcommand{\@updateparskip}[1]{%
  \ifdim \parskip=\@normalparskip\relax%
    \setlength{\@normalparskip}{#1}%
    \setlength{\parskip}{#1}%
    \ltx@ifpackageloaded{natbib}{\setlength{\bibsep}{#1}}{}%
  \fi}

\renewcommand\small{%
   \@setfontsize\small\@xipt{13.6}%
   \@updateparskip{\@xipt\p@ \@plus 2.5\p@ \@minus 2.5\p@}}

\renewcommand\footnotesize{%
   \@setfontsize\footnotesize\@xpt\@xiipt%
   \@updateparskip{\@xpt\p@ \@plus 2\p@ \@minus 2\p@}}

\renewcommand\scriptsize{%
  \@setfontsize\scriptsize\@viiipt{9.5}%
  \@updateparskip{\@viiipt\p@ \@plus 1.5\p@ \@minus 1.5\p@}}

\renewcommand\tiny{%
  \@setfontsize\tiny\@vipt\@viipt%
  \@updateparskip{\@vipt\p@ \@plus \p@ \@minus \p@}}

% Although the differences in numbers (17.28 vs. 18, 14.4 vs. 14) seem small, using these custom sizes actually has a great effect in making it clear that the chapter titles of the front matter are smaller
\newcommand\@Normalsize{\@setfontsize\@Normalsize{14}{18}}% make the linesize 14.5/12*fontsize so that the stretches work consistently
\newcommand\@Larger{\@setfontsize\@Larger{18}{22}}


% Object placement
% ----------------


\renewcommand\floatpagefraction{.6} % was .5
\renewcommand\dblfloatpagefraction{.6} % was .5



% Headers and footers
% -------------------
\newcommand*{\@chapseparator}{.}

\newcommand*{\@datestringasiso}{\the\year-\ifnum \the\month<10 0\fi\the\month-\ifnum \the\day < 10 0\fi\the\day}
% Avoiding \selectlanguage due to an extra space in finnish.ldf producing unwanted whitespace. Maintainer has promised a fix, Sep 2017
\newcommand*{\@rightdraftfooter}{\as@main@language{\scriptsize\@draftnote\ \@datestringasiso\hfil\@title}}
\newcommand*{\@leftdraftfooter}{\as@main@language{\scriptsize\@title\hfil \@draftnote\ \@datestringasiso}}
\renewcommand*{\ps@plain}{% redefine LaTeX core ps@plain to move page number to header
  \let\@mkboth\@gobbletwo%
  \if@draftfooter%
    \let\@oddfoot\@rightdraftfooter\let\@evenfoot\@leftdraftfooter%
  \else%
    \let\@oddfoot\@empty\let\@evenfoot\@empty%
  \fi%
  \def\@oddhead{\reset@font\hfil\thepage}\def\@evenhead{\reset@font\thepage\hfil}%
}
\if@twoside
% "Mikali kaytat ylatunnisteessa otsikkoa, voit valita onko otsikko kaksipuolisessa asettelussa seka vasemmalla etta oikealla, vai vain oikealla" - 2017-08-29
  \renewcommand*{\ps@headings}{%
      \if@draftfooter%
        \let\@oddfoot\@rightdraftfooter\let\@evenfoot\@leftdraftfooter%
      \else%
        \let\@oddfoot\@empty\let\@evenfoot\@empty%
      \fi%
      \def\@evenhead{\thepage\hfil\as@main@language{\itshape\leftmark}}%
      \def\@oddhead{\as@main@language{\itshape\rightmark}\hfil\thepage}%
      \let\@mkboth\markboth
    \def\chaptermark##1{%
      \markboth {%
        \ifnum \c@secnumdepth >\m@ne
            \@chapapp\ \thechapter\@chapseparator \ %
        \fi
        ##1}{}}%
    \def\sectionmark##1{%
      \markright {%
        \ifnum \c@secnumdepth >\z@
          \thesection \ %
        \fi
        ##1}}}
\else
  \renewcommand*{\ps@headings}{%
    \if@draftfooter%
      \let\@oddfoot\@rightdraftfooter%
    \else%
      \let\@oddfoot\@empty%
    \fi%
    \def\@oddhead{\as@main@language{\itshape\rightmark}\hfil\thepage}%
    \let\@mkboth\markboth
    \def\chaptermark##1{%
      \markright {%
        \ifnum \c@secnumdepth >\m@ne
            \@chapapp\ \thechapter\@chapseparator \ %
        \fi
        ##1}}}
\fi


% Title page
% ----------

% If the user has not yet defined these, we would be trying to MakeUppercase a warning - producing an unhelpful compilation error. Add these checks to instead compile but with the user-readable warning

\@DeclareField{examiner}
\g@addto@macro\@abstractwritehook{\gdef\@examiner{\ClassWarning{tutthesis}{No translation for \noexpand\examiner given}}}

\newif\if@manyexaminers
\newcommand*{\@testexaminers}{\expandafter\tst@na\@examiner\and\nil}
\def\tst@na#1\and#2\nil{%
  \edef\@test{#2}%
  \ifx\@test\@empty\@manyexaminersfalse\else\@manyexaminerstrue\fi}

\let\justify@title\@titlelines
\let\raggedright@title\raggedright
  \renewcommand{\maketitle}[1][raggedright]{\begin{titlepage}%
    \sffamily%
    \includegraphics[width=8cm]{tty_logo_tupla}\par%
    \vskip 9.33cm%

    {\setstretch{1}\setlength{\parskip}{\p@}%
      {\@ifundefined{#1@title}{\ClassError{tutthesis}{Unknown option #1 passed to \noexpand\maketitle}{}}{\csname #1@title\endcsname}%
        \renewcommand*{\and}{ \&\ }%
        \bfseries\@Normalsize%
        \if@author@given\MakeUppercase{\@author}\else\@author\fi\par%
        \if@title@given\@MakeUppercase{\@title}\else\@title\fi\par%
      }%
      \@thesistype\par%
    }%

    \vfill%
    \hfill\begin{minipage}[t][4.4cm]{\textwidth-8.4cm}%
      \@singlespacing\setlength{\parskip}{\@normalparskip}%
      \renewcommand*{\and}{ \namesand\ }\@testexaminers%
      \if@manyexaminers\examinersheading\else\examinerheading\fi: \@examiner%

      \if@datetopicapproved@given
        \if@manyexaminers\examinersapprovedon\else\examinerapprovedon\fi\ \expandafter\@printtitlepagedate\@datetopicapproved\stopmark%
      \else\if@datesubmitted@given
        \submittedon\ \expandafter\@printtitlepagedate\@datesubmitted\stopmark%
      \else
        \ClassWarning{tutthesis}{No \noexpand\datetopicapproved or \noexpand\datesubmitted given}%
      \fi\fi\par
    \end{minipage}%
  \end{titlepage}%
  \global\let\maketitle\relax
  \global\let\date\relax
  % not clearing the values themselves as they are used for the PDF metadata and abstracts
}



% Section definitions
% -------------------


% \thechapter will be redefined in appendix
\renewcommand\@chapapp{\@gobble} % This is used like "chapapp space number", so instead of just emptying, let's eat the space. Will be redefined in appendix

\newcommand*{\chapter@cntformat}{\thechapter\@chapseparator\hskip.75em\relax}% the hskip should be no less than the maximum space skip
\newif\if@mainpartstarted
\@mainpartstartedfalse
\newcounter{chapterstar}

% Microsoft Word collapses consecutive margins and line spacings. This doesn't happen here, so the margins defined are smaller than the numbers in the guide

\renewcommand\chapter{\secdef\@chapterouter\@schapterouter}

\def\@chapterouter[#1]#2{%
                    \if@mainpartstarted%
                           \let\@firstchapter\@undefined%
                           \clearpage%
                    \else%
                           \def\@firstchapter{1}\@mainpartstartedtrue%
                           \clearpage{\thispagestyle{empty}\cleardoublepage}\pagenumbering{arabic}%
                    \fi%
                    \thispagestyle{plain}%
                    \global\@topnum\z@
                    \@afterindentfalse
                    \@chapter[#1]{#2}}
\def\@chapter[#1]#2{\ifnum \c@secnumdepth >\m@ne
                         \refstepcounter{chapter}%
                         \typeout{\@chapapp\space\thechapter.}%
                         \addcontentsline{toc}{chapter}%
                                   {\protect\numberline{\thechapter\@chapseparator}#1}%
                    \else
                      \addcontentsline{toc}{chapter}{#1}%
                    \fi
                    \ifx\@firstchapter\@undefined\else\addtocontents{toc}{\protect\setlength\parskip{\@noparskip}}\fi% deferring this until first line has been added, because otherwise the space after the heading would be affected
                    \chaptermark{#1}%
                    \if@numperchapter%
                      \ifx\@firstchapter\@undefined%
                        \addtocontents{lof}{\protect\addvspace{\@normalparskip}}%
                        \addtocontents{lot}{\protect\addvspace{\@normalparskip}}%
                        \ltx@ifpackageloaded{listings}{\addtocontents{lol}{\protect\addvspace{\@normalparskip}}}{}%
                      \else%
                        % eliminate the vspace before the first chapter in the listing
                        \addtocontents{lof}{\protect\vspace{-\@normalparskip}}%
                        \addtocontents{lot}{\protect\vspace{-\@normalparskip}}%
                        \ltx@ifpackageloaded{listings}{\addtocontents{lol}{\protect\vspace{-\@normalparskip}}}{}%
                      \fi%
                    \fi%
                    \@makechapterhead{#2}%
                    \@afterheading}
\renewcommand{\@makechapterhead}[1]{%
  \begingroup
    \@Larger%
    \@titlemargins%
    \vskip 29\p@%
    \@titlelines \normalfont%
    \bfseries \mathversion{bold} \sffamily%
    \ifnum\c@secnumdepth <\z@\@MakeUppercase{#1}\else\@hangfrom{\@MakeUppercase{\chapter@cntformat}}\interlinepenalty \@M\@MakeUppercase{#1}\fi\par\nobreak%
  \vskip 32\p@% by trial and error, 29/32 is what produces exactly the same results as the Word template - this is affected by multiple factors and is easy to break
  \endgroup}

\newcommand*{\@schapterouter}[1]{\clearpage%
                      \thispagestyle{plain}
                      \global\@topnum\z@
                      \@afterindentfalse
                      \@schapter{#1}}
\renewcommand*{\@schapter}[1]{\refstepcounter{chapterstar}%
                 \ltx@ifpackageloaded{hyperref}{\currentpdfbookmark{#1}{chs:\arabic{chapterstar}}}{}%
                 \@makeschapterhead{#1}%
                 \@afterheading}
\renewcommand{\@makeschapterhead}[1]{%
  \begingroup%
    \@Normalsize%
    \@titlemargins%
    \vskip 5\p@%
    \interlinepenalty\@M
    \bfseries \sffamily \MakeUppercase{#1}\par\nobreak%
    \vskip 7\p@ % Abstracts and content listings use a different parskip. Due to the "retroactive" nature, those environments need to be designed not to change parskip before the first line
  \endgroup%
  }
\renewcommand\section{\@startsection {section}{1}{\z@}%
                                   {6pt \@plus 1pt}%
                                   {1pt \@minus 0.5pt}% using 0pt and settling for the parskip would make more sense, but that actually removes the line break
                                   {\normalfont\@Normalsize\bfseries\sffamily}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}% "Kolmannen tason kirjaisinkoko on sama kuin toisen tason" - 2017-08-29
                                     {6pt \@plus 0.5pt}%
                                     {1pt \@minus 0.5pt}%
                                     {\normalfont\@Normalsize\bfseries\sffamily}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                                     {4pt \@plus 0.5pt}%
                                     {1pt \@minus 0.5pt}%
                                     {\normalfont\@Normalsize\sffamily}}
\renewcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
                                    {3pt \@plus 0.5pt}%
                                    {1pt \@minus 0.5pt}%
                                    {\normalfont\sffamily}}
\renewcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
                                       {2pt \@plus 0.5pt}%
                                       {1pt \@minus 0.5pt}%
                                      {\normalfont\small\sffamily}}



% Lists
% -----

% Redefine parts of size12.clo which hardwire paragraph spacing in lists
\let\@clolisti\@listi
\renewcommand*{\@listi}{\@clolisti
                        \topsep \z@
                        \parsep 2.75\p@ \@plus\p@ \@minus\p@
                        \itemsep\parsep}
\let\@listI\@listi
\@listi

\let\@clolistii\@listii
\renewcommand*{\@listii}{\@clolistii
                         \topsep    \z@
                         \parsep    2.25\p@ \@plus\p@ \@minus\p@
                         \partopsep \z@
                         \itemsep   \z@}
\let\@clolistiii\@listiii
\renewcommand*{\@listiii}{\@clolistiii
                         \topsep    \z@
                         \partopsep \z@
                         \itemsep   \z@}

\setlength\parsep {0pt}
\setlength\itemsep {0pt}



\setlength{\leftmargini} {2.2em}
\leftmargin\leftmargini
\setlength{\leftmarginii}{2.2em}


% Abstracts
% ---------
\newcounter{bodypages}
\newcounter{appendixpages}
\newcommand*{\@countpages}{%
  \ifx\r@FirstAppendixPage\@undefined%
    \setcounter{bodypages}{\getpagerefnumber{FinalPage}}%
    \setcounter{appendixpages}{\z@}%
  \else%
    \setcounter{bodypages}{\getpagerefnumber{FirstAppendixPage}}
    \addtocounter{bodypages}{-1}
    \setcounter{appendixpages}{\getpagerefnumber{FinalPage}}
    \addtocounter{appendixpages}{-\value{bodypages}}
  \fi}

\@DeclareField{thesisdescription}
\g@addto@macro\@abstractwritehook{\gdef\@thesisdescription{\ClassWarning{tutthesis}{No translation for \noexpand\thesisdescription given}}}

  \renewenvironment{abstract}{%
    \@countpages%
    \chapter*{\abstractname}%

    \@correctedsinglespacing%
    {\sffamily%
      {\renewcommand*{\and}{ \& }%
        \textbf{\if@author@given\MakeUppercase{\@author}\else\@author\fi}: \ifx\@mainTitlePrinted\@undefined \@title\global\let\@mainTitlePrinted\@ne\else\@titleB\fi%
        %if we set the parskip before the first line, that would affect the space after the heading
        \setlength{\parskip}{0.8pt}\par% make multiline titles stand out a tiiny bit
        \universityname\par%
        \@thesisdescription, \thebodypages\ \pagesheading\ifnum \value{appendixpages}>0 , \theappendixpages\ \ifnum\value{appendixpages}=1\appendixpageheading\else\appendixpagesheading\fi\fi\par% If there is no appendix "Voit jattaa talloin liitesivut mainitsematta" - 2017-08-29
        \if@datethesisapproved@given%
          \expandafter\@printmonthyear\@datethesisapproved\stopmark%
        \else\if@datesubmitted@given%
          \expandafter\@printmonthyear\@datesubmitted\stopmark
        \else%
          \ClassWarning{tutthesis}{No \noexpand\datethesisapproved or \noexpand\datesubmitted given}%
        \fi\fi\par%
        \@programme\par%
        \majorheading: \@major\par%
        \@testexaminers\renewcommand*{\and}{ \namesand\ }%
        \if@manyexaminers\examinersheading\else\examinerheading\fi: \@examiner\par%
      }%
      \keywordsheading: \@keywords\par%
    }%
  }%
  {\@abstractwritehook\par\vfil\null\newpage}


% Other environments
% ------------------

\renewenvironment{quotation}
               {\@singlespacing%
               \list{}{\listparindent 1.5em%
                        \rightmargin   \leftmargin
                        \parsep        \z@ \@plus\p@}%
                \item\relax}
               {\endlist}

\renewenvironment{titlepage}
    {%
      \newpage
      \thispagestyle{empty}%
      \setcounter{page}\@ne
    }%
    {\if@twoside\clearpage{\thispagestyle{empty}\cleardoublepage}\else
        \cleardoublepage
     \fi
     \pagenumbering{roman}%
    }

% Appendix
% --------

\newcommand*{\appendixnumberline}[1]{\MakeUppercase{\appendixname}\ #1\ } % this will be used inside a string that will be passed to \uppercase, but that will not uppercase the appendixname. We have to do the uppercasing in two passes, with only \uppercase working for the outer and only \MakeUppercase working for the inner...
\let\report@appendix\appendix
\renewcommand\appendix{%
  \report@appendix%
  \renewcommand*{\@chapseparator}{:}% For the header
  \renewcommand\chapter@cntformat{\appendixname\ \thechapter\@chapseparator\ \hskip.15em}% the space can already stretch quite a much bit the title spacing, so no need for a lot of extra spacing
  \addtocontents{toc}{%
    \protect\setcounter{tocdepth}{0}% only appendix titles, no sections in TOC
    \let\protect\numberline\protect\appendixnumberline% fixes TOC line formatting, which by default is not suitable for long thechapter
    \protect\renewcommand*{\protect\l@chapter}{\vskip\@normalparskip\protect\@dottedtocline{0}{0em}{0em}}% remove hanging indent and produce paragraph spacing after each appendix line
  }%
  % We want thechapter to be just "A" to be able to make references like "Liitteessa A", but we don't want the hyperref bookmarks to be just the bare "A"
  % Furthermore, the standard ToC numberline isn't very good for the words appendix/liite, which have a different length
  \ltx@ifpackageloaded{hyperref}{\let\old@Hy@numberline\Hy@numberline}{\let\old@numberline\numberline}
  \def\appendixchapternumberline##1{\appendixname\ ##1\ }%
  \let\old@chapter\chapter%
  \renewcommand{\chapter}[1]{%
    \ltx@ifpackageloaded{hyperref}{%
      \let\Hy@numberline\appendixchapternumberline%
      \old@chapter{##1}%
      \let\Hy@numberline\old@Hy@numberline%
    }{%
      \let\numberline\appendixchapternumberline%
      \old@chapter{##1}%
      \let\numberline\old@numberline%
    }}
  \clearpage%
  \label{FirstAppendixPage}}



% Figures, equations and tables
% -----------------------------

\setlength\doublerulesep{\p@} % default makes superscripts overlap borders

\RequirePackage{remreset}

\if@numperchapter\else\@removefromreset{equation}{chapter}\fi
\renewcommand\theequation
  {\if@numperchapter\ifnum \c@chapter>\z@ \thechapter.\fi\fi \@arabic\c@equation}

\if@numperchapter\else\@removefromreset{figure}{chapter}\fi
\renewcommand \thefigure
     {\if@numperchapter\ifnum \c@chapter>\z@ \thechapter.\fi\fi \@arabic\c@figure}
\renewenvironment{figure}[1][tbp]
                 {\@float{figure}[#1]\begin{center}}
                 {\end{center}\end@float}

\if@numperchapter\else\@removefromreset{table}{chapter}\fi
\renewcommand \thetable
     {\if@numperchapter\ifnum \c@chapter>\z@ \thechapter.\fi\fi \@arabic\c@table}
\renewenvironment{table}[1][tbp]
               {\@float{table}[#1]\begin{center}}
               {\end{center}\end@float}

\setlength\abovecaptionskip{\medskipamount}
\setlength\belowcaptionskip{\medskipamount}

% This will handle most of the singlespacing for captions, figures, listings etc. Tabular has another \@singlespacing because it may be used outside of floats
\let\core@xfloat=\@xfloat
\def\@xfloat #1[#2]{\core@xfloat #1[#2]\@singlespacing} % Note that LaTeX floats (alongside with some other environments) already set the parskip to zero
\renewcommand{\@makecaption}[2]{%
  \vskip\abovecaptionskip%
  {\if@centeredcaptions\centering\fi\emph{\textbf{#1}.\enskip #2}\par}%
  \vskip\belowcaptionskip}

% Could not find a "how to write a caption.sty-compatible document class" guide, so using this awful brute force... Patching \document to issue the DeclareCaptionDefault* would be less of a hack, but might be prone to breakage if other packages set further caption stylings? At least this way, the defaults are set when caption.sty is loaded, i.e. at the time they would for the supported classes
\PassOptionsToPackage{singlelinecheck=off}{caption}
\newcommand*\caption@ifamsclass{%
  \let\caption@CheckCommand\@gobbletwo%
  \if@centeredcaptions\DeclareCaptionDefaultJustification{\centering}\fi%
  % caption is inside a float which are already patched to have single spacing, so no need to set it again
  \DeclareCaptionDefaultFont{font}{\itshape}%
  \DeclareCaptionDefaultFont{labelfont}{\bfseries}%
  \DeclareCaptionLabelSeparator{default}{.\enskip}%
  \@gobble}

% 1) set line spacing so that also tables outside floats look nicer, 2) compensate for the line spacing difference, not only the usual but also the difference between lineskip and font size which causes misalignment even when using linestretch 1
\let\core@tabular\tabular
\renewcommand\tabular{\vspace{\arraystretch\baselineskip}\@singlespacing\vspace{-\f@size pt}\core@tabular}
\@AtPreambleEnd{%
  \ltx@ifpackageloaded{array}{%
    \let\array@tabular\tabular%
    \renewcommand\tabular{\vspace{\arraystretch\baselineskip}\@singlespacing\vspace{-\f@size pt}\array@tabular}%
  }{}%
  \ltx@ifpackageloaded{tabularx}{%
    \let\tabularx@tabularx\tabularx%
    \renewcommand\tabularx{\vspace{\arraystretch\baselineskip}\@singlespacing\vspace{-\f@size pt}\tabularx@tabularx}%
  }{}%

  % Put in a block like this to make sure if the user loads the amsmath package, the eqref from that package is enabled without conflict
  \providecommand*{\eqref}[1]{\textup{(\ref{#1})}}%

  \ltx@ifpackageloaded{listings}{%
    \lstset{aboveskip=\@normalparskip, belowskip=\@normalparskip, abovecaptionskip=\abovecaptionskip, captionpos=b}%
    \if@numperchapter\else\lstset{numberbychapter=false}\fi%
  }{}%
}


% Content listings
% ----------------

\renewcommand\@dotsep{0}
\renewcommand\tableofcontents{%
    \let\oldnumberline\numberline
    \chapter*{\contentsname}%
    \vskip -4\p@ \@plus -\p@% negate the first chapterline-preceding vskip added by l@chapter
    \@starttoc{toc}%
    % restore the changes made by \appendix
    \let\numberline\oldnumberline%
    \setcounter{tocdepth}{3}}% mainly needed for \listoflistings

% \l@chapter won't just receive a plain text chapter name, it will receive a combination of the name and a non-printed link - the latter will break if we try to MakeUppercase. Therefore we need to uppercase the chapter name before hyperref adds the link, as per https://groups.google.com/d/msg/comp.text.tex/eiLmTiZjKcM/hIncdzjnU_oJ
\AtBeginDocument{%
  \ifx\MakeTextUppercase\@undefined\let\@MakeUppercase\MakeUppercase\else\let\@MakeUppercase\MakeTextUppercase\fi
  \ltx@ifpackageloaded{hyperref}{%
    \let\ORG@contentsline\contentsline%
    \def\contentsline#1#2{%
      \expandafter\ifx\csname l@#1\endcsname\l@chapter
        \expandafter\@firstoftwo
      \else
        \expandafter\@secondoftwo
      \fi {\ORG@contentsline{#1}{\@MakeUppercase{#2}}}{\ORG@contentsline{#1}{#2}}%
    }%
  }{}}
\renewcommand*\l@chapter{\vskip 4\p@ \@plus \p@\@dottedtocline{0}{0em}{0.85cm}}
\renewcommand*\l@section{\@dottedtocline{1}{1cm}{1cm}}
\renewcommand*\l@subsection{\@dottedtocline{2}{2cm}{1.5cm}}
\renewcommand*\l@subsubsection[2]{\@empty}
\renewcommand*\l@paragraph[2]{\@empty}
\renewcommand*\l@subparagraph[2]{\@empty}


\renewcommand\listoffigures{%
    \chapter*{\listfigurename}%
    \let\oldnumberline\numberline%
    \renewcommand{\numberline}[1]{\textbf{\oldnumberline{\figurename\ ##1.}}}%
    \@starttoc{lof}%
    \let\numberline\oldnumberline%
    }

\def\@cursivedottedtocline#1#2#3#4#5{\@dottedtocline{#1}{#2}{#3}{\emph{#4}}{#5}}
\renewcommand*\l@figure{\@cursivedottedtocline{0}{0em}{2.5cm}}
\renewcommand\listoftables{%
    \chapter*{\listtablename}%
    \let\oldnumberline\numberline%
    \renewcommand{\numberline}[1]{\textbf{\oldnumberline{\tablename\ ##1.}}}%
    \@starttoc{lot}%
    \let\numberline\oldnumberline%
    }
\let\l@table\l@figure

\@AtPreambleEnd{%
  % Listings by default uses the \tableofcontents command for list of listings, and that would be very inconsistent with LOF/LOT
  \ltx@ifpackageloaded{listings}{%
    \renewcommand{\lstlistoflistings}{%
      \chapter*{\lstlistlistingname}%
      \let\oldnumberline\numberline%
      \renewcommand{\numberline}[1]{\textbf{\oldnumberline{\lstlistingname\ ##1.}}}%
      \@starttoc{lol}%
      \let\numberline\oldnumberline%
    }%
    \let\l@lstlisting\l@figure%
  }{}%
}

\AtBeginDocument{%
  % reset parskip for TOC/LOF/etc. and do it after the first line so the first body text line is always at the same height
  % (this has already been redefined by hyperref, hence the ABD)
  \let\old@addcontentsline\addcontentsline%
  \renewcommand*{\addcontentsline}[3]{%
    \old@addcontentsline{#1}{#2}{#3}%
    \@ifundefined{added@#1@parskip}{%
      \addtocontents{#1}{\protect\setlength\parskip{\@noparskip}}%
      \global\expandafter\let\csname added@#1@parskip\expandafter\endcsname\@ne%
    }{}%
  }%

}

% Bibliography
% ------------
\setlength\bibindent{3em}
% natbib supports KOMA script classes by using bib@heading if defined - we utilize the same "interface" for documentclass->natbib interaction
\newcommand*{\bib@heading}{%
  \setcounter{secnumdepth}{-1}%
  \ltx@ifpackageloaded{hyperref}{\phantomsection}{}%
  \chapter{\bibname}%
  \setcounter{secnumdepth}{2}}

\PassOptionsToPackage{noisbn,noissn}{babelbib}
\@AtPreambleEnd{%
  \ltx@ifpackageloaded{natbib}{%
    \setcitestyle{aysep={}}%
    \setlength{\bibhang}{0pt}%
    \setlength{\bibsep}{\parskip}}{}%
  \ifx\urlstyle\@undefined\else\urlstyle{same}\fi}

% The environment gets redefined if natbib (required for name-year) is used
\renewenvironment{thebibliography}[1]
     {\bib@heading%
      \setlength\labelsep{1.5em}%
      \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      \setlength\itemsep{\@normalparskip}%
      \addtolength\itemsep{-\parsep}%
      \sloppy
      \clubpenalty4000
      \@clubpenalty \clubpenalty
      \widowpenalty4000%
      \sfcode`\.\@m}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}



% Vocabulary
% ----------

\renewcommand\bibname{References} % Changed from "Bibliography"

% Caution - if you forget to comment out whitespace between lines a space will be printed in e.g. the bibliography when switching languages
\newcommand*{\defineenglish}{%
  \def\namesand{and}%
  \def\examinerheading{Examiner}%
  \def\examinersheading{Examiners}%
  \def\examinerapprovedon{The examiner and topic of the the\-sis were approved on}%
  \def\examinersapprovedon{The examiners and topic of the the\-sis were approved on}%
  \def\submittedon{Submitted for review on}%
  \def\universityname{Tampere University of Technology}%
  \def\pagesheading{pages}%
  \def\appendixpageheading{Appendix page}%
  \def\appendixpagesheading{Appendix pages}%
  \def\majorheading{Major}%
  \def\keywordsheading{Keywords}%
  \def\@printmonthyear##1-##2-##3\stopmark{\ifcase0##2\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi \space ##1}%
  \def\@printtitlepagedate##1-##2-##3\stopmark{\number##3\ \@printmonthyear##1-##2-##3\stopmark}%
  \def\draftnote{draft}%
}
\defineenglish
% If babel is not used, the above English definitions are in effect. If babel is used with [english, finnish] then the above definitions are overridden with Finnish ones when the document starts, and then overridden again when the {otherlanguage}{english} is used

\AtBeginDocument{%
  \@ifpackagewith{babel}{finnish}{%
    \addto\captionsfinnish{%
      \def\namesand{ja}%
      \def\examinerheading{Tarkastaja}%
      \def\examinersheading{Tarkastajat}%
      \def\examinerapprovedon{Tarkastaja ja aihe hyv\"{a}ksytty}%
      \def\examinersapprovedon{Tarkastajat ja aihe hyv\"{a}ksytty}%
      \def\submittedon{J\"{a}tetty tarkastettavaksi}%
      \def\universityname{Tampereen teknillinen yliopisto}%
      \def\pagesheading{sivua}%
      \def\appendixpageheading{liitesivu}%
      \def\appendixpagesheading{liitesivua}%
      \def\majorheading{P\"{a}\"{a}aine}%
      \def\keywordsheading{Avainsanat}%
      \def\contentsname{Sis\"{a}llysluettelo}%
      \def\listfigurename{Kuvaluettelo}%
      \def\listtablename{Taulukkoluettelo}%
      \def\bibname{L\"{a}hteet}%
      \def\@printmonthyear#1-#2-#3\stopmark{\ifcase0#2\or
      Tammikuu\or Helmikuu\or Maaliskuu\or Huhtikuu\or Toukokuu\or Kes\"{a}kuu\or
      Hein\"{a}kuu\or Elokuu\or Syyskuu\or Lokakuu\or Marraskuu\or Joulukuu\fi \space #1}%
      \def\@printtitlepagedate#1-#2-#3\stopmark{\number#3. \ifcase0#2\or
      tammikuuta\or helmikuuta\or maaliskuuta\or huhtikuuta\or toukokuuta\or kes\"{a}kuuta\or
      hein\"{a}kuuta\or elokuuta\or syyskuuta\or lokakuuta\or marraskuuta\or joulukuuta\fi \space #1}%
      \def\draftnote{luonnos}%
    }%
  }{}%
  \@ifpackagewith{babel}{english}{%
    \addto\captionsenglish{%
      \defineenglish%
      \def\bibname{References}% override Babel
    }%
  }{}%
  \ifx\bbl@main@language\@undefined%
    \let\as@main@language\@firstofone%
    \let\@draftnote\draftnote
  \else%
    \newcommand*{\as@main@language}[1]{\expandafter\foreignlanguage\expandafter{\bbl@main@language}{#1}}%
    {\csname captions\bbl@main@language\endcsname\global\let\@draftnote\draftnote}
  \fi%
}


% Initial settings at document start
% ----------------------------------
\pagestyle{plain}
\pagenumbering{alph} % visible only in PDF reader


% Miscellaneous
% -------------
\@AtPreambleEnd{\providecommand*{\todo}[1]{\marginpar{\scriptsize{#1}}}}


% External packages
% -----------------

% In case a package is built assuming definitions from report, load these last

% Use fonts that have a uniform look with the Times New Roman / Arial used on the MS Office side

\RequirePackage{ifxetex}
\ifnum 0\ifxetex 1\fi\ifluatex 1\fi>0
  \RequirePackage{fontspec}
  \newcommand*\@variantoptions{Extension=.otf, UprightFont=*-regular,BoldFont=*-bold,ItalicFont=*-italic,BoldItalicFont=*-bolditalic}
  \setmainfont{texgyretermes}[\@variantoptions] % 
  \setboldmathrm{texgyretermes-bold}[Extension=.otf, BoldFont=*,ItalicFont=*italic,BoldItalicFont=*italic] % see https://github.com/wspr/fontspec/issues/307
  \setsansfont{texgyreheros}[\@variantoptions]
  \setmonofont{texgyrecursor}[\@variantoptions]
  \@AtPreambleEnd{%
    \ltx@ifpackageloaded{unicode-math}{}{\usepackage[math-style=ISO]{unicode-math}}%
    \setmathfont{texgyretermes-math}[Extension=.otf, BoldFont=*]%

    % see https://github.com/wspr/unicode-math/issues/404 and https://github.com/wspr/unicode-math/issues/407
    \setmathfontface\mathit{texgyretermes-italic.otf}%
    \setmathfontface\mathit{texgyretermes-bolditalic.otf}[version=bold]%
    \setmathfontface\mathbf{texgyretermes-bold.otf}%
    \setmathfontface\mathsf{texgyreheros-regular.otf}%
    \setmathfontface\mathsf{texgyreheros-bold.otf}[version=bold]%
    \setmathfontface\mathtt{texgyrecursor-regular.otf}%
  }
\else
  \RequirePackage{mathptmx}
  \RequirePackage{helvet}
  \DeclareMathAlphabet{\mathsf}{OT1}{phv}{m}{n}
  \SetMathAlphabet{\mathsf}{bold}{OT1}{phv}{b}{n}
  \RequirePackage{courier}
  \DeclareMathAlphabet{\mathtt}{OT1}{pcr}{m}{n}
  \SetMathAlphabet{\mathtt}{bold}{OT1}{pcr}{b}{n}
  \RequirePackage[T1]{fontenc} % Use actual non-ASCII glyphs instead of composing diacritics (eg. umlauted characters)

  % pdfx for some reason resets inputencoding every time it sets a field, flooding the log with messages and overloading the Overleaf log handling (warnings get swallowed). Let's do this weird hack to disable \wlog during \inputencoding
  \let\orig@wlog\wlog
  \renewcommand*{\wlog}[1]{%
    \ifx\DeclareUnicodeCharacter\@undefined\else\ifx\DeclareUnicodeCharacter\relax\else%
      \ifx\orig@DUC\@undefined%
        \let\orig@DUC\DeclareUnicodeCharacter%
      \fi%
      \ifx\DeclareUnicodeCharacter\orig@DUC%
        \renewcommand*{\DeclareUnicodeCharacter}[2]{\begingroup\let\wlog\@gobble\orig@DUC{##1}{##2}\endgroup}%
      \fi%
    \fi\fi%
    \orig@wlog{#1}}
\fi

% For specifying the titlepage minipage width relative to \textwidth
\RequirePackage{calc}

% We need to load this here in the class to get the title page logo
\RequirePackage{graphicx}

% To get page counts for the abstract
\RequirePackage{refcount}
\RequirePackage{ltxcmds}
\RequirePackage{atveryend}
\AfterLastShipout{%
  \if@mainpartstarted % writer is starting from scratch - we'll leave the last page ref undefined and getpagerefcounter will return 0 (defining the ref in this case we'd get compilation failure, trying to do math with Roman numbers)
  \addtocounter{page}{-1}%
  \ltx@ifpackageloaded{showkeys}{%
    \@ifpackagewith{showkeys}{final}{}{%
      \message{^^J}%
      \message{Class tutthesis Warning: Package showkeys without option final loaded, but the internally used label FinalPage on page \thepage\space cannot be shown, as it is written directly to the \jobname.aux file. ^^J}}}{}%
  % we only need the label for page count, we never actually refer to it, so no need to take hyperref precautions
  \if@filesw%
    \ltx@ifpackageloaded{nameref}{%
      \immediate\write\@auxout{\string\newlabel{FinalPage}{{}{\thepage}{}{}{}}}%
    }{%
      \immediate\write\@auxout{\string\newlabel{#1}{{}{#2}}}%
    }%
  \fi%
  \addtocounter{page}{+1}%
  \fi}

\RequirePackage{url}
\RequirePackage{ifdraft}
% Hyperref not loaded on class side for compatibility reasons

\endinput
%%
%% End of file `report.cls'.