#lang scribble/manual

@title[#:version ""]{Apertiumpp-kaz}

@author["Ilnar Salimzianov"]

@hyperlink["https://github.com/taruen/apertiumpp/tree/master/apertiumpp-kaz"]{This
directory} contains our effort to proofread
@hyperlink["https://github.com/apertium/apertium-kaz/"]{apertium-kaz's} lexicon
against the 15-volume [Explanatory] Dictionary of Literary Kazakh (``Қазақ
Әдеби Тілінің Сөздігі''), published by Kazakh
@hyperlink["https://tbi.kz"]{Linguistics Institute} in 2011 (EDOK2011), and the
single-volume [Explanatory] Dictionary of Kazakh (``Қазақ Сөздігі''), published
by the @hyperlink["https://tbi.kz"]{Linguistics Institute} and Kazakh
@hyperlink["https://mks.gov.kz/kaz/informery/komitety/k_ya_opr/"]{Language
Commitee} in 2013 (EDOK2013). The goal is to solve issue
@hyperlink["https://github.com/apertium/apertium-kaz/issues/11"]{#11} of
@italic{apertium-kaz}, as well as to extend it with more stems, especially with
common words (as opposed to proper nouns).

In particular, the file
@hyperlink["https://github.com/taruen/apertiumpp/blob/master/apertiumpp-kaz/lexicon.rkt"]{lexicon.rkt}
in this directory contains common words from
@hyperlink["https://github.com/apertium/apertium-kaz/blob/master/apertium-kaz.kaz.lexc"]{apertium-kaz/apertium-kaz.kaz.lexc},
revised and extended with more stems from the aforementioned print
dictionaries.

We plan to merge the results back to @italic{apertium-kaz} once we're done
proof-reading it.

In the meantime, we provide
 @hyperlink["https://github.com/taruen/apertiumpp/blob/master/apertiumpp-kaz/apertium-kaz.kaz.lexc"]{our
 own version} of @italic{apertium-kaz.kaz.lexc} as a drop-in
 replacement for @italic{apertium-kaz}'s file of the same name, as
 well a slightly modified
 @hyperlink["https://github.com/taruen/apertiumpp/blob/master/apertiumpp-kaz/apertium-kaz.kaz.lexc"]{Makefile.am}
 for it. To use @italic{apertium-kaz} with our modifications to it,
 you should:

@itemlist[#:style 'ordered

@item{Install
@hyperlink["http://wiki.apertium.org/wiki/Install_Apertium_core_using_packaging"]{Apertium
Core}: @verbatim|{wget https://apertium.projectjj.com/apt/install-nightly.sh -O
- | sudo bash}| @verbatim|{sudo apt-get -f install apertium-all-dev }| OR
@verbatim|{wget https://apertium.projectjj.com/rpm/install-nightly.sh -O - |
sudo bash}| @verbatim|{sudo yum install apertium-all-devel}| or similar,
depending on what kind of GNU/Linux distibution you are using. See
@hyperlink["http://wiki.apertium.org/wiki/Install_Apertium_core_using_packaging"]{this
article} for more information. For Windows users, Apertium project provides
@hyperlink["http://wiki.apertium.org/wiki/Apertium_VirtualBox"]{a Virtualbox
image} with all necessary tools installed on it. If you're using the Virtualbox
image, you should simply continue with the next step.}

@item{Dowload apetium-kaz: @verbatim|{git clone https://github.com/apertium/apertium-kaz.git}|}

@item{Replace @italic{apertium-kaz/apertium-kaz.kaz.lexc} file with the file
@hyperlink["https://github.com/taruen/apertiumpp/blob/master/apertiumpp-kaz/apertium-kaz.kaz.lexc"]{that
we provide}.}

@item{Replace @italic{apertium-kaz/Makefiel.am} file with the file
@hyperlink["https://github.com/taruen/apertiumpp/blob/master/apertiumpp-kaz/Makefile.am"]{that
we provide}.}

@item{Compile apertium-kaz: @verbatim|{cd apertium-kaz; ./autogen.sh; make}|}

]

Here's a brief comparison of the two main characteristics of
@italic{apertium-kaz}'s state before and after our modifications to it:

@tabular[#:sep @hspace[1] #:style 'boxed
  (list
    (list @bold{Number of stems in .lexc before} @bold{Number of stems in .lexc after})
    (list "~38k" "~98k"))]

@tabular[#:sep @hspace[1] #:style 'boxed
  (list
    (list "" @bold{Naive coverage before} @bold{Naive coverage after})
    (list @bold{Bibel} "x" "y")
    (list @bold{Wikipedia} "92.38 91.73 89.86  => avrg. " "94.79 94.57 91.83 => avrg. "))]

Here's how @italic{apertiumpp-kaz} is different from @italic{apertium-kaz}.

@itemlist[#:style 'ordered

  @item{The main list of stems, @italic{lexicon.rkt}, is implemented in a
  full-fledged programming language
  (@hyperlink["https://racket-lang.org/"]{Racket}), and not in the
  Xerox/Helsinki Finite State Toolkit's @italic{lexc} formalism.}

  @item{This list of stems is consumed by a
  @hyperlink["https://docs.racket-lang.org/scribble-pp/text.html"]{scribble/text}-based
  template, @italic{apertium-kaz.kaz.lexc.scrbl}. A normal
  @italic{apertium-kaz.kaz.lexc} file is generated when @verbatim{racket apertium-kaz.kaz.lexc.scrbl}
  command is run.}

  @item{As opposed to the 3-element data structure of a @italic{lexc}
  (upper-side string, lower-side string, continuation lexicon), with other
  marks being comments formatted in a particular way by convention, the main
  datatype of @italic{lexicon.rkt} is an @italic{Entry} with 7 fields,
  representing the following information:

  @itemlist[

    @item{upper-side string}
    
    @item{lower-side string}

    @item{continuation lexicon(s)}

    @item{a gloss and various (restrictional) marks such as USE/MT, DIR/LR,
    DIR/RL etc}

    @item{inflected forms of this word, which were unnecessarily lexicalised in
    the @italic{.lexc} file we proofread (or were lexicalised by the authors of
    the print dictionaries, but we thought it wasn't necessary to lexicalise
    them in the transducer)}

    @item{stem from which this stem has been derived from in a semi-productive
    way, or a chain of such stems}

    @item{normative spelling(s) of this word}

  ]}

  @item{In the source code, entries can be wrapped up with function calls,
  which modify entries in various ways (or not), depending on how the functions
  in question are defined, and, ultimately, what defaults a particular
  application of @italic{apertium-kaz} calls for.}

]

Below are four examples of entries, named as E-1, E-2, E-3 and E-4 for easy
re-use in tests.

@(racketblock

(define E-1 (e "абдаста" "абдаста" 'N1 '() '() '() '("әбдесте")))
(define E-2 (e "абдикация" "абдикация" 'N1 '() '() '() '()))
(define E-3 (e "абдырат" "абдырат" 'V-IV `("confuse,embarras" ,USE/MT) '("абдырату") '("абдыра") '()))
(define E-4 (e "абыр-дабыр" "абыр-дабыр" '(IDEO N1) '() '() '() '()))

)

Commentaries on @bold{why} and @bold{how} these modifications were
made follow.

@section{Why these paper dictionaries were chosen as a source of new entries?}

We have chosen the 15-volume and single-volume explanatory dictionaries of
Kazakh as a reference because they are:

@itemlist[

@item{comprehensive,}

@item{up-to-date,}

@item{authoritative,}

@item{developed by publicly-financed organisations, responsible for language
policy in Kazakhstan, and @bold{not} commercial companies.}

]

Individual words (entry words, to be exact, which interest us in this project
and which we have extracted from the dictionaries) are not copyrightable per
se, but the later point is a further safeguard that we are not violating
anyone's rights.

@section{How stems were added to lexicon.rkt?}

First of all, we copied all common words from
@italic{apertium-kaz.kaz.lexc}. By common words we mean words which are not
proper nouns. This includes open-class words (nouns, verbs, adjectives,
adverbs), but also closed-class or functional words like pronouns, determiners,
postpositions etc.

With few rare exceptions, entry words contained in the single-volume EDOK2013
are a superset of those contained in the 15-volume EDOK2011. The size of the
latter is due example usages and more elaborate explanations.

Therefore, we proceeded as follows:

@itemlist[

@item{extracted text from EDOK2013's pdf file}

@item{converted entries in it into (entry word, rest of the entry) pairs,
separated by tabs}

@item{labeled the first N entry words with the right categories, using
@hyperlink["https://github.com/IlnarSelimcan/dot/blob/master/lexikograf.py"]{lexikograf.py}}

]

Lexikograf.py expects two command-line arguments: a dictionary in plain text
format, and a number BATCH_SIZE. Lines in the dictionary of the following form:

@verbatim{label \tab entry word \tab rest of the entry}

serve as training data.

Lines in the following form:

@verbatim{entry word \tab rest of the entry}

are lines for which lexikograf.py will suggest a label, and the user is
requested to either mark the suggested label as correct or, if it is not, to
type in the correct label.

After having seen BATCH_SIZE new observations, lexikograf.py adds these new
observations to the training data, and (re)trains a MaxEnt (aka multinomial
logistic regression) classifier. At each step, the annotation process is backed
up in ws.pickle file as a WorldState, which is compound data structure
consisting of the <classifier, labeled entries, unlabeled entries>.

Apparently we labeled 754 entries in this way, after which the number
errors lexikograf.py made seemed negligible, so that we made it label
the rest of the entries and added the entry words to
@italic{lexikon.rkt}, if such (word, continuation lexicon pairs) were
not present in it already.

@section{Proof-reading lexicon.rkt}

As described in the previous section, @italic{lexicon.rkt} is a union of
entries from two sources:

@itemlist[#:style 'ordered

@item{common words of the original @italic{apertium-kaz.kaz.lexc} file, and}

@item{entry words from EDOK2013 (first 757 of which were hand-labeled with
correct continuation marks, the rest with labels @italic{lexikograf.py}'s
classifier has assigned to them)}

]

The resulting @italic{lexikograf.rkt} requires manual cheking because:

@itemlist[#:style 'ordered

@item{errors from the original @italic{apertium-kaz.kaz.lexc} got carried over
(see issue
@hyperlink["https://github.com/apertium/apertium-kaz/issues/11"]{#11}}

@item{lexikograf.py might have labeled words from EDOK2013 inccorrectly (read:
they have a wrong continuation lexicon in lexicon.rkt)}

]

For mitigating both errors, we open up both @italic{lexicon.rkt} and EDOK2011,
and read both in parallel. We proof-read @italic{lexicon.rkt} against EDOK2011,
and not against EDOK2013, because the explanations of the former are more
elaborate, and, more importantly, it includes example usage sentences for each
entry word / sense.

For most of the words in @italic{lexicion.rkt}, reading explanations or
examples was not necessary, as it was apparent whether their continuation
classes were correct or not, for some, reading example sentences was crucial.
Notably, they were helpful for figuring out whether a verb was transitive or
intransitive, or whether an adjective was A1 or A2. As a side note, we decided
to restrict the possible continuation classes for adjectives two two (A1 and
A2), thus eliminating A3 and A4 entirely. The only difference between an A1
adjective and A2 adjective is that the former is actually both an adjective and
an adverb, and thus can modify both nouns and verbs, while the latter is not is
used solely as an attribute in a sentence.

@section{Acknowledgements}

This work is being funded by the Committee of Science of the Ministry of
Education and Science of the Republic of Kazakhstan, contract#
346/018-2018/33-28, IRN AP05133700, principal investigator Zhenisbek
Assylbekov.

@section{License}

Just like @italic{apertium-kaz}, the contents of this repo are published under
GPL version 3.