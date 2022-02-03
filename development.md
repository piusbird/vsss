# Development 

VSSS is intended to provide people with dyslexia, CVI, Palsy related eye control issues, or similar disabilities. What are commonly known in the biz as **print related disabilities** with a simple way to use their Linux/Unix machines to start reading quickly. To this end it is written in an unconventional way. By using tooling and libraries the user is already likely to have installed the hope is, we enable the user to get started within five minutes. To this end the main bulk of the code is written as a shell script. With optional components written in C and Python.

To keep the code from degenerating into an unusable mess (again), I have a few rules for possible future contributors.

* Do Not introduce bashisms. Although we run best under bash for now. The user should be able to get some functionality with any posix conforming /bin/sh. When I have time I plan to document, and tackle the odd bugs under dash and mksh
* Follow Google's Shell Guide https://google.github.io/styleguide/shellguide.html
* Only, shell script, C, Python, and Perl components are permitted 
* C programs should use the standard library, and math. e.g. -lc -lm. Maybe X11 in future
* Python and perl programs should be limited in their dependencies such that they depend only on standard modules or what comes installed with a standard XFCE installation. And should follow style for the language involved. E.g pep8.

## Mailing list


There is a mailing list at https://lists.sr.ht/~marnold128/disabled-linuxing For discussion, patch sends and so forth.

## Pull Requests
Please use git send-email and the above mailing list for that, and not github's pull request feature for such things. But if you *need* to use a github pull request as a reasonable accommodation send an email to the list, and Matt will take care of formatting your submission correctly.

## Code of Conduct

We don't need one at the moment. Just conduct yourself with charity and grace. And don't bring any forms of capitalist heteropatriarchal oppression into our spaces please. THAT INCLUDES ABLEISM ;) 

