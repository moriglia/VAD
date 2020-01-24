default: clean report.pdf

%.tex:
		pdflatex -draftmode -interaction nonstopmode -output-directory . $@

%.pdf : %.tex
		pdflatex -interaction nonstopmode -output-format pdf -output-directory . $<

clean:
		rm -f $(shell find . -name '*.aux' -name '*.log' -name '*.toc')
