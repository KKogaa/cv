\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{altacv}[2023/06/27 AltaCV v1.6.5c, yet another alternative class for a resume/curriculum vitae, now forked.]

\DeclareOption{academicons}{\ClassWarning{altacv}{academicons option is now obsolete and unnecessary.}}
\newif\if@normalphoto
\DeclareOption{normalphoto}{\@normalphototrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{extarticle}}
\newif\if@raggedtwoe
\DeclareOption{ragged2e}{\@raggedtwoetrue}
\newif\if@withhyper
\DeclareOption{withhyper}{\@withhypertrue}
\newif\ifdarkmode
\DeclareOption{darkmode}{\darkmodetrue}
\ProcessOptions\relax

\LoadClass{extarticle}
\RequirePackage{etoolbox}
\RequirePackage[a-1b]{pdfx}
\RequirePackage{accsupp}
\RequirePackage[margin=2cm]{geometry}
\RequirePackage[fixed]{fontawesome5}
\RequirePackage{ifxetex,ifluatex}
\RequirePackage{scrlfile}
\RequirePackage{xparse}

\newif\ifxetexorluatex
\ifxetex
	\xetexorluatextrue
\else
	\ifluatex
		\xetexorluatextrue
	\else
		\xetexorluatexfalse
	\fi
\fi

\ifxetexorluatex
	\RequirePackage{fontspec}
\else
	\RequirePackage{cmap}
	\RequirePackage[utf8]{inputenc}
	\RequirePackage[T1]{fontenc}
	\input{glyphtounicode}
	\pdfglyphtounicode{f_f}{FB00}
	\pdfglyphtounicode{f_f_i}{FB03}
	\pdfglyphtounicode{f_f_l}{FB04}
	\pdfglyphtounicode{f_i}{FB01}
	\pdfgentounicode=1
\fi

\if@raggedtwoe
	\RequirePackage[newcommands]{ragged2e}
\fi

\if@withhyper
	\AtBeginDocument{%
		\hypersetup{hidelinks}
		\urlstyle{same}
	}
\fi

\RequirePackage{xcolor}
\newcommand{\itemmarker}{{\small\textbullet}}
\newcommand{\ratingmarker}{\faCircle}

\RequirePackage{tikz}
\usetikzlibrary{arrows}
\RequirePackage[skins]{tcolorbox}
\RequirePackage[inline]{enumitem}
\setlist{leftmargin=*,labelsep=0.5em,nosep,itemsep=0.25\baselineskip,after=\vspace{0.25\baselineskip}}
\setlist[itemize]{label=\itemmarker}
\RequirePackage{graphicx}
\RequirePackage{trimclip}
\RequirePackage{dashrule}
\RequirePackage{multirow,tabularx}
\RequirePackage{changepage}
% \RequirePackage{marginfix}

\setlength{\parindent}{0pt}
\newcommand{\divider}{\textcolor{body!30}{\hdashrule{\linewidth}{0.6pt}{0.5ex}}\medskip}

\newenvironment{fullwidth}{%
	\begin{adjustwidth}{}{\dimexpr-\marginparwidth-\marginparsep\relax}}
		{\end{adjustwidth}}

