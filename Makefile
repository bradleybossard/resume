path = ./
docs-path = docs/
resume-basename = resume-of-bradley-bossard

all: html pdf docx rtf

# Add hack below to strip out link to PDF when generating PDF version.
# TODO(bradleybossard) : Fix a more elegant way to do this.
pdf: resume.pdf
resume.pdf: resume.md
	cat resume.md | grep -v REMOVEPDF | sed 's/<!-- REMOVEHTML -->//g' > resume_pdf.md;
	pandoc --standalone --template style.tex \
	--from markdown \
	--to context \
	-V papersize=A4 \
	-V fontsize=16pt \
  -V 'mainfont:Font-Regular.otf' \
	-V 'mainfontoptions:BoldFont=Font-Bold.otf, ItalicFont=Font-Italic.otf, BoldItalicFont=Font-BoldItalic.otf' \
	-o $(path)$(resume-basename).tex resume_pdf.md; \
	context $(path)$(resume-basename).tex --result=$(path)$(resume-basename).pdf;
	cp $(path)$(resume-basename).pdf $(docs-path)$(resume-basename).pdf;
	rm resume_pdf.md;

html: resume.html
resume.html: style.css resume.md
	cat resume.md | grep -v REMOVEHTML > resume_html.md;
	pandoc --standalone -H style.css \
        --from markdown \
				--to html \
        -o $(path)index.html resume_html.md
	rm resume_html.md;

docx: resume.docx
resume.docx: resume.md
	cat resume.md | grep -v REMOVEPDF > resume_doc.md;
	pandoc -s resume_doc.md -o $(path)$(resume-basename).docx
	rm resume_doc.md;

rtf: resume.rtf
resume.rtf: resume.md
	pandoc -s resume.md -o $(path)$(resume-basename).rtf

clean:
	rm index.html
	rm $(path)$(resume-basename).tex
	rm $(path)$(resume-basename).tuc
	rm $(path)$(resume-basename).log
	rm $(path)$(resume-basename).pdf
	rm $(path)$(resume-basename).docx
	rm $(path)$(resume-basename).rtf
