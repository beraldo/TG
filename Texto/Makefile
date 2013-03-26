FILE=tg2
LATEX=pdflatex
BIBTEX=bibtex



all: pdf clean


pdf:
	# Compila duas vezes para gerar sumário, links internos, indexação etc
	$(LATEX) $(FILE).tex
	makeglossaries $(FILE)
	$(BIBTEX) $(FILE)
	$(LATEX) $(FILE).tex
	$(LATEX) $(FILE).tex



clean:
	rm -f *.xdy *.aux *.out *.lof *.log *.lol *.toc *.idx *.bbl *.blg *.brf *.lot *.acn *.glo *.ist *.syg *.acr *.alg *.glg *.gls *.slg *.syi



cleanup: clean
	rm -f *.pdf