\newcommand{\utffriendlydetokenize}[1]{%
\scantokens{%
\catcode`\_=12%
%   \catcode`\^=12%
%   \catcode`\{=12%
%   \catcode`\}=12%
\catcode`\&=12%
\catcode`\$=12%
\catcode`\#=12%
\catcode`\~=12%
%   \catcode`\\=12%
{#1}%
}%
}
\ExplSyntaxOn
\NewDocumentCommand{\printinfo}{m m o}{%
	\BeginAccSupp{method=escape,ActualText={#1:~#2}}
	\IfNoValueTF{#3}{%
		\mbox{\textcolor{accent}{\normalfont #1}~\utffriendlydetokenize{#2}\hspace{2em}}%
	}{%
		\if@withhyper%
			\mbox{\textcolor{accent}{\normalfont #1}~
				\href{#3}{\utffriendlydetokenize{#2}}\hspace{2em}}
		\else%
			\ClassWarning{Please specify [withhyper] option to enable hyperlinks. Printing out full hyperlink prefix #1 for now.}%
			\mbox{\textcolor{accent}{\normalfont #1}~{\utffriendlydetokenize{#3#2}}\hspace{2em}}%
		\fi%
	}%
	\EndAccSupp{}
}%


\NewDocumentCommand{\NewInfoField}{s m m o}{%
	\IfBooleanF{#1}{
		\IfNoValueF{#4}{\csdef{#2 hyperprefix}{#4}}%
	}
	\csdef{#2 symbol}{#3}%
	\IfBooleanTF{#1}
	{ \csdef{#2}##1##2{%
			\if@withhyper
				\IfNoValueTF {##2}
				{\printinfo{\csuse{#2 symbol}}{##1}}%
				{\printinfo{\csuse{#2 symbol}}{##1}[##2]}%
			\else
				\printinfo{\csuse{#2 symbol}}{##1}%
			\fi%
		}%
	}
	{ \csdef{#2}##1{%
			\if@withhyper
				\IfNoValueTF {#4}
				{\printinfo{\csuse{#2 symbol}}{##1}}%
				{\printinfo{\csuse{#2 symbol}}{##1}[\csuse{#2 hyperprefix}##1]}%
			\else
				\printinfo{\csuse{#2 symbol}}{##1}%
			\fi%
		}%
	}
}
\ExplSyntaxOff

\newcommand{\name}[1]{\def\@name{#1}}
\newcommand{\tagline}[1]{\def\@tagline{#1}}
\newcommand{\personalinfo}[1]{\def\@personalinfo{#1}}
\NewInfoField{email}{\faAt}[mailto:]
\NewInfoField{mailaddress}{\faEnvelope}
\NewInfoField{phone}{\faPhone}[tel:]
\NewInfoField{homepage}{\faGlobe}[https://]
\NewInfoField{twitter}{\faTwitter}[https://twitter.com/]
\NewInfoField{linkedin}{\faLinkedin}[https://linkedin.com/in/]
\NewInfoField{github}{\faGithub}[https://github.com/]
\NewInfoField{orcid}{\faOrcid}[https://orcid.org/]
\NewInfoField{location}{\faMapMarker}
\NewInfoField{dev}{\faDev}[https://dev.to/]
\NewInfoField{medium}{\faMedium}[https://medium.com/@]
\NewInfoField{npm}{\faNpm}[https://www.npmjs.com/~]

\newlength{\altacv@photos@width}
\newlength{\altacv@photo@diam@left}
\newlength{\altacv@photo@diam@right}
\def\altacv@left@photos{}
\def\altacv@right@photos{}

\newcommand{\@makeaphoto}[2]{%
	\begin{minipage}{#1}%
		\if@normalphoto
			\includegraphics[width=\linewidth]{#2}
		\else
			\tikz\filldraw[color=headingrule, fill overzoom image={#2}, ultra thick](-1,0) circle[radius=0.5\linewidth];
		\fi%
	\end{minipage}%
}

\newcommand{\altacv@add@photo@left}[1]{%
	\appto{\altacv@left@photos}{%
		\@makeaphoto{\altacv@photo@diam@left}{#1}\hspace{6,5ex}%
	}%
	\addtolength{\altacv@photos@width}{\altacv@photo@diam@left}%
	\addtolength{\altacv@photos@width}{1ex}%
}
\newcommand{\altacv@add@photo@right}[1]{%
	\appto{\altacv@right@photos}{%
		\@makeaphoto{\altacv@photo@diam@right}{#1}\hspace{6,5ex}%
	}%
	\addtolength{\altacv@photos@width}{\altacv@photo@diam@right}%
	\addtolength{\altacv@photos@width}{1ex}%
}
\newcommand{\photoL}[2]{%
	\setlength{\altacv@photo@diam@left}{#1}%
	\forcsvlist{\altacv@add@photo@left}{#2}%
}
\newcommand{\photoR}[2]{%
	\setlength{\altacv@photo@diam@right}{#1}%
	\forcsvlist{\altacv@add@photo@right}{#2}%
}
\let\photo\photoR

\newcommand{\namefont}{\Huge\bfseries}
\newcommand{\taglinefont}{\large\bfseries}
\newcommand{\personalinfofont}{\large\bfseries}
\newcommand{\cvsectionfont}{\LARGE\bfseries}
\newcommand{\cvsubsectionfont}{\large\bfseries}

\newcommand{\makecvheader}{%
	\begingroup
	\altacv@left@photos\hfill%
	\begin{minipage}{\dimexpr\linewidth-\altacv@photos@width}%
		\raggedright%
		{\namefont\color{name}\MakeUppercase{\@name}\par}
		\medskip
		{\taglinefont\color{tagline}\@tagline\par}
		\medskip
		{\personalinfofont\@personalinfo\par}
	\end{minipage}\hfill%
	\altacv@right@photos\par%
	\endgroup\medskip
}

\renewenvironment{quote}{\color{accent}\itshape\large}{\par}

\newcommand{\cvsection}[2][]{%
\bigskip%
\bigskip%
\ifstrequal{#1}{}{}{\marginpar{\vspace*{\dimexpr1pt-\baselineskip}\raggedright\input{#1}}}%
{\color{heading}\cvsectionfont\MakeUppercase{#2}}\\[-1ex]%
{\color{headingrule}\rule{\linewidth}{2pt}\par}
\medskip
}

\newcommand{\cvsubsection}[1]{%
	\smallskip%
	{\color{subheading}\cvsubsectionfont{#1}\par}
	\medskip
}

\newcommand{\cvevent}[4]{%
	{\large\color{emphasis}#1}
	\ifstrequal{#2}{}{}{\large{\color{accent} | #2}}
	\par\medskip\normalsize
	\ifstrequal{#3}{}{}{{\small\makebox[0.5\linewidth][l]{\color{accent}\faCalendar\color{emphasis}~#3}}}
	\ifstrequal{#4}{}{}{{\small\makebox[0.5\linewidth][l]{\color{accent}\faMapMarker\color{emphasis}~#4}}}\par
	\medskip\normalsize
}

\newcommand{\cvreference}[2]{
	\textcolor{accent}{\href{#2}{#1}}
}

\newcommand{\cvachievement}[3]{%
	\begin{tabularx}{\linewidth}{@{}p{2em} @{\hspace{1ex}} >{\raggedright\arraybackslash}X@{}}
		\multirow{2}{*}{\Large\color{accent}#1} & \bfseries\textcolor{emphasis}{#2} \\
		                                        & #3
	\end{tabularx}%
	\smallskip
}

\newcommand{\cvline}[3]{%
	\begin{tabularx}{\linewidth}{@{}p{0.1em} @{\hspace{1ex}} >{\raggedright\arraybackslash}X@{}}
		\multirow{2}{*}{\Large\color{accent}#1} & \bfseries\textcolor{emphasis}{#2} \\
		                                        & #3
	\end{tabularx}%
	% \smallskip
}


\newcommand{\cvtags}[1]{%
	\foreach \tagValue in {#1} {%
			\cvtag{\tagValue}
		}
}

\newcommand{\cvtag}[1]{%
	\tikz[baseline]\node[anchor=base,draw=body,rounded corners,inner xsep=1ex,inner ysep=0.75ex,text height=1.5ex,text depth=.25ex]{#1};
	\vspace{0.25ex}
}

\newcommand{\cvskill}[2]{%
\textcolor{emphasis}{\textbf{#1}}\hfill
\BeginAccSupp{method=plain,ActualText={#2}}
\foreach \x in {1,...,5}{%
\ifdimequal{\x pt - #2 pt}{0.5pt}%
{\clipbox*{0pt -0.25ex {.5\width} {\totalheight}}{\color{accent}\ratingmarker}%
\clipbox*{{.5\width} -0.25ex {\width} {\totalheight}}{\color{body!30}\ratingmarker}}
{\ifdimgreater{\x bp}{#2 bp}{\color{body!30}}{\color{accent}}\ratingmarker}%
}\EndAccSupp{}\par%
}

\newcommand{\cvlang}[2]{%
	\textcolor{emphasis}{\textbf{#1: }}
	\textcolor{accent}{\textbf{#2}}
}

\newcommand{\wheelchart}[4][0]{%
	\begingroup\centering
	\def\innerradius{#3}%
	\def\outerradius{#2}%
	\pgfmathsetmacro{\totalnum}{0}%
	\foreach \value/\colour/\name in {#4} {%
			\pgfmathparse{\value+\totalnum}%
			\global\let\totalnum=\pgfmathresult%
		}%
	\begin{tikzpicture}

		\pgfmathsetmacro{\wheelwidth}{\outerradius-\innerradius}
		\pgfmathsetmacro{\midradius}{(\outerradius+\innerradius)/2}
		\pgfmathsetmacro{\totalrot}{-90 + #1}

		\begin{scope}[rotate=\totalrot]

			\pgfmathsetmacro{\cumnum}{0}
			\foreach \value/\width/\colour/\name in {#4} {
					\pgfmathsetmacro{\newcumnum}{\cumnum + \value/\totalnum*360}

					\pgfmathsetmacro{\percentage}{\value/\totalnum*100}
					\pgfmathsetmacro{\midangle}{-(\cumnum+\newcumnum)/2}

					\pgfmathparse{
						(-\midangle>180?"west":"east")
					} \edef\textanchor{\pgfmathresult}
					\pgfmathparse{
						(-\midangle>180?"flush left":"flush right")
					} \edef\textalign{\pgfmathresult}
					\pgfmathsetmacro\labelshiftdir{1-2*(-\midangle<180)}

					\filldraw[draw=white,fill=\colour] (-\cumnum:\outerradius) arc (-\cumnum:-(\newcumnum):\outerradius) --
					(-\newcumnum:\innerradius) arc (-\newcumnum:-(\cumnum):\innerradius) -- cycle;

					\draw  [*-,thin,emphasis] node [append after command={(\midangle:\midradius pt) -- (\midangle:\outerradius + 1ex) -- (\tikzlastnode)}] at (\midangle:\outerradius + 1ex) [xshift=\labelshiftdir*0.5cm,inner sep=1ex, outer sep=0pt, text width=\width,anchor=\textanchor,align=\textalign,font=\small,text=body]{\BeginAccSupp{method=pdfstringdef,ActualText={\name: \value}}\name\EndAccSupp{}};
					\global\let\cumnum=\newcumnum
				}
		\end{scope}
		%      \draw[gray] (0,0) circle (\outerradius) circle (\innerradius);
	\end{tikzpicture}\par
	\endgroup
}

\newcommand{\cvref}[3]{%
	\textcolor{emphasis}{\textbf{#1}}\par
	\smallskip
	\begin{description}[font=\color{accent},style=multiline,leftmargin=1em,align=left]
		\def\temp{#2}\ifx\temp\empty
		\else
		\item[\faLinkedin] \href{https://linkedin.com/in/#2}{#2}
			\fi

			\def\temp{#3}\ifx\temp\empty
			\else
		\item[\small\normalfont\mailaddresssymbol] \href{mailto:#3}{#3}
			\fi
	\end{description}
}

\newenvironment{cvcolumn}[1]{\begin{minipage}[t]{#1}\raggedright}{\end{minipage}}

\RequirePackage{afterpage}
\newcommand{\addsidebar}[2][]{\marginpar{%
		\ifstrequal{#1}{}{}{\vspace*{#1}}%
		\input{#2}}%
}
\newcommand{\addnextpagesidebar}[2][]{\afterpage{\addsidebar[#1]{#2}}}

\RequirePackage{pgffor}
\def\my@namelist{}
\newcommand{\mynames}[1]{\def\my@namelist{#1}}
\newtoggle{boldname}
\AddToHook{package/biblatex/after}{
	\renewcommand*{\mkbibnamefamily}[1]{%
		\global\togglefalse{boldname}%
		\foreach \my@fname / \my@gname in \my@namelist {%
			\ifboolexpr{ test {\ifdefstrequal{\namepartfamily}{\my@fname}}
				and
				test {\ifdefstrequal{\namepartgiven}{\my@gname}}}
			{\global\toggletrue{boldname}}{}%
		}%
		\iftoggle{boldname}{\textbf{#1}}{#1}%
	}

	\renewcommand*{\mkbibnamegiven}[1]{%
		\global\togglefalse{boldname}%
		\foreach \my@fname / \my@gname in \my@namelist{%
			\ifboolexpr{ test {\ifdefstrequal{\namepartfamily}{\my@fname}}
				and
				test {\ifdefstrequal{\namepartgiven}{\my@gname}}}
			{\global\toggletrue{boldname}\breakforeach}{}%
		}%
		\iftoggle{boldname}{\textbf{#1}}{#1}%
	}
}

\AddToHook{begindocument/before}{%
	\pagestyle{empty}
	\color{body}
	\raggedright
}
